//
//  AppDelegate.m
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    BNRItemsViewController *ctl = [[BNRItemsViewController alloc] init];
//    BNRDetailViewController *ctl = [[BNRDetailViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
