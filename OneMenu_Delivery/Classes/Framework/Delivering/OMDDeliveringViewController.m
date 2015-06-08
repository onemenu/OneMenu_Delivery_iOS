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

@property (nonatomic, assign) OrderStatus toStatus;

@end

@implementation OMDDeliveringViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Delivering";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    [self setRightNavigationItemTittle:@"Login" action:@selector(loginAction:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
    __weak OMDDeliveringViewController *wSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        OMDDeliveringViewController *sSelf = wSelf;
        [sSelf initData];
    }];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    [self.tableView.header setUpdatedTimeHidden:YES];
//    [self.tableView.header setStateHidden:YES];
    [self.view addSubview:self.tableView];
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

- (void)loadMore
{
#ifdef APP_TEST
    [self.dataArray addObjectsFromArray:[[OMDFalseDataManager gemDeliveringDatas] mutableCopy]];
    [self.tableView.footer endRefreshing];
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
    [self doDeliveringListRequest];
#endif
}

- (void)loginAction:(id)sender
{
    OMDLoginViewController *loginCtrl = [[OMDLoginViewController alloc] init];
    loginCtrl.hidesBottomBarWhenPushed = YES;
    OMBaseNavigationController *nav = [[OMBaseNavigationController alloc] initWithRootViewController:loginCtrl];
    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark -- Network Methods --
- (void)doDeliveringListRequest
{
    [self.dataArray removeAllObjects];
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringViewController *wSelf = self;
    
    OMDDeliveringListRequest *request = [[OMDDeliveringListRequest alloc] init];
    
    [[OMDNetworkManager createNetworkEngineer]
     getDeliveringListDataWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDDeliveringListResult *result = (OMDDeliveringListResult *)responseObj;
         OMDDeliveringViewController *sSelf = wSelf;
         sSelf.dataArray = [NSMutableArray arrayWithArray:result.listArray];
         [sSelf.tableView reloadData];
         [sSelf.tableView.header endRefreshing];
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDDeliveringViewController *sSelf = wSelf;
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)doConfirmOrderRequestWith:(NSString *)orderId
{
    [self showProcessHUD:nil];
    
    __weak OMDDeliveringViewController *wSelf = self;
    
}

#pragma mark -- UITableView Datasource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *restArray = [self.dataArray objectAtIndex:section];
    return restArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *restArray = [self.dataArray objectAtIndex:section];
    OMDDeliveringObject *obj = [restArray objectAtIndex:0];
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
    OMDDeliveringCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[OMDDeliveringCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSArray *restArray = [self.dataArray objectAtIndex:indexPath.section];
    OMDDeliveringObject *obj = [restArray objectAtIndex:indexPath.row];
    NSMutableArray *buttons = [NSMutableArray array];
    if (obj.status == OrderStatus_DriverUnConfirm) {
        [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"Cancel"];
        [buttons sw_addUtilityButtonWithColor:[UIColor lightGrayColor] title:@"Confirm"];
    }
    else if (obj.status == OrderStatus_DriverConfirmed) {
        [buttons sw_addUtilityButtonWithColor:[UIColor lightGrayColor] title:@"Done"];
    }
    cell.rightUtilityButtons = buttons;
    [cell setupCellWithItem:obj indexPath:indexPath actionBlock:NULL];
    cell.tag = indexPath.section*100+indexPath.row;
    cell.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -- SWTableViewCell Delegate --
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSArray *restArray = [self.dataArray objectAtIndex:cell.tag/100];
    OMDDeliveringObject *obj = [restArray objectAtIndex:cell.tag%100];
    if (obj.status == OrderStatus_DriverUnConfirm) {
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Done this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Done", nil];
        alert.tag = cell.tag;
        [alert show];
    }
}

#pragma mark -- UITableView Delegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *restArray = [self.dataArray objectAtIndex:indexPath.section];
    OMDDeliveringObject *deliObj = [restArray objectAtIndex:indexPath.row];
    if ([deliObj.isOMOrder isEqualToString:@"1"]) {
        
    }
    OMDDeliveringDetailViewController *detailCtrl = [[OMDDeliveringDetailViewController alloc] init];
    detailCtrl.index = indexPath.section*100+indexPath.row;
    __weak OMDDeliveringViewController *wSelf = self;
    [detailCtrl setConfirmBlock:^(NSInteger index) {
        OMDDeliveringViewController *sSelf = wSelf;
        NSMutableArray *restArray = [[sSelf.dataArray objectAtIndex:index/100] mutableCopy];
        [restArray removeObjectAtIndex:index%100];
        if (restArray.count==0) {
            [sSelf.dataArray removeObjectAtIndex:index/100];
        }
        [sSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index%100 inSection:index/100]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    detailCtrl.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailCtrl animated:YES];
}


#pragma mark -- UIAlertView Delegate --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableArray *restArray = [[self.dataArray objectAtIndex:alertView.tag/100] mutableCopy];
    OMDDeliveringObject *obj = [restArray objectAtIndex:alertView.tag%100];
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        if (obj.status == OrderStatus_DriverConfirmed) {
            obj.status = OrderStatus_DriverDone;
            [restArray replaceObjectAtIndex:alertView.tag%100 withObject:obj];
            [restArray removeObjectAtIndex:alertView.tag%100];
            if (restArray.count==0) {
                [self.dataArray removeObjectAtIndex:alertView.tag/100];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:alertView.tag/100] withRowAnimation:UITableViewRowAnimationNone];
            }
            else {
                [self.dataArray replaceObjectAtIndex:alertView.tag/100 withObject:restArray];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag%100 inSection:alertView.tag/100]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self decreaseAppBadge];
            
        }
        else if (obj.status == OrderStatus_DriverUnConfirm) {
            if (self.toStatus == OrderStatus_DriverConfirmed) {
                obj.status = OrderStatus_DriverConfirmed;
                [restArray replaceObjectAtIndex:alertView.tag%100 withObject:obj];
                [self.dataArray replaceObjectAtIndex:alertView.tag/100 withObject:restArray];
            }
            else if (self.toStatus == OrderStatus_DriverCancel) {
                obj.status = OrderStatus_DriverCancel;
                [restArray replaceObjectAtIndex:alertView.tag%100 withObject:obj];
                [restArray removeObjectAtIndex:alertView.tag%100];
                if (restArray.count==0) {
                    [self.dataArray removeObjectAtIndex:alertView.tag/100];
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:alertView.tag/100] withRowAnimation:UITableViewRowAnimationNone];
                }
                else {
                    [self.dataArray replaceObjectAtIndex:alertView.tag/100 withObject:restArray];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag%100 inSection:alertView.tag/100]] withRowAnimation:UITableViewRowAnimationNone];
                }
                [self decreaseAppBadge];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)decreaseAppBadge
{
    [OMUtility decreaseAppBadgeWith:1];
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
