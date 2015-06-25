//
//  OMDTipsView.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/19.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseView.h"

typedef NS_ENUM(NSInteger, TipsType)
{
    TipsType_Non = 0,
    TipsType_Cash,
    TipsType_NonCash
};
@interface OMDTipsView : OMDBaseView

@property (nonatomic, copy) void (^confirmBlock)(TipsType type, NSString *tipsStr);

@property (nonatomic, assign) BOOL isShow;

- (void)show;

@end
