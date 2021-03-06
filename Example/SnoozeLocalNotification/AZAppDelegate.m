//
//  AZAppDelegate.m
//  SnoozeLocalNotification
//
//  Created by CocoaPods on 07/01/2014.
//  Copyright (c) 2014 azu. All rights reserved.
//

#import "AZAppDelegate.h"
#import "SnoozeLocalNotificationCenter.h"

@implementation AZAppDelegate

- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[SnoozeLocalNotificationCenter center] cancelSnoozeForNotification:notification];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *) application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *) application {
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

- (void)applicationWillEnterForeground:(UIApplication *) application {
    [[SnoozeLocalNotificationCenter center] cancelUnnecessarySnooze];
}

- (void)applicationDidBecomeActive:(UIApplication *) application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *) application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *) application didReceiveLocalNotification:(UILocalNotification *) notification {
    if (notification) {
        UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:@"Info"
            message:@"alarm"
            delegate:self
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alert show];
        [self log];
    }
}

@end
