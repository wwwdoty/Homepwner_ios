//
//  BNRItemCell.h
//  Homepwner
//
//  Created by wangyang on 2022/1/12.
//

#import <UIKit/UIKit.h>

@class BNRItem;

NS_ASSUME_NONNULL_BEGIN

@interface BNRItemCell : UITableViewCell

@property(nonatomic, strong)UIImageView *thumbnailView;
@property(nonatomic, strong)UIButton *imageBtn;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *serialNumberLabel;
@property(nonatomic, strong)UILabel *valueLabel;
@property(nonatomic, copy)void (^actionBlock) (void);

- (void)layoutSubviewWithItem:(BNRItem *)item;
@end

NS_ASSUME_NONNULL_END
