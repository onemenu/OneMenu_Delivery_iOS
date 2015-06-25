//
//  OMDManagerViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/21.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDManagerViewController.h"
#import "OMDManagerCell.h"

@interface OMDManagerViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OMDManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    [self setNavigationTitle:@"Driver List"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.tableView.header beginRefreshing];
}

- (void)initData
{
    self.dataArray = [NSMutableArray array];
}

- (void)refreshAction
{
    [self doGetDriverListRequest];
}

#pragma mark -- Network request --
- (void)doGetDriverListRequest
{
    __weak OMDManagerViewController *wSelf = self;
    [self showProcessHUD:nil];
    
    OMDGetDriverListRequest *request = [[OMDGetDriverListRequest alloc] init];
    [[OMDNetworkManager createNetworkEngineer]
     getDriverListWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDManagerViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf.tableView.header endRefreshing];
         OMDGetDriverListResult *result = (OMDGetDriverListResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             sSelf.dataArray = [NSMutableArray arrayWithArray:result.driverList];
             [sSelf.tableView reloadData];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDManagerViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf.tableView.header endRefreshing];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)doChangeDriverOnDutyStatusWith:(BOOL)status driverId:(NSString *)driverId index:(NSInteger)index
{
    __weak OMDManagerViewController *wSelf = self;
    [self showProcessHUD:nil];
    
    OMDChangeDriverOnDutyRequest *request = [[OMDChangeDriverOnDutyRequest alloc] init];
    request.driverId = driverId;
    request.isOnDuty = [NSString stringWithFormat:@"%zd",status];
    [[OMDNetworkManager createNetworkEngineer]
     changeDriverOnDutyStatusWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDManagerViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDChangeDriverOnDutyResult *result = (OMDChangeDriverOnDutyResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             OMDManagerObject *obj = [sSelf.dataArray objectAtIndex:index];
             obj.isOnDuty = [NSString stringWithFormat:@"%zd",status];
             [sSelf.dataArray replaceObjectAtIndex:index withObject:obj];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
         [sSelf.tableView reloadData];
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDManagerViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
    
}

#pragma mark -- UITableView Datasource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak OMDManagerViewController *wSelf = self;
    NSString *cellID = @"";
    OMDManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OMDManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    OMDManagerObject *obj = [self.dataArray objectAtIndex:indexPath.row];
    [cell setupCellWithItem:obj index:indexPath.row actionBlock:^(NSInteger index, id obj) {
        OMDManagerViewController *sSelf = wSelf;
        NSNumber *numObj = (NSNumber *)obj;
        BOOL isOnDuty = [numObj boolValue];
        OMDManagerObject *blObj = [sSelf.dataArray objectAtIndex:index];
        [sSelf doChangeDriverOnDutyStatusWith:isOnDuty driverId:blObj.driverId index:index];
    }];
    return cell;
}

#pragma mark -- UITableView Delegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
