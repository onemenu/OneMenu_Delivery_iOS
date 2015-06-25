//
//  OMDSignUpViewController.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/14.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDSignUpViewController.h"

@interface OMDSignUpViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *emailTexf;
@property (nonatomic, strong) UITextField *pwTexf;
@property (nonatomic, strong) UITextField *confirmPwTexf;
@property (nonatomic, strong) UITextField *phoneTexf;
@property (nonatomic, strong) UITextField *nameTexf;
@property (nonatomic, strong) UITextField *addressTexf;

@property (nonatomic, assign) BOOL isUpView;

@end

@implementation OMDSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle:@"Sign Up"];
    [self setRightNavigationItemTittle:@"Submit" action:@selector(signUpSubmitAction)];
    
    CGRect rect = self.view.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (void)signUpSubmitAction
{
    if ([self.pwTexf.text isEqualToString:self.confirmPwTexf.text]) {
        [self doSignUpRequest];
    }
    else {
        [self showAlertViewWithMessage:@"Passwords do not match."];
    }
}

- (void)doSignUpRequest
{
    __weak OMDSignUpViewController *wSelf = self;
    [self showProcessHUD:nil];
    
    OMDSignUpRequest *request = [[OMDSignUpRequest alloc] init];
    request.email = self.emailTexf.text;
    request.password = self.pwTexf.text;
    request.phone = self.phoneTexf.text;
    request.name = self.nameTexf.text;
    request.address = self.addressTexf.text;
    
    [[OMDNetworkManager createNetworkEngineer]
     signUpWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         OMDSignUpViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         OMDSignUpResult *result = (OMDSignUpResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             if (sSelf.signUpSuccessedBlock) {
                 sSelf.signUpSuccessedBlock(sSelf.emailTexf.text);
             }
             [sSelf.navigationController popViewControllerAnimated:YES];
         }
         else {
             [sSelf showAlertViewWithMessage:result.msg];
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         OMDSignUpViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [sSelf showAlertViewWithMessage:kCheckNetConnection];
    }];
}

#define kCellheight 44.0
#pragma mark -- UITableView Datasource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (0 == indexPath.section) {
        if (!self.emailTexf) {
            self.emailTexf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
            self.emailTexf.delegate = self;
            self.emailTexf.tag = indexPath.section;
            self.emailTexf.borderStyle = UITextBorderStyleRoundedRect;
            self.emailTexf.textAlignment = NSTextAlignmentCenter;
            self.emailTexf.placeholder = @"Enter email address";
        }
        [cell addSubview:self.emailTexf];
    }
    else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            if (!self.pwTexf) {
                self.pwTexf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
                self.pwTexf.delegate = self;
                self.pwTexf.borderStyle = UITextBorderStyleRoundedRect;
                self.pwTexf.textAlignment = NSTextAlignmentCenter;
                self.pwTexf.tag = indexPath.section;
                self.pwTexf.placeholder = @"Enter your password";
            }
            [cell addSubview:self.pwTexf];
        }
        else {
            if (!self.confirmPwTexf) {
                self.confirmPwTexf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
                self.confirmPwTexf.delegate = self;
                self.confirmPwTexf.borderStyle = UITextBorderStyleRoundedRect;
                self.confirmPwTexf.textAlignment = NSTextAlignmentCenter;
                self.confirmPwTexf.tag = indexPath.section;
                self.confirmPwTexf.placeholder = @"Confirm your password";
            }
            [cell addSubview:self.confirmPwTexf];
        }
    }
    else if (2 == indexPath.section) {
        if (!self.phoneTexf) {
            self.phoneTexf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
            self.phoneTexf.delegate = self;
            self.phoneTexf.borderStyle = UITextBorderStyleRoundedRect;
            self.phoneTexf.textAlignment = NSTextAlignmentCenter;
            self.phoneTexf.tag = indexPath.section;
            self.phoneTexf.placeholder = @"Enter your phone number";
        }
        [cell addSubview:self.phoneTexf];
    }
    else if (3 == indexPath.section) {
        if (!self.nameTexf) {
            self.nameTexf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
            self.nameTexf.delegate = self;
            self.nameTexf.borderStyle = UITextBorderStyleRoundedRect;
            self.nameTexf.tag = indexPath.section;
            self.nameTexf.textAlignment = NSTextAlignmentCenter;
            self.nameTexf.placeholder = @"Enter your name";
        }
        [cell addSubview:self.nameTexf];
    }
    else {
        if (!self.addressTexf) {
            self.addressTexf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-2*10, kCellheight-5*2)];
            self.addressTexf.delegate = self;
            self.addressTexf.tag = indexPath.section;
            self.addressTexf.borderStyle = UITextBorderStyleRoundedRect;
            self.addressTexf.textAlignment = NSTextAlignmentCenter;
            self.addressTexf.placeholder = @"Enter your address";
        }
        [cell addSubview:self.addressTexf];
    }
    return cell;
}

#pragma mark -- UITextField Delegate --
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (textField.tag > 2) {
//        [self upViewAnimation];
//    }
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag > 1) {
        [self upViewAnimation];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag <= 1) {
        [self downViewAnimation];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self downViewAnimation];
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [self downViewAnimation];
//    return YES;
//}

#pragma mark -- View Animation --
- (void)upViewAnimation
{
    if (!self.isUpView) {
        __weak OMDSignUpViewController *wSelf = self;
        [UIView animateWithDuration:0.38
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                OMDSignUpViewController *sSelf = wSelf;
                                CGRect rect = sSelf.view.frame;
                                rect.origin.y -= kCellheight*4;
                                sSelf.view.frame = rect;
                            }
                         completion:^(BOOL finished) {
                             OMDSignUpViewController *sSelf = wSelf;
                             sSelf.isUpView = YES;
                         }];
    }
}

- (void)downViewAnimation
{
    if (self.isUpView) {
        __weak OMDSignUpViewController *wSelf = self;
        [UIView animateWithDuration:0.38
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                OMDSignUpViewController *sSelf = wSelf;
                                CGRect rect = sSelf.view.frame;
                                rect.origin.y = 0;
                                sSelf.view.frame = rect;
                            }
                         completion:^(BOOL finished) {
                             OMDSignUpViewController *sSelf = wSelf;
                             sSelf.isUpView = NO;
                         }];
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
