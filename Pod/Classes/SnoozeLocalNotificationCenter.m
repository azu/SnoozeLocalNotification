//
// Created by azu on 2014/07/01.
//


#import "SnoozeLocalNotificationCenter.h"

#define SNOOZE_NOTIFICATION_KEY @"SNOOZE_NOTIFICATION_KEY"
#define SNOOZE_NOTIFICATION_PRIMARY_KEY @"SNOOZE_NOTIFICATION_PRIMARY_KEY"
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
    NSUUID *uuid = [NSUUID UUID];
    NSDate *baseFireDate = [localNotification.fireDate copy];
    [snoozeMinutes enumerateObjectsUsingBlock:^(NSNumber *minutesObject, NSUInteger idx, BOOL *stop) {
        UILocalNotification *notification = [localNotification copy];
        NSDate *fireDate = [baseFireDate dateByAddingTimeInterval:(SECONDS_IN_MINUTE * [minutesObject floatValue])];
        notification.fireDate = fireDate;
        notification.userInfo = [self map:uuid.UUIDString notification:notification];
        [self p_scheduleLocalNotification:notification];
    }];

    NSMutableDictionary *mutableDictionary = [self map:uuid.UUIDString notification:localNotification];
    [mutableDictionary setObject:uuid.UUIDString forKey:@"SNOOZE_NOTIFICATION_PRIMARY_KEY"];
    localNotification.userInfo = mutableDictionary;
    [self p_scheduleLocalNotification:localNotification];
}

- (NSMutableDictionary *)map:(id) uuid notification:(UILocalNotification *) notification {
    NSMutableDictionary *userInfo = [notification.userInfo mutableCopy];
    if (!userInfo) {
        userInfo = [NSMutableDictionary dictionary];
    }
    [userInfo setObject:uuid forKey:SNOOZE_NOTIFICATION_KEY];
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

- (void)cancelUnnecessarySnooze {
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSMutableArray *primaryKeyList = [self collectPrimaryKey:scheduledLocalNotifications];
    // missing primary notification , then the notification is unnecessary
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *localNotification, NSUInteger idx, BOOL *stop) {
        NSString *uuidString = localNotification.userInfo[SNOOZE_NOTIFICATION_KEY];
        if (uuidString == nil) {
            return;
        }
        if (![primaryKeyList containsObject:uuidString]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];

        }
    }];
}

- (NSMutableArray *)collectPrimaryKey:(NSArray *) scheduledLocalNotifications {
    NSMutableArray *primaryKeyList = [NSMutableArray array];
    NSString *primaryKey = [NSString stringWithFormat:@"userInfo.%@", SNOOZE_NOTIFICATION_PRIMARY_KEY];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        id value = [notification valueForKeyPath:primaryKey];
        if (value) {
            [primaryKeyList addObject:value];
        }
    }];
    return primaryKeyList;
}


- (void)cancelSnoozeForNotification:(UILocalNotification *) aNotification {
    if (aNotification == nil) {
        return;
    }
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        if ([notification.userInfo[SNOOZE_NOTIFICATION_KEY] isEqualToString:aNotification.userInfo[SNOOZE_NOTIFICATION_KEY]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }];
    [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
}
@end
