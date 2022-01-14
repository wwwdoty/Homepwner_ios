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
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSSet *clsSet = [NSSet setWithObjects:[NSMutableArray class],[BNRItem class], [NSDate class], [UIImage class], nil];
        _privateItems = [NSKeyedUnarchiver unarchivedObjectOfClasses:clsSet fromData:data error:&error];
        // 这种写法出现的提示
        // NSSecureCoding allowed classes list contains [NSObject class], which bypasses security by allowing any
        // Objective-C class to be implicitly decoded. Consider reducing the scope of allowed classes during decoding by
        // listing only the classes you expect to decode, or a more specific base class than NSObject. This will be
        //  disallowed in the future
//        _privateItems = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&error];
        if (error) {
            NSLog(@"error occured when unarchived objects: %@",error);
        }
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
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 从documentDirectories数组获取第一个，也是唯一一个文档目录路径
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"item.archive"];
}

- (BOOL)saveChanges {
    NSString *path = [self itemArchivePath];
    NSError *error;
    // 1.创建一个NSKeyedArchiver对象 2 向privateItem发送encoderWithCoder消息，传入NSKeyedArchiver对象作为coder
    // 3. privateItems的encodeWithCoder:方法会向其包含的所有BNRItem对象发送encodeWithCoder:消息，
    //    并传入同一个NSKeyedArchiver对象。这些BNRItem对象都会将其属性编码至同一个NSKeyedArchiver对象
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.privateItems requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"error occured when save changes: %@",error);
    }
    return [data writeToFile:path atomically:YES];
}

@end
