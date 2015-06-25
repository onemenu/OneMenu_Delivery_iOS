//
//  OMDTipsView.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/19.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDTipsView.h"

@interface OMDTipsView ()
<UITextFieldDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *containsView;
@property (nonatomic, strong) UIButton *cashButton;
@property (nonatomic, strong) UIButton *nonCashButton;
@property (nonatomic, strong) UITextField *tipsTextfield;
@property (nonatomic, strong) UIButton *confirmBt;
@property (nonatomic, strong) UIButton *cancelBt;

@property (nonatomic, assign) TipsType type;

@end

@implementation OMDTipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    self.frame = frame;
    
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0.8;
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.containsView = [[UIView alloc] initWithFrame:CGRectMake(10, 64+20, self.bounds.size.width-2*10, 130)];
    self.containsView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containsView];
    
    self.cashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cashButton.backgroundColor = [UIColor greenColor];
    self.cashButton.frame = CGRectMake(10, 5, (self.containsView.bounds.size.width-2*10-20)/2, 40);
    [self.cashButton addTarget:self action:@selector(cashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cashButton setTitle:@"CashTips" forState:UIControlStateNormal];
    [self.containsView addSubview:self.cashButton];
    
    self.nonCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nonCashButton.frame = CGRectMake(self.cashButton.frame.origin.x+self.cashButton.frame.size.width+20, 5, self.cashButton.frame.size.width, 40);
    self.nonCashButton.backgroundColor = [UIColor greenColor];
    [self.nonCashButton addTarget:self action:@selector(nonCashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nonCashButton setTitle:@"NonCashTips" forState:UIControlStateNormal];
    [self.containsView addSubview:self.nonCashButton];
    
    self.tipsTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, self.cashButton.frame.origin.y+self.cashButton.frame.size.height+5, self.containsView.frame.size.width-10*2, 30)];
    self.tipsTextfield.delegate = self;
    self.tipsTextfield.placeholder = @"Input the tips fee in your order form";
    self.tipsTextfield.textColor = [UIColor darkTextColor];
    self.tipsTextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.tipsTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [self.containsView addSubview:self.tipsTextfield];
    
    self.cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBt.backgroundColor = [UIColor greenColor];
    self.cancelBt.frame = CGRectMake(10, self.tipsTextfield.frame.origin.y+self.tipsTextfield.frame.size.height+5, self.cashButton.frame.size.width, 40);
    [self.cancelBt addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBt setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.containsView addSubview:self.cancelBt];
    
    self.confirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBt.backgroundColor = [UIColor greenColor];
    self.confirmBt.frame = CGRectMake(self.nonCashButton.frame.origin.x, self.cancelBt.frame.origin.y, self.cancelBt.frame.size.width, 40);
    [self.confirmBt addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBt setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.containsView addSubview:self.confirmBt];
    self.tipsTextfield.hidden = YES;
    [self show];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self hide];
}

- (void)cashAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.nonCashButton.selected = NO;
        [self.tipsTextfield resignFirstResponder];
        self.type = TipsType_Cash;
        self.tipsTextfield.hidden = YES;
        self.tipsTextfield.text = @"";
    }
    else {
        self.type = TipsType_Non;
        self.tipsTextfield.hidden = YES;
        self.tipsTextfield.text = @"";
    }
    [self refreshCashNonCashBt];
}

- (void)nonCashAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.cashButton.selected = NO;
        self.type = TipsType_NonCash;
        self.tipsTextfield.hidden = NO;
        self.tipsTextfield.text = @"";
        [self.tipsTextfield becomeFirstResponder];
    }
    else {
        self.type = TipsType_Non;
        self.tipsTextfield.hidden = YES;
        self.tipsTextfield.text = @"";
        [self.tipsTextfield resignFirstResponder];
    }
    [self refreshCashNonCashBt];
}

- (void)cancelAction:(UIButton *)sender
{
    [self hide];
}

#define kTipsTypeNonAlertTag 692
#define kTipsTypeNonCashAlertTag 693
- (void)confirmAction:(UIButton *)sender
{
    if (self.type == TipsType_Non) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Choose Tips Type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alertView.tag = kTipsTypeNonAlertTag;
        [alertView show];
    }
    else if (self.type == TipsType_NonCash) {
        if ([OMDUtility StringIsEmptyWith:self.tipsTextfield.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Input The Tips Fee" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = kTipsTypeNonCashAlertTag;
            [alert show];
        }
        else {
            if (self.confirmBlock) {
                self.confirmBlock(self.type,self.tipsTextfield.text);
            }
            [self hide];
        }
    }
    else {
        if (self.confirmBlock) {
            self.confirmBlock(self.type,nil);
        }
        [self hide];
    }
}

- (void)refreshCashNonCashBt
{
    if (self.cashButton.selected) {
        self.cashButton.layer.borderColor = [[UIColor redColor] CGColor];
        self.cashButton.layer.borderWidth = 1.0;
    }
    else {
        self.cashButton.layer.borderColor = [[UIColor clearColor] CGColor];
        self.cashButton.layer.borderWidth = 1.0;
    }
    if (self.nonCashButton.selected) {
        self.nonCashButton.layer.borderColor = [[UIColor redColor] CGColor];
        self.nonCashButton.layer.borderWidth = 1.0;
    }
    else {
        self.nonCashButton.layer.borderColor = [[UIColor clearColor] CGColor];
        self.nonCashButton.layer.borderWidth = 1.0;
    }
}

- (void)show
{
    if (!self.isShow) {
        __weak OMDTipsView *wSelf = self;
        [UIView animateWithDuration:0.38
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                OMDTipsView *sSelf = wSelf;
                                CGRect frame = sSelf.frame;
                                frame.origin.y = 0;
                                sSelf.frame = frame;
                            }
                         completion:^(BOOL finished) {
                             OMDTipsView *sSelf = wSelf;
                             sSelf.isShow = YES;
                         }];
    }
}

- (void)hide
{
    if (self.isShow) {
        self.type = TipsType_Non;
        self.cashButton.selected = NO;
        self.nonCashButton.selected = NO;
        [self refreshCashNonCashBt];
        self.tipsTextfield.hidden = YES;
        [self.tipsTextfield resignFirstResponder];
        __weak OMDTipsView *wSelf = self;
        [UIView animateWithDuration:0.38
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                OMDTipsView *sSelf = wSelf;
                                CGRect frame = sSelf.frame;
                                frame.origin.y = -frame.size.height;
                                sSelf.frame = frame;
                                sSelf.cashButton.selected = NO;
                                sSelf.nonCashButton.selected = NO;
                                [sSelf refreshCashNonCashBt];
                                sSelf.tipsTextfield.text = @"";
        }
                         completion:^(BOOL finished) {
                             OMDTipsView *sSelf = wSelf;
                             sSelf.isShow = NO;
        }];
    }
}

#pragma mark -- UITextField Delegate --
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString:@"."]) {
        if ([textField.text rangeOfString:@"."].length > 0) {
            return NO;
        }
    }
    if ([result rangeOfString:@"."].length > 0) {
        NSArray *textArray = [result componentsSeparatedByString:@"."];
        if (textArray && textArray.count>1) {
            NSString *lastStr = [textArray objectAtIndex:1];
            if (lastStr.length>2) {
                return NO;
            }
        }
    }
    if (![OMDUtility isOnlyDicamalPointAndDitgitNumberWithString:result]) {
        return NO;
    }
    if ([result isEqualToString:@"."]) {
        return NO;
    }
    return YES;
}

#pragma mark -- UIAlertView Delegate --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kTipsTypeNonAlertTag) {
        
    }
    else if (alertView.tag == kTipsTypeNonCashAlertTag) {
        
    }
}

@end
