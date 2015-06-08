//
//  OMDDeliveringDetailViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDDeliveringDetailViewController.h"
#import "OMDDeliveringObject.h"
#import "OMDMapViewController.h"

#import "OMDFalseDataManager.h"

@interface OMDDeliveringDetailViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) OMDDeliveringDetailObject *detailObj;

@property (nonatomic, assign) BOOL isOpened;

@end

@implementation OMDDeliveringDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    [self initData];
    
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    CGRect rect = self.view.bounds;
    rect.size.height -= 54;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    rect.origin.y += rect.size.height;
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.frame = CGRectMake(20, 5, rect.size.width-20*2, 44);
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:[UIColor whiteColor]];
    self.confirmButton.layer.cornerRadius = 44.0/2;
    self.confirmButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.confirmButton.layer.borderWidth = 1.0;
    [bgView addSubview:self.confirmButton];
}

- (void)initData
{
    self.detailObj = [OMDFalseDataManager gemDeliveringDetailObj];
}

#define kConfirmTag 1234
#pragma mark -- Buttion Actions --
- (void)confirmAction:(UIButton *)sender
{
    [self showAlertViewWithMessage:@"Confirm this order?" tag:kConfirmTag cancelString:@"Cancel" sureString:@"Confirm"];
}

#pragma mark -- UITableViewDatasource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpened && self.detailObj.dishArray.count>0) {
        return 5+self.detailObj.dishArray.count;
    }
    else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.row) {
        return 66;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (0 == indexPath.row) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = self.detailObj.orderCode;
    }
    else if (1 == indexPath.row) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = self.detailObj.custName;
    }
    else if (2 == indexPath.row) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = self.detailObj.custPhone;
        cell.textLabel.textColor = [UIColor blueColor];
    }
    else if (3 == indexPath.row) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = self.detailObj.custAddr;
        
    }
    else {
        if (self.isOpened && self.detailObj.dishArray.count>0) {
            if (indexPath.row < 4+self.detailObj.dishArray.count) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                OMDDeliveringDishObject *dishObj = [self.detailObj.dishArray objectAtIndex:indexPath.row-4];
                cell.textLabel.text = dishObj.dishName;
                cell.detailTextLabel.text = dishObj.dishPrice;
            }
            else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.textLabel.text = @"Total:";
                cell.detailTextLabel.text = self.detailObj.billPrice;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Total:";
            cell.detailTextLabel.text = self.detailObj.billPrice;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

#pragma mark -- UITableViewDelegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (2 == indexPath.row) {
        NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",self.detailObj.custPhone ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
    }
    else if (3 == indexPath.row) {
        OMDMapViewController *mapCtrl = [[OMDMapViewController alloc] init];
        mapCtrl.addressStr = self.detailObj.custAddr;
        mapCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mapCtrl animated:YES];
    }
    else if (!self.isOpened && 4 == indexPath.row) {
        self.isOpened = YES;
        [self.tableView reloadData];
    }
    else if (self.isOpened && 4+self.detailObj.dishArray.count == indexPath.row) {
        self.isOpened = NO;
        [self.tableView reloadData];
    }
}

#pragma mark -- UIAlertView Delegate --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kConfirmTag) {
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            __weak OMDDeliveringDetailViewController *wSelf = self;
            [self showProcessHUD:@"Confirm successful" completionBlock:^{
                OMDDeliveringDetailViewController *sSelf = wSelf;
                if (sSelf.confirmBlock) {
                    sSelf.confirmBlock(self.index);
                }
                [sSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
