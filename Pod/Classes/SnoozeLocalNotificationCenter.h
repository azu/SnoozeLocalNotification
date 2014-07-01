//
// Created by azu on 2014/07/01.
//


#import <Foundation/Foundation.h>

@interface SnoozeLocalNotificationCenter : NSObject
+ (instancetype)center;

- (void)schedule:(UILocalNotification *) snoozeLocalNotification snoozeMinutes:(NSArray *) snoozeMinutes;

- (void)cancelAllSnooze;

- (void)cancelSnoozeForNotification:(UILocalNotification *) aNotification;
@end