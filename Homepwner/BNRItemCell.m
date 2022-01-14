//
//  BNRItemCell.m
//  Homepwner
//
//  Created by wangyang on 2022/1/12.
//

#import "BNRItemCell.h"
#import "BNRItem.h"

@interface BNRItemCell ()

@end

@implementation BNRItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.thumbnailView];
        [self.contentView addSubview:self.imageBtn];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.serialNumberLabel];
        [self.contentView addSubview:self.valueLabel];
        
        
        [self.imageBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchDown];

    }
    return self;
}

- (void)layoutSubviewWithItem:(BNRItem *)item {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);

    self.thumbnailView.image = item.thumbnail;
    self.imageBtn.frame = self.thumbnailView.frame;
    
    self.nameLabel.text = item.itemName;
    [self.nameLabel sizeToFit];
    CGRect nameFrame = self.nameLabel.frame;
    nameFrame.origin.x = self.thumbnailView.frame.origin.x + self.thumbnailView.frame.size.width + 5;
    nameFrame.origin.y = self.thumbnailView.frame.origin.y;
    self.nameLabel.frame = nameFrame;

    self.serialNumberLabel.text = item.serialNumber;
    [self.serialNumberLabel sizeToFit];
    CGRect serialFrame = self.serialNumberLabel.frame;
    serialFrame.origin.x = self.nameLabel.frame.origin.x;
    serialFrame.origin.y = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 2;
    self.serialNumberLabel.frame = serialFrame;
    
    self.valueLabel.text = [NSString stringWithFormat:@"$%ld", item.valueInDollars];
    [self.valueLabel sizeToFit];
    CGRect valueFrame = self.valueLabel.frame;
    valueFrame.origin.x = self.bounds.size.width - 15 - valueFrame.size.width;
    valueFrame.origin.y = self.nameLabel.frame.origin.y + 8;
    self.valueLabel.frame = valueFrame;
    
}

- (void)showImage:(id)sender {
    // 调用Block对象之前要检查Block对象是否存在 
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark - getter

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 40, 40)];
    }
    return _thumbnailView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:18]];
    }
    return _nameLabel;
}

- (UILabel *)serialNumberLabel {
    if (!_serialNumberLabel) {
        _serialNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_serialNumberLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _serialNumberLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_valueLabel setFont:[UIFont systemFontOfSize:18]];
    }
    return _valueLabel;
}

- (UIButton *)imageBtn {
    if (!_imageBtn) {
        _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _imageBtn.backgroundColor = [UIColor clearColor];
    }
    return _imageBtn;
}

@end
