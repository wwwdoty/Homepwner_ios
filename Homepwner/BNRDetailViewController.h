//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by wangyang on 2021/12/14.
//

#import <UIKit/UIKit.h>

@class BNRItem;

NS_ASSUME_NONNULL_BEGIN

/// item详情页面
@interface BNRDetailViewController : UIViewController

@property(nonatomic, strong) BNRItem *item;

@end

NS_ASSUME_NONNULL_END
