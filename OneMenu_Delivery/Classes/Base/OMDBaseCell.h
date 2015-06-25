//
//  OMBaseCell.h
//  OneMenu
//
//  Created by simmyoung on 14-8-23.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "OMDBaseObject.h"
#import "OMDUtility.h"
#import "SWTableViewCell.h"

typedef void(^CellAction)(NSInteger index, id obj);
typedef void(^CellActionIndexPath) (NSIndexPath *indexPath, id obj);

@interface OMDBaseCell : SWTableViewCell

@property (copy, nonatomic) CellAction action;
@property (copy, nonatomic) CellActionIndexPath indexPathAction;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL buttonHide;

- (void)setupCellWithItem:(OMDBaseObject *)item indexPath:(NSIndexPath *)indexPath actionBlock:(CellActionIndexPath)action;

- (void)setupCellWithItem:(OMDBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)action;

- (void)setupCellWithItems:(NSArray *)dataArray index:(NSInteger)index actionBlock:(CellAction)action;

@end
