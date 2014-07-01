//
// Created by azu on 2014/07/01.
//


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
    [snoozeMinutes enumerateObjectsUsingBlock:^(NSNumber *minutesObject, NSUInteger idx, BOOL *stop) {
        UILocalNotification *notification = [localNotification copy];
        NSDate *fireDate = [baseFireDate dateByAddingTimeInterval:(SECONDS_IN_MINUTE * [minutesObject floatValue])];
        notification.fireDate = fireDate;
        NSMutableDictionary *userInfo = [notification.userInfo mutableCopy];
        if (!userInfo) {
            userInfo = [NSMutableDictionary dictionary];
        }
        [userInfo setObject:baseFireDate forKey:SNOOZE_NOTIFICATION_KEY];
        notification.userInfo = userInfo;
        [self p_scheduleLocalNotification:notification];
    }];
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
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        if ([notification.userInfo[SNOOZE_NOTIFICATION_KEY] isEqual:aNotification.userInfo[SNOOZE_NOTIFICATION_KEY]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
        }
    }];
}
@end
