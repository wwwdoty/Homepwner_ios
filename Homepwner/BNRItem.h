//
//  BNRItem.h
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSObject <NSCoding>

@property(nonatomic, copy) NSString *itemName;
@property(nonatomic, copy) NSString *serialNumber;
@property(nonatomic, assign) int valueInDollars;
@property(nonatomic, readonly, strong) NSDate *dateCreated;
@property(nonatomic, copy) NSString *itemKey;

+ (instancetype)randomItem;

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
