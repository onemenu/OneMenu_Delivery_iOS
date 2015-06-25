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
@property (nonatomic, strong) UIView *confirmBgView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) OMDDeliveringDetailObject *detailObj;

@property (nonatomic, strong) UIView *doneBgView;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) OMDTipsView *tipsView;

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
    [self setRightNavigationItemTittle:@"RESET" action:@selector(resetPriceAction)];
    
    CGRect rect = self.view.bounds;
    rect.size.height -= 54;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    rect.origin.y += rect.size.height;
    self.confirmBgView = [[UIView alloc] initWithFrame:rect];
    self.confirmBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.confirmBgView];
    
    self.doneBgView = [[UIView alloc] initWithFrame:rect];
    self.doneBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.doneBgView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(20, 5, (rect.size.width-20*3)/2, 44);
    
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    self.cancelButton.layer.cornerRadius = 44.0/2;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.cancelButton.layer.borderWidth = 1.0;
    [self.confirmBgView addSubview:self.cancelButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.frame = CGRectMake(self.cancelButton.frame.origin.x+self.cancelButton.frame.size.width+20, self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, 44);
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:[UIColor whiteColor]];
    self.confirmButton.layer.cornerRadius = 44.0/2;
    self.confirmButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.confirmButton.layer.borderWidth = 1.0;
    [self.confirmBgView addSubview:self.confirmButton];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(20, 5, rect.size.width-20*2, 44);
    [self.doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    self.doneButton.layer.cornerRadius = 44.0/2;
    self.doneButton.layer.borderWidth = 1.0;
    self.doneButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.doneBgView addSubview:self.doneButton];
    
    self.confirmBgView.hidden = YES;
    self.doneBgView.hidden = YES;
}

#define kPriceAlertTag 304
- (void)resetPriceAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Input the new price" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = kPriceAlertTag;
    [alert show];
}

- (void)initData
{
#ifdef APP_TEST
    self.detailObj = [OMDFalseDataManager gemDeliveringDetailObj];
#else
//    self.detailObj = [OMDFalseDataManager gemDeliveringDetailObj];
    [self doOrderDetailRequest];
#endif
}

- (void)doOrderDetailRequest
{
    __weak OMDDeliveringDetailViewController *wSelf = self;
    
    [self showProcessHUD:nil];
    OMDDeliveringDetailRequest *request = [[OMDDeliveringDetailRequest alloc] init];
    request.orderId = self.orderId;
    
    [[OMDNetworkManager createNetworkEngineer]
     getDeliveringDetailWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDDeliveringDetailResult *result = (OMDDeliveringDetailResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             sSelf.detailObj = result.detailObj;
             [sSelf.tableView reloadData];
             [sSelf updateConfirmButtonStatus];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)doConfirmOrderRequestWith:(NSString *)orderId
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringDetailViewController *wSelf = self;
    OMDConfirmOrderRequest *request = [[OMDConfirmOrderRequest alloc] init];
    request.orderId = orderId;
    
    [[OMDNetworkManager createNetworkEngineer]
     confirmOrderWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDConfirmOrderResult *result = (OMDConfirmOrderResult *)responseObj;
         if ([result.status  isEqualToString:kSuccessCode]) {
             sSelf.detailObj.status = OrderStatus_DriverConfirmed;
             if (sSelf.confirmBlock) {
                 sSelf.confirmBlock(OrderStatus_DriverConfirmed, sSelf.indexPath);
             }
             [sSelf updateConfirmButtonStatus];
             [sSelf.tableView reloadData];
//             [sSelf.navigationController popViewControllerAnimated:YES];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
     }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
     }];
}

- (void)doCancelOrderRequestWith:(NSString *)orderId
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringDetailViewController *wSelf = self;
    OMDCancelOrderRequest *request = [[OMDCancelOrderRequest alloc] init];
    request.orderId = orderId;
    [[OMDNetworkManager createNetworkEngineer]
     cancelOrderWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDCancelOrderResult *result = (OMDCancelOrderResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             if (sSelf.confirmBlock) {
                 sSelf.confirmBlock(OrderStatus_DriverCancel, sSelf.indexPath);
             }
             
             [sSelf.navigationController popViewControllerAnimated:YES];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
     }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
     }];
}

- (void)doDoneOrderRequestWith:(NSString *)orderId tipsType:(TipsType)type tipsFee:(NSString *)tipsFee
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringDetailViewController *wSelf = self;
    OMDDoneOrderRequest *request = [[OMDDoneOrderRequest alloc] init];
    request.orderId = orderId;
    request.tipsType = [NSString stringWithFormat:@"%zd",type];
    request.tipsFee = tipsFee;
    request.driverId = [OMDUtility getCurrentCustomerId];
    [[OMDNetworkManager createNetworkEngineer]
     doneOrderWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDDoneOrderResult *result = (OMDDoneOrderResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             if (sSelf.confirmBlock) {
                 sSelf.confirmBlock(OrderStatus_DriverDone, sSelf.indexPath);
             }
             [sSelf.navigationController popViewControllerAnimated:YES];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
     }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
     }];
}

- (void)doResetOrderPriceRequestWith:(NSString *)price
{
    __weak OMDDeliveringDetailViewController *wSelf = self;
    OMDResetOrderPriceRequest *request = [[OMDResetOrderPriceRequest alloc] init];
    request.orderId = self.orderId;
    request.billPrice = price;
    
    [self showProcessHUD:nil];
    [[OMDNetworkManager createNetworkEngineer]
     resetOrderPriceWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDResetOrderPriceResult *result = (OMDResetOrderPriceResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             sSelf.detailObj.billPrice = price;
             [sSelf.tableView reloadData];
             if (sSelf.resetPriceBlock) {
                 sSelf.resetPriceBlock(price,sSelf.indexPath);
             }
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringDetailViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
    }];
}

#define kConfirmTag 1234
#define kCancelTag 1235
#define kDoneTag 1236
#pragma mark -- Buttion Actions --
- (void)confirmAction:(UIButton *)sender
{
    [self showAlertViewWithMessage:@"Confirm this order?" tag:kConfirmTag cancelString:@"NO" sureString:@"YES"];
}

- (void)cancelAction:(UIButton *)sender
{
    [self showAlertViewWithMessage:@"Cancel this order?" tag:kCancelTag cancelString:@"NO" sureString:@"YES"];
}

- (void)doneAction:(UIButton *)sender
{
//    [self showAlertViewWithMessage:@"Done this order?" tag:kDoneTag cancelString:@"NO" sureString:@"YES"];
    __weak OMDDeliveringDetailViewController *wSelf = self;
    if (!self.tipsView) {
        self.tipsView = [[OMDTipsView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.tipsView];
        [self.tipsView setConfirmBlock:^(TipsType type, NSString *tipsFee) {
            OMDDeliveringDetailViewController *sSelf = wSelf;
            [sSelf doDoneOrderRequestWith:sSelf.orderId tipsType:type tipsFee:tipsFee];
        }];
    }
    [self.tipsView show];
}

#pragma mark --
- (void)updateConfirmButtonStatus
{
    if (self.detailObj.status == OrderStatus_DriverUnConfirm) {
        self.confirmBgView.hidden = NO;
        self.doneBgView.hidden = YES;
    }
    else if (self.detailObj.status == OrderStatus_DriverConfirmed) {
        self.confirmBgView.hidden = YES;
        self.doneBgView.hidden = NO;
    }
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
        cell.textLabel.text = @"Order Code:";
        cell.detailTextLabel.text = self.detailObj.orderCode;
        
    }
    else if (1 == indexPath.row) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"Cust Name:";
        cell.detailTextLabel.text = self.detailObj.custName;
    }
    else if (2 == indexPath.row) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"Phone:";
        cell.detailTextLabel.text = self.detailObj.custPhone;
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
    __weak OMDDeliveringDetailViewController *wSelf = self;
    if (alertView.tag == kConfirmTag) {
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            [self doConfirmOrderRequestWith:self.orderId];
        }
    }
    else if (alertView.tag == kCancelTag) {
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            [self doCancelOrderRequestWith:self.orderId];
        }
    }
//    else if (alertView.tag == kDoneTag) {
//        if (buttonIndex == [alertView firstOtherButtonIndex]) {
//
//        }
//    }
    else if (alertView.tag == kPriceAlertTag) {
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            UITextField *tf = [alertView textFieldAtIndex:0];//获得输入框
            NSString *nwPrice = tf.text;
            [self doResetOrderPriceRequestWith:nwPrice];
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
