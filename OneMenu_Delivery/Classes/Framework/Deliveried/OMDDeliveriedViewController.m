//
//  OMDDeliveriedViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/3.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDDeliveriedViewController.h"

#import "OMDDeliveringCell.h"

@interface OMDDeliveriedViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OMDDeliveriedViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Delivered";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
    
    [self.tableView addGifHeaderWithRefreshingBlock:^{
        
    }];
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    [self.tableView.header setUpdatedTimeHidden:YES];
}

- (void)refreshAction
{
    [self initData];
    [self.tableView.header endRefreshing];
    [self.tableView reloadData];
}

- (void)loadMoreAction
{
    [self.dataArray addObjectsFromArray:[[OMDFalseDataManager gemDeliveredDatas] mutableCopy]];
    [self.tableView.footer endRefreshing];
    [self.tableView reloadData];
}

- (void)initData
{
#ifdef APP_TEST
    self.dataArray = [NSMutableArray arrayWithArray:[[OMDFalseDataManager gemDeliveredDatas] mutableCopy]];
#else
    self.dataArray = [NSMutableArray array];
#endif
    
}

#pragma mark -- Network Methods --
- (void)doDeliveredRequest
{
    [self showProcessHUD:nil];
    
}

#pragma mark -- UITableView Datasource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OMDDeliveringCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"deliveriedCell";
    OMDDeliveringCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[OMDDeliveringCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    OMDDeliveredObject *obj = [self.dataArray objectAtIndex:indexPath.row];
    [cell setupCellWithItem:obj indexPath:indexPath actionBlock:NULL];
    cell.contentView.userInteractionEnabled = NO;
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
