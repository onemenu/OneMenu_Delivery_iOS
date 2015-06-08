//
//  OMBaseCell.m
//  OneMenu
//
//  Created by simmyoung on 14-8-23.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import "OMBaseCell.h"

@implementation OMBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.userInteractionEnabled = NO;
        [self resizeFrame];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.contentView.userInteractionEnabled = NO;
    [self resizeFrame];
}

- (void)resizeFrame
{
    CGRect rect = self.frame;
    rect.size.width = kScreenWidth;
    self.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithItem:(OMDBaseObject *)item indexPath:(NSIndexPath *)indexPath actionBlock:(CellActionIndexPath)action
{
    if (action) {
        self.indexPathAction = action;
    }
    self.indexPath = indexPath;
}

- (void)setupCellWithItem:(OMDBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)action
{
    if (action) {
        self.action = action;
    }
    self.index = index;
}

- (void)setupCellWithItems:(NSArray *)dataArray index:(NSInteger)index actionBlock:(CellAction)action
{
    if (action) {
        self.action = action;
    }
    self.index = index;
}

@end
