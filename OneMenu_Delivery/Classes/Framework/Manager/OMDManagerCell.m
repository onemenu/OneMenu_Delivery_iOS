//
//  OMDManagerCell.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/21.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDManagerCell.h"

@interface OMDManagerCell ()

@property (nonatomic, strong) UISwitch *swc;

@end

@implementation OMDManagerCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.swc = [[UISwitch alloc] initWithFrame:CGRectMake(self.bounds.size.width-10-60, 5, 60, self.bounds.size.height-5*2)];
    [self.swc addTarget:self action:@selector(swcAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.swc];
    self.swc.on = NO;
}

- (void)swcAction:(UISwitch *)swc
{
    if (self.action) {
        self.action(self.index,[NSNumber numberWithBool:swc.on]);
    }
}

- (void)setupCellWithItem:(OMDBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)action
{
    [super setupCellWithItem:item index:index actionBlock:action];
    if ([item isKindOfClass:[OMDManagerObject class]]) {
        OMDManagerObject *obj = (OMDManagerObject *)item;
        self.textLabel.text = obj.driverName;
        self.swc.on = [obj.isOnDuty boolValue];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation OMDManagerObject

@end
