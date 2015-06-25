//
//  OMBaseView.h
//  OneMenu
//
//  Created by simmyoung on 14-8-23.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OMDBaseObject.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "OMDUtility.h"

@interface OMDBaseView : UIView

typedef void(^CellAction)(NSInteger,id);

@property (nonatomic, copy) CellAction action;
@property (nonatomic, assign) NSInteger index;

- (void)setupViewWithItem:(OMDBaseObject *)item withActionBlock:(CellAction)actionBlock;

- (void)setupViewWithItem:(OMDBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)actionBlock;

@end
