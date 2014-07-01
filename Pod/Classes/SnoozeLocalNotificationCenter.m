//
// Created by azu on 2014/07/01.
//


#import <Kiwi/KWValue.h>
#import "SnoozeLocalNotificationCenter.h"

#define SNOOZE_NOTIFICATION_KEY @"SNOOZE_NOTIFICATION_KEY"
#define SECONDS_IN_MINUTE 60

@implementation SnoozeLocalNotificationCenter {

}
#pragma mark - Singleton methods

static SnoozeLocalNotificationCenter *_sharedManager = nil;

+ (instancetype)center {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)copyWithZone:(NSZone *) zone {
    return self;
}

- (void)schedule:(UILocalNotification *) localNotification snoozeMinutes:(NSArray *) snoozeMinutes {
    NSAssert(snoozeMinutes != nil, @"You have to pass snoozeMinutes.");
    NSDate *baseFireDate = [localNotification.fireDate copy];
    localNotification.userInfo = [self map:baseFireDate notification:localNotification];
    [self p_scheduleLocalNotification:localNotification];
    [snoozeMinutes enumerateObjectsUsingBlock:^(NSNumber *minutesObject, NSUInteger idx, BOOL *stop) {
        UILocalNotification *notification = [localNotification copy];
        NSDate *fireDate = [baseFireDate dateByAddingTimeInterval:(SECONDS_IN_MINUTE * [minutesObject floatValue])];
        notification.fireDate = fireDate;
        notification.userInfo = [self map:baseFireDate notification:notification];
        [self p_scheduleLocalNotification:notification];
    }];
}

- (NSMutableDictionary *)map:(NSDate *) baseFireDate notification:(UILocalNotification *) notification {
    NSMutableDictionary *userInfo = [notification.userInfo mutableCopy];
    if (!userInfo) {
        userInfo = [NSMutableDictionary dictionary];
    }
    [userInfo setObject:@([baseFireDate timeIntervalSince1970]) forKey:SNOOZE_NOTIFICATION_KEY];
    return userInfo;
}

- (void)p_scheduleLocalNotification:(UILocalNotification *) localNotification {
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelAllSnooze {
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        if (notification.userInfo[SNOOZE_NOTIFICATION_KEY]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }];
}

- (void)cancelSnoozeForNotification:(UILocalNotification *) aNotification {
    if (aNotification == nil) {
        return;
    }
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        if ([notification.userInfo[SNOOZE_NOTIFICATION_KEY] isEqualToNumber:aNotification.userInfo[SNOOZE_NOTIFICATION_KEY]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }];
    [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
}
@end
