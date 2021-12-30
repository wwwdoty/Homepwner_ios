//
//  BNRItemStore.m
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()
@property(nonatomic, strong)NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore {
    static BNRItemStore *shareStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareStore = [[self alloc] initPrivate];
    });
    return shareStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSMutableArray class] fromData:[NSData dataWithContentsOfFile:path] error:nil];
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (BNRItem *)createItem {
    BNRItem *item = [BNRItem randomItem];
//    BNRItem *item = [[BNRItem alloc] init];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item {
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    BNRItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

- (NSArray *)allItems {
    return  [self.privateItems copy];
}

- (NSString *)itemArchivePath {
    // 第一个参数是NSDocumentDirectory  不是NSDocumetationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 从documentDirectories数组获取第一个，也是唯一一个文档目录路径
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"item.archive"];
}

- (BOOL)saveChanges {
    NSString *path = [self itemArchivePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.privateItems requiringSecureCoding:NO error:nil];
    return [data writeToFile:path atomically:YES];
}

@end
