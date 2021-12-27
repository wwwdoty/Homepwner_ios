//
//  main.m
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BNRItem.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }

    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
