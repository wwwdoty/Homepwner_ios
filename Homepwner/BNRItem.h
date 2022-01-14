//
//  BNRItem.h
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSString *itemName;
@property(nonatomic, copy) NSString *serialNumber;
@property(nonatomic, assign) NSInteger valueInDollars;
@property(nonatomic, readonly, strong) NSDate *dateCreated;
@property(nonatomic, copy) NSString *itemKey;
@property(nonatomic, strong) UIImage *thumbnail; // 提供列表展示的缩略图

+ (instancetype)randomItem;

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(NSInteger)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
