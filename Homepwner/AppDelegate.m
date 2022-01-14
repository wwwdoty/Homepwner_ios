//
//  AppDelegate.m
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSLog(@"%@", NSStringFromSelector(_cmd));

    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    BNRItemsViewController *ctl = [[BNRItemsViewController alloc] init];
//    BNRDetailViewController *ctl = [[BNRDetailViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    NSLog(@"%@", NSStringFromSelector(_cmd));

    BOOL success = [[BNRItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    } else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

//- (void)applicationWillResignActive:(UIApplication *)application {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}

@end
