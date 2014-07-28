# SnoozeLocalNotification

[![CI Status](http://img.shields.io/travis/azu/SnoozeLocalNotification.svg?style=flat)](https://travis-ci.org/azu/SnoozeLocalNotification)
[![Version](https://img.shields.io/cocoapods/v/SnoozeLocalNotification.svg?style=flat)](http://cocoadocs.org/docsets/SnoozeLocalNotification)
[![License](https://img.shields.io/cocoapods/l/SnoozeLocalNotification.svg?style=flat)](http://cocoadocs.org/docsets/SnoozeLocalNotification)
[![Platform](https://img.shields.io/cocoapods/p/SnoozeLocalNotification.svg?style=flat)](http://cocoadocs.org/docsets/SnoozeLocalNotification)

Snooze UILocalNotification library.

## Installation

SnoozeLocalNotification is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "SnoozeLocalNotification"


## Usage

You should put some code in `AppDelegate`.

``` objc
- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[SnoozeLocalNotificationCenter center] cancelSnoozeForNotification:localNotif]
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *) application {
    [[SnoozeLocalNotificationCenter center] cancelUnnecessarySnooze];
}
```

and schedule `UILocalNotification` and snooze.

```objc
// Schedule 4 notification.
// fireDate -> 10min -> 30min -> 60min
NSArray *snoozeMinutes = @[@10, @30, @60];
UILocalNotification *localNotification = [[UILocalNotification alloc] init];
localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1000];
localNotification.alertBody = @"message";
[[SnoozeLocalNotificationCenter center] schedule:localNotification snoozeMinutes:snoozeMinutes];
```

## API

```objc
@interface SnoozeLocalNotificationCenter : NSObject
+ (instancetype)center;

// schedule notification and snooze
- (void)schedule:(UILocalNotification *) localNotification snoozeDateComponents:(NSArray *) dateComponentsList;
- (void)schedule:(UILocalNotification *) snoozeLocalNotification snoozeMinutes:(NSArray *) snoozeMinutes;

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
```

## License

SnoozeLocalNotification is available under the MIT license. See the LICENSE file for more info.

