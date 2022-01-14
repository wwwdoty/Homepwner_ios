//
//  BNRImageStore.m
//  Homepwner
//
//  Created by wangyang on 2021/12/23.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

/// key:image
@property(nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

+ (instancetype)sharedStore {
    static BNRImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return  sharedStore;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        // 注册self为通知中心UIApplicationDidReceiveMemoryWarningNotification事件的观察者，在收到
        // 通知时会调用clearCache
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"reason:@"use +[BNRImageStore sharedStore]" userInfo:nil];
    return nil;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
    // 获取保存图片的全路径
    NSString *imagePath = [self imagePathForKey:key];
    // 从图片提交JPEG格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);// 1 表示最高质量(不压缩)
    // 将JEPG格式的数据写入文件
    [data writeToFile:imagePath atomically:YES];
    
}

- (UIImage *)imageForKey:(NSString *)key {
    // 先尝试通过字典（缓存）获取图片
    UIImage *result = self.dictionary[key];
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        // 通过文件创建UIImage对象
        result = [UIImage imageWithContentsOfFile:imagePath];
        // 如果能够通过文件创建图片，就将其放入缓存(字典）
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
    if (error) {
        NSLog(@"error occured when delete image:%@", error);
    }
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return  [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note {
    NSLog(@"flushing %ld images out of the cache", self.dictionary.count);
    [self.dictionary removeAllObjects];
}

@end
