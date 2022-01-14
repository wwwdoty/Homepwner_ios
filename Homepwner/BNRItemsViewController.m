//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by wangyang on 2021/12/13.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemCell.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController () <UIPopoverControllerDelegate>
@property(nonatomic, strong)UIPopoverController *imagePopover;
@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"HomePwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BNRItemCell class] forCellReuseIdentifier:@"BNRItemCell"];
    
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BNRItemStore sharedStore] allItems].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[BNRItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BNRItemCell"];
    }
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
//    cell.textLabel.text = [item description];
    // 根据BNRItem 设置BNRItemCell对象
    [cell layoutSubviewWithItem:item];
    cell.actionBlock = ^{
        NSLog(@"Going to shwo the image for %@", item);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            // 根据UITableView对象的坐标系
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BNRDetailViewController *detailViewCtl = [[BNRDetailViewController alloc] init];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    detailViewCtl.item = selectedItem;

    [self.navigationController pushViewController:detailViewCtl animated:YES];
}

#pragma mark - private

- (void)addNewItem:(id)sender {
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

// self.ediButtonItem 以实现以下功能
//- (void)toggleEditingMode:(id)sender {
//    // 如果当前的视图控制对象已经处在编辑模式
//    if (self.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//}

//- (UIView *)setUpHeaderView {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 0, [[UIScreen mainScreen] bounds].size.width, 23)];
//    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width / 2, view.bounds.size.height)];
//    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
//    [editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    editBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    [editBtn addTarget:self action:@selector(toggleEditingMode:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(editBtn.bounds.size.width, 0, view.bounds.size.width / 2, view.bounds.size.height)];
//    [addBtn setTitle:@"New" forState:UIControlStateNormal];
//    [addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    [addBtn addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:editBtn];
//    [view addSubview:addBtn];
//    return view;
//}
//
//- (UIView *)headerView {
//    if (!_headerView) {
//        _headerView = [self setUpHeaderView];
//        _headerView.backgroundColor = [UIColor lightGrayColor];
//    }
//    return _headerView;
//}


@end
