//
// Created by azu on 2014/07/01.
//


#import <SnoozeLocalNotification/SnoozeLocalNotificationCenter.h>

@interface SnoozeHelper : NSObject
+ (void)reset;

+ (NSArray *)scheduled;
@end

@implementation SnoozeHelper
+ (void)reset {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

+ (NSArray *)scheduled {
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}
@end

SPEC_BEGIN(SnoozeLocalNotificationCenterSpec)
    beforeEach(^{
        [SnoozeHelper reset];
    });
    describe(@"-schedule:snoozeMinutes:", ^{
        __block UILocalNotification *localNotification;
        NSArray *snoozeMinutes = @[@10, @30, @60];
        beforeEach(^{
            localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate date];
            localNotification.alertBody = @"message";
        });
        it(@"should shcedule notification * snoozeMinutes.count", ^{
            [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            [[[SnoozeHelper scheduled] should] haveCountOf:snoozeMinutes.count];
        });
        it(@"shedule notification has UserInfo", ^{
            [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            UILocalNotification *resultNotification = [[SnoozeHelper scheduled] firstObject];
            [[resultNotification.userInfo shouldNot] beNil];
        });
    });
    describe(@"-cancelAllSnooze", ^{
        context(@"When has notification without snooze", ^{
            beforeEach(^{
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate distantFuture];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            });
            it(@"should not cancel notification", ^{
                [[SnoozeLocalNotificationCenter center] cancelAllSnooze];
                [[[SnoozeHelper scheduled] should] haveCountOf:1];
            });
        });
        context(@"When has snooze notification", ^{
            __block UILocalNotification *localNotification;
            NSArray *snoozeMinutes = @[@10, @30, @60];
            beforeEach(^{
                localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [NSDate date];
                localNotification.alertBody = @"message";
                [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            });
            it(@"should cancel notification", ^{
                [[SnoozeLocalNotificationCenter center] cancelAllSnooze];
                [[[SnoozeHelper scheduled] should] haveCountOf:0];
            });
        });
    });
SPEC_END