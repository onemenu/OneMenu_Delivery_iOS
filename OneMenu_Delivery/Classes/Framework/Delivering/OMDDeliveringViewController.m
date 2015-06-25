//
//  OMDDeliveringViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/3.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDDeliveringViewController.h"
#import "OMDDeliveringDetailViewController.h"
#import "OMDMapViewController.h"
#import "OMDLoginViewController.h"

#import "OMDTipsView.h"
#import "OMDDeliveringCell.h"
#import "OMDDeliveringObject.h"

#import "SWTableViewCell.h"

#import "OMDConstantsFile.h"

#import "OMDLoginViewController.h"

@interface OMDDeliveringViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) OMDTipsView *tipsView;

@property (nonatomic, assign) OrderStatus toStatus;

@property (nonatomic, strong) NSIndexPath *curSWCellIndexPath;

@end

@implementation OMDDeliveringViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Delivering";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginSuccessedAction:) name:kAutoLoginSuccessedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginFailureAction:) name:kAutoLoginFailureNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self autoLoginRequest];
    [self initData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)refreshTableView
{
    [self.tableView.header beginRefreshing];
}

- (void)autoLoginRequest
{
    OMDAutoLoginRequest *request = [[OMDAutoLoginRequest alloc] init];
    request.loginToken = [OMDUtility getCurrentCustomerLoginToken];
    request.driverId = [OMDUtility getCurrentCustomerId];
    if (request.loginToken) {
        [[OMDNetworkManager createNetworkEngineer]
         autoLoginWith:request
         completeBlock:^(OMDNetworkBaseResult *responseObj) {
             
         }
         failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginFailureNotification object:nil];
    }
}

- (void)setupViews
{
    [self setNavigationTitle:@"Delivering"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    __weak OMDDeliveringViewController *wSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        OMDDeliveringViewController *sSelf = wSelf;
        [sSelf doDeliveringListRequest];
    }];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    [self.tableView.header setUpdatedTimeHidden:YES];
//    [self.tableView.header beginRefreshing];
}

- (void)pullToRefresh
{
#ifdef APP_TEST
    [self initData];
    [self.tableView.header endRefreshing];
    [self.tableView reloadData];
#else
    [self doDeliveringListRequest];
#endif
}

- (void)initData
{
#ifdef APP_TEST
    self.dataArray = [[OMDFalseDataManager gemDeliveringDatas] mutableCopy];
#else
    self.dataArray = [NSMutableArray array];
#endif
}

- (void)autoLoginSuccessedAction:(NSNotification *)notification
{
    [self.tableView.header beginRefreshing];
}

- (void)autoLoginFailureAction:(NSNotification *)notification
{
    if (![OMDUtility isLogined]) {
        OMDLoginViewController *loginCtrl = [[OMDLoginViewController alloc] init];
        loginCtrl.hidesBottomBarWhenPushed = YES;
        __weak OMDDeliveringViewController *wSelf = self;
        [loginCtrl setLoginSuccessedBlock:^{
            OMDDeliveringViewController *sSelf = wSelf;
            [sSelf.tableView.header beginRefreshing];
        }];
        OMBaseNavigationController *navCtrl = [[OMBaseNavigationController alloc] initWithRootViewController:loginCtrl];
        [self presentViewController:navCtrl animated:YES completion:NULL];
    }

}

#pragma mark -- Network Methods --
- (void)doDeliveringListRequest
{
    [self.dataArray removeAllObjects];
    
    __weak OMDDeliveringViewController *wSelf = self;
    
    OMDDeliveringListRequest *request = [[OMDDeliveringListRequest alloc] init];
    request.driverId = [OMDUtility getCurrentCustomerId];
    
    [[OMDNetworkManager createNetworkEngineer]
     getDeliveringListDataWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringListResult *result = (OMDDeliveringListResult *)responseObj;
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf.tableView.header endRefreshing];
         if ([result.status isEqualToString:kSuccessCode]) {
             sSelf.dataArray = [NSMutableArray arrayWithArray:result.listArray];
             [sSelf.tableView reloadData];
         }
         else if ([result.status isEqualToString:kGetDataEmpty]) {
             [OMDUtility clearAppBadge];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf.tableView.header endRefreshing];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)doConfirmOrderRequestWith:(NSString *)orderId
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringViewController *wSelf = self;
    OMDConfirmOrderRequest *request = [[OMDConfirmOrderRequest alloc] init];
    request.orderId = orderId;
    
    [[OMDNetworkManager createNetworkEngineer]
     confirmOrderWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDConfirmOrderResult *result = (OMDConfirmOrderResult *)responseObj;
         if ([result.status  isEqualToString:kSuccessCode]) {
             OMDDeliveringObject *obj = [sSelf.dataArray objectAtIndex:sSelf.curSWCellIndexPath.section];
             NSMutableArray *orderArray = [obj.orderArray mutableCopy];
             OMDDeliveringOrderObject *orderObj = [orderArray objectAtIndex:sSelf.curSWCellIndexPath.row];
             orderObj.status = OrderStatus_DriverConfirmed;
             [orderArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.row withObject:orderObj];
             obj.orderArray = orderArray;
             [sSelf.dataArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.section withObject:obj];
             [sSelf.tableView reloadData];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)doCancelOrderRequestWith:(NSString *)orderId
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringViewController *wSelf = self;
    OMDCancelOrderRequest *request = [[OMDCancelOrderRequest alloc] init];
    request.orderId = orderId;
    [[OMDNetworkManager createNetworkEngineer]
     cancelOrderWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDCancelOrderResult *result = (OMDCancelOrderResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             OMDDeliveringObject *obj = [sSelf.dataArray objectAtIndex:sSelf.curSWCellIndexPath.section];
             NSMutableArray *orderArray = [obj.orderArray mutableCopy];
             OMDDeliveringOrderObject *orderObj = [orderArray objectAtIndex:sSelf.curSWCellIndexPath.row];
             orderObj.status = OrderStatus_DriverCancel;
             [orderArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.row withObject:obj];
             [orderArray removeObjectAtIndex:sSelf.curSWCellIndexPath.row];
             obj.orderArray = orderArray;
             [sSelf.dataArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.section withObject:obj];
             if (orderArray.count==0) {
                 [sSelf.dataArray removeObjectAtIndex:sSelf.curSWCellIndexPath.section];
                 [sSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:sSelf.curSWCellIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
             }
             else {
                 [sSelf.dataArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.section withObject:obj];
                 [sSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sSelf.curSWCellIndexPath.row inSection:sSelf.curSWCellIndexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
             }
             [sSelf decreaseAppBadge];
             [sSelf.tableView reloadData];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)doDoneOrderRequestWith:(NSString *)orderId tipsType:(TipsType)type tipsFee:(NSString *)tipsFee
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringViewController *wSelf = self;
    OMDDoneOrderRequest *request = [[OMDDoneOrderRequest alloc] init];
    request.orderId = orderId;
    request.tipsType = [NSString stringWithFormat:@"%zd",type];
    request.tipsFee = tipsFee;
    request.driverId = [OMDUtility getCurrentCustomerId];
    [[OMDNetworkManager createNetworkEngineer]
     doneOrderWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDDoneOrderResult *result = (OMDDoneOrderResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             OMDDeliveringObject *obj = [sSelf.dataArray objectAtIndex:sSelf.curSWCellIndexPath.section];
             NSMutableArray *orderArray = [obj.orderArray mutableCopy];
             OMDDeliveringOrderObject *orderObj = [orderArray objectAtIndex:sSelf.curSWCellIndexPath.row];
             orderObj.status = OrderStatus_DriverDone;
             [orderArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.row withObject:orderObj];
             [orderArray removeObjectAtIndex:sSelf.curSWCellIndexPath.row];
             obj.orderArray = orderArray;
             [sSelf.dataArray replaceObjectAtIndex:sSelf.curSWCellIndexPath.section withObject:obj];
             if (orderArray.count==0) {
                 [sSelf.dataArray removeObjectAtIndex:sSelf.curSWCellIndexPath.section];
             }
             [sSelf.tableView reloadData];
             [sSelf decreaseAppBadge];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

#pragma mark -- UITableView Datasource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OMDDeliveringObject *obj = [self.dataArray objectAtIndex:section];
    return obj.orderArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    OMDDeliveringObject *obj = [self.dataArray objectAtIndex:section];
    UILabel *restNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, view.frame.size.width-2*10, view.frame.size.height-2*5)];
    restNameLabel.text = obj.restName;
    [view addSubview:restNameLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OMDDeliveringCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellId = @"deliveringCell";
    OMDDeliveringCell *cell = [[OMDDeliveringCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    if (!cell) {
//        cell = [[OMDDeliveringCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    }
    OMDDeliveringObject *obj = [self.dataArray objectAtIndex:indexPath.section];
    OMDDeliveringOrderObject *orderObj = [obj.orderArray objectAtIndex:indexPath.row];
    NSMutableArray *buttons = [NSMutableArray array];
    if (orderObj.status == OrderStatus_DriverUnConfirm) {
        [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"Cancel"];
        [buttons sw_addUtilityButtonWithColor:[UIColor lightGrayColor] title:@"Confirm"];
    }
    else if (orderObj.status == OrderStatus_DriverConfirmed) {
        [buttons sw_addUtilityButtonWithColor:[UIColor lightGrayColor] title:@"Done"];
    }
    cell.rightUtilityButtons = buttons;
    [cell setupCellWithItem:orderObj indexPath:indexPath actionBlock:NULL];
    cell.tag = indexPath.section*100+indexPath.row;
//    self.curSWCellIndexPath = indexPath;
    cell.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -- SWTableViewCell Delegate --
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    __weak OMDDeliveringViewController *wSelf = self;
    NSLog(@"tag = %zd",cell.tag);
    OMDDeliveringObject *obj = [self.dataArray objectAtIndex:cell.tag/100];
    OMDDeliveringOrderObject *orderObj = [obj.orderArray objectAtIndex:cell.tag%100];
    self.curSWCellIndexPath = [NSIndexPath indexPathForRow:cell.tag%100 inSection:cell.tag/100];
    if (orderObj.status == OrderStatus_DriverUnConfirm) {
        NSInteger alertTag = cell.tag;
        if (0 == index) {
            self.toStatus = OrderStatus_DriverCancel;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cancel this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = alertTag;
            [alert show];
        }
        else {
            self.toStatus = OrderStatus_DriverConfirmed;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Confirm this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Confirm", nil];
            alert.tag = alertTag;
            [alert show];
        }
    }
    else {
        self.toStatus = OrderStatus_DriverDone;
        __block NSInteger blSection = cell.tag/100;
        __block NSInteger blRow = cell.tag%100;
        if (!self.tipsView) {
            self.tipsView = [[OMDTipsView alloc] initWithFrame:self.view.bounds];
            [self.tipsView setConfirmBlock:^(TipsType type, NSString *tips) {
                OMDDeliveringViewController *sSelf = wSelf;
                OMDDeliveringObject *blObj = [sSelf.dataArray objectAtIndex:blSection];
                OMDDeliveringOrderObject *blOrderObj = [blObj.orderArray objectAtIndex:blRow];
                [sSelf doDoneOrderRequestWith:blOrderObj.orderId tipsType:type tipsFee:tips];
            }];
            [self.view addSubview:self.tipsView];
        }
        [self.tipsView setConfirmBlock:^(TipsType type, NSString *tips) {
            OMDDeliveringViewController *sSelf = wSelf;
            OMDDeliveringObject *blObj = [sSelf.dataArray objectAtIndex:blSection];
            OMDDeliveringOrderObject *blOrderObj = [blObj.orderArray objectAtIndex:blRow];
            [sSelf doDoneOrderRequestWith:blOrderObj.orderId tipsType:type tipsFee:tips];
        }];
        [self.tipsView show];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Done this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Done", nil];
//        alert.tag = cell.tag;
//        [alert show];
    }
}

#pragma mark -- UITableView Delegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OMDDeliveringObject *obj = [self.dataArray objectAtIndex:indexPath.section];
    OMDDeliveringOrderObject *orderObj = [obj.orderArray objectAtIndex:indexPath.row];
    if ([orderObj.isOMOrder isEqualToString:@"1"]) {
        
    }
    OMDDeliveringDetailViewController *detailCtrl = [[OMDDeliveringDetailViewController alloc] init];
    detailCtrl.orderId = orderObj.orderId;
    detailCtrl.indexPath = indexPath;
    __weak OMDDeliveringViewController *wSelf = self;
    [detailCtrl setConfirmBlock:^(OrderStatus status, NSIndexPath *indexPa) {
        OMDDeliveringViewController *sSelf = wSelf;
        if (status == OrderStatus_DriverDone || status == OrderStatus_DriverCancel) {
            OMDDeliveringObject *aObj = [sSelf.dataArray objectAtIndex:indexPa.section];
            NSMutableArray *restArray = [aObj.orderArray mutableCopy];
            [restArray removeObjectAtIndex:indexPa.row];
            aObj.orderArray = restArray;
            if (restArray.count==0) {
                [sSelf.dataArray removeObjectAtIndex:indexPa.section];
            }
            [sSelf.tableView reloadData];
//            [sSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPa.row inSection:indexPa.section]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (status == OrderStatus_DriverConfirmed) {
            OMDDeliveringObject *aObj = [sSelf.dataArray objectAtIndex:indexPa.section];
            NSMutableArray *restArray = [aObj.orderArray mutableCopy];
            OMDDeliveringOrderObject *nwObj = [restArray objectAtIndex:indexPa.row];
            nwObj.status = OrderStatus_DriverConfirmed;
            [restArray replaceObjectAtIndex:indexPa.row withObject:nwObj];
            aObj.orderArray = restArray;
            [sSelf.dataArray replaceObjectAtIndex:indexPa.section withObject:aObj];
            [sSelf.tableView reloadData];
//            [restArray removeObjectAtIndex:indexPa.row];
//            if (restArray.count==0) {
//                [sSelf.dataArray removeObjectAtIndex:indexPa.section];
//            }
//            [sSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPa.row inSection:indexPa.section]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [detailCtrl setResetPriceBlock:^(NSString *billPrice, NSIndexPath *indexPa) {
        OMDDeliveringViewController *sSelf = wSelf;
        OMDDeliveringObject *obj = [sSelf.dataArray objectAtIndex:indexPa.section];
        NSMutableArray *restArray = [obj.orderArray mutableCopy];
        OMDDeliveringOrderObject *nwObj = [restArray objectAtIndex:indexPa.row];
        nwObj.billPrice = billPrice;
        [restArray replaceObjectAtIndex:indexPa.row withObject:nwObj];
        obj.orderArray = restArray;
        [sSelf.dataArray replaceObjectAtIndex:indexPa.section withObject:obj];
        [sSelf.tableView reloadData];
    }];
    detailCtrl.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailCtrl animated:YES];
}


#pragma mark -- UIAlertView Delegate --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak OMDDeliveringViewController *wSelf = self;
    if (alertView.tag != -1) {
        OMDDeliveringObject *obj = [self.dataArray objectAtIndex:self.curSWCellIndexPath.section];
        NSMutableArray *orderArray = [obj.orderArray mutableCopy];
        OMDDeliveringOrderObject *orderObj = [orderArray objectAtIndex:self.curSWCellIndexPath.row];
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            if (orderObj.status == OrderStatus_DriverConfirmed) {
                
            }
            else if (orderObj.status == OrderStatus_DriverUnConfirm) {
                if (self.toStatus == OrderStatus_DriverConfirmed) {
                    [self doConfirmOrderRequestWith:orderObj.orderId];
                }
                else if (self.toStatus == OrderStatus_DriverCancel) {
                    [self doCancelOrderRequestWith:orderObj.orderId];
                }
            }
            [self.tableView reloadData];
        }
    }
}

- (void)decreaseAppBadge
{
    [OMDUtility decreaseAppBadgeWith:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAutoLoginSuccessedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAutoLoginFailureNotification object:nil];
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
