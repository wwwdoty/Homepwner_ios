//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by wangyang on 2021/12/14.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)
#define HEX(rgb) RGB((rgb) >> 16 & 0xff, (rgb) >> 8 & 0xff, (rgb)&0xff)

@interface BNRDetailView : UIControl

@property(nonatomic, strong)UITextField *nameField;
@property(nonatomic, strong)UITextField *serialNumberField;
@property(nonatomic, strong)UITextField *valueField;
@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UIImageView *photoView;
@end

@implementation BNRDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
        
        [self addSubview:({
            UIImageView *imageView = [[UIImageView alloc] init];
            CGFloat topY = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 5;
            CGFloat width = [[UIScreen mainScreen] bounds].size.width - 30;
            imageView.frame = CGRectMake(15, topY, width, 383);
            imageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.1 alpha:0.5];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            _photoView = imageView;
            imageView;

        })];
        
    }
    return self;
}

- (void)setUpSubViews {
    CGFloat leftX = 58;
    CGFloat topY = 115;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftX, topY, 0, 0)];
    nameLabel.text = @"Name";
    [nameLabel sizeToFit];
    
    // 间距
    CGFloat interval = nameLabel.bounds.size.width + 8;
    // 高度
    CGFloat fieldHeight = nameLabel.bounds.size.height + 8;
    
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(leftX + interval, topY - 4, 233, fieldHeight)];
    name.borderStyle = UITextBorderStyleRoundedRect;
    _nameField = name;

    topY += nameLabel.bounds.origin.y + fieldHeight + 13;
    UILabel *serialLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftX, topY, 0, 0)];
    serialLabel.text = @"Serial";
    [serialLabel sizeToFit];
    UITextField *serial = [[UITextField alloc] initWithFrame:CGRectMake(leftX + interval, topY - 4, 233, fieldHeight)];
    serial.borderStyle = UITextBorderStyleRoundedRect;
    _serialNumberField = serial;
    
    topY += serialLabel.bounds.origin.y + fieldHeight + 13;
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftX, topY, 0, 0)];
    valueLabel.text = @"Value";
    [valueLabel sizeToFit];
    UITextField *value = [[UITextField alloc] initWithFrame:CGRectMake(leftX + interval, topY - 4, 233, fieldHeight)];
    value.borderStyle = UITextBorderStyleRoundedRect;
    _valueField = value;
    
    topY += valueLabel.bounds.origin.y + fieldHeight + 13;
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftX, topY, interval + 233, fieldHeight)];
    _dateLabel.text = @"Label";
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:nameLabel];
    [self addSubview:_nameField];
    [self addSubview:serialLabel];
    [self addSubview:_serialNumberField];
    [self addSubview:valueLabel];
    [self addSubview:_valueField];
    [self addSubview:_dateLabel];
}

@end


@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property(nonatomic, strong)BNRDetailView *detailView;
@property(nonatomic, strong)UIToolbar *toolBar;
@end

@implementation BNRDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        _detailView = ({
            BNRDetailView *view= [[BNRDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view;
        });
        _detailView.backgroundColor = [UIColor whiteColor];
        [_detailView addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        _detailView.nameField.delegate = self;
        _detailView.serialNumberField.delegate = self;
        _detailView.valueField.delegate = self;
        [self.view  addSubview:_detailView];
        
        [self.view addSubview:({
            UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _detailView.frame.size.height - 50, _detailView.frame.size.width, 50)];
            UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
            [bar setItems:@[cameraItem]];
            _toolBar = bar;
            bar;
        })];

    }
    return self;
}

#pragma mark - view life circle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    self.detailView.nameField.text = item.itemName;
    self.detailView.serialNumberField.text = item.serialNumber;
    self.detailView.valueField.text =[NSString stringWithFormat:@"%ld", (long)item.valueInDollars];
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.detailView.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    // 根据itemKey，从BNRImageStore对象获取照片
    NSString *itemKey = self.item.itemKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
    self.detailView.photoView.image = imageToDisplay;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.itemName = self.detailView.nameField.text;
    item.serialNumber = self.detailView.serialNumberField.text;
    item.valueInDollars = [self.detailView.valueField.text intValue];;

    item.itemName = self.detailView.nameField.text;

}

#pragma mark - action

- (void)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else  {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    
    // 以模态的形式显示UIImagePickerController对象”
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)backgroundTapped:(id)sender {
    [self.detailView endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.item setThumbnailFromImage:image];
    // 以itemkey 为key 将照片存入BNRImageStore
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    self.detailView.photoView.image = image;
    // 让被present出来的控制器消失
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter

- (void)setItem:(BNRItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}


@end
