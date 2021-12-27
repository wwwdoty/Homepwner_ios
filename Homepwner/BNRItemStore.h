//
//  BNRItemStore.h
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BNRItem;

@interface BNRItemStore : NSObject

@property(nonatomic, copy, readonly)NSArray *allItems;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end

NS_ASSUME_NONNULL_END
