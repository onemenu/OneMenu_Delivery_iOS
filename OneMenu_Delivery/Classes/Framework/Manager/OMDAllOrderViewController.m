//
//  OMDAllDeliveringViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/13.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDAllOrderViewController.h"
#import "OMDManagerViewController.h"

#import "OMDAllOrderCell.h"
#import "OMDAllOrderObject.h"

#import "OMDDeliveringCell.h"
#import "OMDDeliveringObject.h"

#import "SWTableViewCell.h"

@interface OMDAllOrderViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) OrderStatus toStatus;

@end

@implementation OMDAllOrderViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"All Order";
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
    [self setNavigationTitle:@"All Orders"];
    
    [self setRightNavigationItemTittle:@"Manage" action:@selector(manageAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    __weak OMDAllOrderViewController *wSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        OMDAllOrderViewController *sSelf = wSelf;
        [sSelf doAllOrderRequestWith:YES];
    }];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    [self.tableView.header setUpdatedTimeHidden:YES];
    [self.tableView.header beginRefreshing];
}

- (void)manageAction
{
    OMDManagerViewController *manaCtrl = [[OMDManagerViewController alloc] init];
    manaCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:manaCtrl animated:YES];
}

- (void)refreshTableView
{
    [self.tableView.header beginRefreshing];
}

- (void)pullToRefresh
{
#ifdef APP_TEST
    [self initData];
    [self.tableView.header endRefreshing];
    [self.tableView reloadData];
#else
    [self doAllOrderRequestWith:YES];
#endif
}

- (void)loadMoreAction
{
    [self doAllOrderRequestWith:NO];
}

- (void)initData
{
#ifdef APP_TEST
    self.dataArray = [[OMDFalseDataManager gemDeliveringDatas] mutableCopy];
#else
    self.dataArray = [NSMutableArray array];
#endif
}

#pragma mark -- Network Methods --
- (void)doAllOrderRequestWith:(BOOL)isRefresh
{
    [self.dataArray removeAllObjects];
    
    __weak OMDAllOrderViewController *wSelf = self;
    
    OMDAllOrderRequest *request = [[OMDAllOrderRequest alloc] init];
//    request.startNum = [NSString stringWithFormat:@"%zd",self.dataArray.count];
//    request.range = @"25";
    
    [[OMDNetworkManager createNetworkEngineer]
     getAllOrderListWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDAllOrderResult *result = (OMDAllOrderResult *)responseObj;
         OMDAllOrderViewController *sSelf = wSelf;
         if (isRefresh) {
             [sSelf.tableView.header endRefreshing];
         }
         else {
             [sSelf.tableView.footer endRefreshing];
         }
         if ([result.status isEqualToString:kSuccessCode]) {
//             if (sSelf.dataArray.count == 0) {
//                 [sSelf.tableView addLegendFooterWithRefreshingTarget:sSelf refreshingAction:@selector(loadMoreAction)];
//             }
             [sSelf.dataArray addObjectsFromArray:result.allOrderArray];
             [sSelf.tableView reloadData];
         }
         else {
             [sSelf.dataArray removeAllObjects];
             [sSelf.tableView reloadData];
             [sSelf showAlertViewWithMessage:result.msg];
         }
     }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDAllOrderViewController *sSelf = wSelf;
         [sSelf.tableView.header endRefreshing];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
     }];
}


#pragma mark -- UITableView Datasource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OMDAllOrderCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"deliveringCell";
    OMDAllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[OMDAllOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    OMDAllOrderObject *obj = [self.dataArray objectAtIndex:indexPath.row];
    [cell setupCellWithItem:obj index:indexPath.row actionBlock:NULL];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -- UITableView Delegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
