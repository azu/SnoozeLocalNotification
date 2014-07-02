//
//  AZViewController.m
//  SnoozeLocalNotification
//
//  Created by azu on 07/01/2014.
//  Copyright (c) 2014 azu. All rights reserved.
//

#import "AZViewController.h"
#import "SnoozeLocalNotificationCenter.h"

@interface AZViewController ()
- (IBAction)printLog:(id) sender;

- (IBAction)resetAlarm:(id) sender;

- (IBAction)scheduleAlarm:(id) sender;
@end

@implementation AZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)printLog:(id) sender {
    [self log];
}

- (void)log {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSLog(@"Notifications : %@ '%@'",
            [dateFormatter stringFromDate:notification.fireDate],
            notification.alertBody
             );
    }
}

- (IBAction)resetAlarm:(id) sender {
    [[SnoozeLocalNotificationCenter center] cancelAllSnooze];
}

- (IBAction)scheduleAlarm:(id) sender {
    NSArray *snooze = @[@1, @2, @3];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:10];// 10ms
    notification.alertBody = @"alarm";
    [[SnoozeLocalNotificationCenter center] schedule:notification snoozeMinutes:snooze];
    [self log];
}
@end
