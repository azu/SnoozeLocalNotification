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
            localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1000];
            localNotification.alertBody = @"message";
        });
        it(@"should shcedule notification * snoozeMinutes.count + 1", ^{
            [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            [[[SnoozeHelper scheduled] should] haveCountOf:(snoozeMinutes.count + 1)];
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
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1000];
                localNotification.alertBody = @"message";
                [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            });
            it(@"should cancel notification", ^{
                [[SnoozeLocalNotificationCenter center] cancelAllSnooze];
                [[[SnoozeHelper scheduled] should] haveCountOf:0];
            });
        });
    });
    describe(@"-cancelSnoozeForNotification:", ^{
        context(@"When arguments is nil", ^{
            it(@"should non error", ^{
                [[SnoozeLocalNotificationCenter center] cancelSnoozeForNotification:nil];
            });
        });
        context(@"When has two groups snooze notifications", ^{
            NSArray *snoozeMinutes = @[@10, @30, @60];
            __block UILocalNotification *localNotification;
            beforeEach(^{
                localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1000];
                localNotification.alertBody = @"message";
                [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];

                UILocalNotification *otherNotification = [[UILocalNotification alloc] init];
                otherNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5000];
                localNotification.alertBody = @"message2";
                [[SnoozeLocalNotificationCenter center] schedule:otherNotification snoozeMinutes:snoozeMinutes];
            });
            it(@"should cancel notification", ^{
                [[SnoozeLocalNotificationCenter center] cancelSnoozeForNotification:localNotification];
                [[[SnoozeHelper scheduled] should] haveCountOf:snoozeMinutes.count + 1];
            });
        });
    });
    describe(@"-cancelUnnecessarySnooze", ^{
        context(@"When primary notification is not notified yet", ^{
            NSArray *snoozeMinutes = @[@10, @30, @60];
            __block UILocalNotification *localNotification;
            beforeEach(^{
                localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1000];
                localNotification.alertBody = @"message";
                [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            });
            it(@"should not cancel snooze notification", ^{
                [[SnoozeLocalNotificationCenter center] cancelUnnecessarySnooze];
                [[[SnoozeHelper scheduled] should] haveCountOf:(snoozeMinutes.count + 1)];
            });
        });
        context(@"When primary notification already notified", ^{
            NSArray *snoozeMinutes = @[@10, @30, @60];
            __block UILocalNotification *localNotification;
            beforeEach(^{
                localNotification = [[UILocalNotification alloc] init];
                // already notified
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:0];
                localNotification.alertBody = @"message";
                [[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
            });
            it(@"should not cancel snooze notification", ^{
                [[SnoozeLocalNotificationCenter center] cancelUnnecessarySnooze];
                [[[SnoozeHelper scheduled] should] haveCountOf:0];
            });
        });
    });
SPEC_END