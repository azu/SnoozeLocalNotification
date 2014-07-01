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

``` objc
- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[SnoozeLocalNotificationCenter center] cancelSnoozeForNotification:localNotif]
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *) application {
    [[SnoozeLocalNotificationCenter center] cancelAllSnooze];
}
```

## License

SnoozeLocalNotification is available under the MIT license. See the LICENSE file for more info.

