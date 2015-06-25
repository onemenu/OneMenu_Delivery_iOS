//
//  OMDLoginViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/7.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDLoginViewController.h"
#import "OMDSignUpViewController.h"

@interface OMDLoginViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *custNameTxfd;
@property (nonatomic, strong) UITextField *passwordTxfd;

@property (nonatomic, strong) UIButton *loginBt;

@end

@implementation OMDLoginViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle:@"Sign In"];
    [self setRightNavigationItemTittle:@"Sign Up" action:@selector(signUpAction)];
    
    CGRect rect = self.view.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark -- Button Action
- (void)signUpAction
{
    __weak OMDLoginViewController *wSelf = self;
    OMDSignUpViewController *signUpCtrl = [[OMDSignUpViewController alloc] init];
    signUpCtrl.hidesBottomBarWhenPushed = YES;
    [signUpCtrl setSignUpSuccessedBlock:^(NSString *email) {
        OMDLoginViewController *sSelf = wSelf;
        sSelf.custNameTxfd.text = email;
        [sSelf.tableView reloadData];
    }];
    [self.navigationController pushViewController:signUpCtrl animated:YES];
}

- (void)loginAction:(UIButton *)sender
{
    [self showProcessHUD:nil];
    
    __weak OMDLoginViewController *wSelf = self;
    
    OMDLoginRequest *request = [[OMDLoginRequest alloc] init];
    request.account = self.custNameTxfd.text;
    request.password = self.passwordTxfd.text;
    
    [[OMDNetworkManager createNetworkEngineer]
     loginWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDLoginViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDLoginResult *result = (OMDLoginResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             [sSelf.view endEditing:YES];
             [OMDUtility saveLastLoginEmail:request.account];
             if (sSelf.loginSuccessedBlock) {
                 sSelf.loginSuccessedBlock();
             }
             [sSelf dismissViewControllerAnimated:YES completion:NULL];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDLoginViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

- (void)cancelAction:(id)sender
{
    if (self.loginCanceledBlock) {
        self.loginCanceledBlock();
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#define kCellheight 66.0
#pragma mark -- UITableView Datasrouce --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 2;
    }
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginTextFieldCell"];
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            if (!self.custNameTxfd) {
                self.custNameTxfd = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
                self.custNameTxfd.delegate = self;
                self.custNameTxfd.borderStyle = UITextBorderStyleRoundedRect;
                self.custNameTxfd.textAlignment = NSTextAlignmentCenter;
                self.custNameTxfd.placeholder = @"Enter your account";
                NSString *email = [OMDUtility getLastLoginEmail];
                if (![OMDUtility StringIsEmptyWith:email]) {
                    self.custNameTxfd.text = email;
                }
            }
            [cell addSubview:self.custNameTxfd];
        }
        else {
            if (!self.passwordTxfd) {
                self.passwordTxfd = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-10*2, kCellheight-2*5)];
                self.passwordTxfd.delegate = self;
                self.passwordTxfd.borderStyle = UITextBorderStyleRoundedRect;
                self.passwordTxfd.textAlignment = NSTextAlignmentCenter;
                self.passwordTxfd.secureTextEntry = YES;
                self.passwordTxfd.placeholder = @"Enter your passwork";
            }
            [cell addSubview:self.passwordTxfd];
        }
    }
    else {
        if (!self.loginBt) {
            self.loginBt = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.loginBt addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.loginBt setTitle:@"Login" forState:UIControlStateNormal];
            [self.loginBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.loginBt.frame = CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-2*5);
            self.loginBt.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            self.loginBt.layer.borderWidth = 1.0;
            self.loginBt.layer.cornerRadius = self.loginBt.frame.size.height/2;
        }
        [cell addSubview:self.loginBt];
    }
    cell.contentView.userInteractionEnabled = NO;
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
