//
//  BNRImageStore.h
//  Homepwner
//
//  Created by wangyang on 2021/12/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 存储item的照片
@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;

- (UIImage *)imageForKey:(NSString *)key;

- (void)deleteImageForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
