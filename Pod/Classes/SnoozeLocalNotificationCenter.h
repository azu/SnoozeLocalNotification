//
// Created by azu on 2014/07/01.
//


#import <Foundation/Foundation.h>

@interface SnoozeLocalNotificationCenter : NSObject
+ (instancetype)center;
// schedule notification and snooze
- (void)schedule:(UILocalNotification *) localNotification snoozeMinutes:(NSArray *) snoozeMinutes;

// cancel all snooze notifications
- (void)cancelAllSnooze;
// cancel unnecessary notifications.
/* e.g) notificationA -> snoozeX -> snoozeY
 * Notify notificationA, then user launch app.
 * snoozeX and snoozeY are unnecessary notifications.
 */
- (void)cancelUnnecessarySnooze;
// cancel notification and snooze
- (void)cancelSnoozeForNotification:(UILocalNotification *) aNotification;
@end