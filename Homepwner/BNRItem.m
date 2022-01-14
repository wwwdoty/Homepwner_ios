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
    NSInteger randomValue = arc4random() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10];
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(NSInteger)value
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

- (void)setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    // 缩略图的大小
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    // 确定缩放倍数并保持宽高比不变
    CGFloat ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    // 根据当前设备的屏幕scaling factor创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    // 创建表示圆角矩形的UIBezierPath对象
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    // 根据UIBezierPath对象裁剪图形上下文
    [path addClip];
    // 让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    // 在下文中绘制图片
    [image drawInRect:projectRect];
    // 通过图形上下文得到UIImage对象，并将其赋给thumbnail属性
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    // 清理图形上下文
    UIGraphicsEndImageContext();
}

- (NSString *)description {
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%ld, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    return descriptionString;
}

#pragma mark - NSCoding

// 根据编码后的数据coder初始化对象
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _serialNumber = [coder decodeObjectForKey:@"serialNumber"];
        _itemKey = [coder decodeObjectForKey:@"itemKey"];
        _dateCreated = [coder decodeObjectForKey:@"dateCreated"];
        _valueInDollars = [coder decodeIntegerForKey:@"valueInDollars"];
        _thumbnail = [coder decodeObjectForKey:@"thumbnail"];


    }
    return self;
}

// 将所有的参数编码至coder
- (void)encodeWithCoder:(NSCoder *)coder {
    // 收到encodewithcoder的对象会编码自己的属性，因此是个递归的过程，self.itemName等也会去编码他的（string)属性
    [coder encodeObject:self.itemName forKey:@"itemName"];
    [coder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [coder encodeObject:self.itemKey forKey:@"itemKey"];
    [coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [coder encodeInteger:self.valueInDollars forKey:@"valueInDollars"];
    [coder encodeObject:self.thumbnail forKey:@"thumbnail"];

}

+ (BOOL)supportsSecureCoding {
    return true;
}



@end
