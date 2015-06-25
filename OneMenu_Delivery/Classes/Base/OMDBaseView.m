//
//  OMBaseView.m
//  OneMenu
//
//  Created by simmyoung on 14-8-23.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import "OMDBaseView.h"

@implementation OMDBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupViewWithItem:(OMDBaseObject *)item withActionBlock:(CellAction)actionBlock
{
    if (actionBlock) {
        self.action = actionBlock;
    }
}

- (void)setupViewWithItem:(OMDBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)actionBlock
{
    if (actionBlock) {
        self.action = actionBlock;
    }
    self.index = index;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
