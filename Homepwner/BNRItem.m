//
//  BNRItem.m
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import "BNRItem.h"

@implementation BNRItem

+ (instancetype)randomItem {
    // 创建不可变数组对象，包含三个形容词
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    // 创建不可变数组对象，包含三个名词
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    // 根据数组对象所含对象的个数，得到随机索引”
    // 注意：运算符%是模运算符，运算后得到的是余数
    // 因此adjectiveIndex是一个0到2（包括2）的随机数
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    // 注意，类型为NSInteger的变量不是对象，
    // NSInteger是一种针对unsigned long（无符号长整数）的类型定义
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    int randomValue = arc4random() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10];
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    // 调用父类的指定初始化方法
    self = [super init];
    // 父类的指定初始化方法是否成功创建了父类对象？
    if (self) {
        // 为实例变量设定初始值
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        // 设置_dateCreated的值为系统当前时间
        _dateCreated = [[NSDate alloc] init];
        
        // 创建一个NSUUID对象，获取NSString类型的值
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    // 返回初始化后的对象的新地址
    return self;

}

- (instancetype)initWithItemName:(NSString *)name {
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];;
}

- (instancetype)init {
    return [self initWithItemName:@"Item"];
}

- (NSString *)description {
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    return descriptionString;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _serialNumber = [coder decodeObjectForKey:@"serialNumber"];
        _itemKey = [coder decodeObjectForKey:@"itemKey"];
        _dateCreated = [coder decodeObjectForKey:@"dateCreated"];
        _valueInDollars = [coder decodeIntForKey:@"valueInDollars"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)Coder {
    [Coder encodeObject:self.itemName forKey:@"itemName"];
    [Coder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [Coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [Coder encodeObject:self.itemKey forKey:@"itemKey"];
    [Coder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}


@end
