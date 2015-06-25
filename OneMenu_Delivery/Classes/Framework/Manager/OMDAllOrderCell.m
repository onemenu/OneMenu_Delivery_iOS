//
//  OMDAllOrderCell.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/21.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDAllOrderCell.h"
#import "OMDAllOrderObject.h"

@interface OMDAllOrderCell ()

@property (nonatomic, strong) UILabel *readyTimeLabel;
@property (nonatomic, strong) UILabel *orderCodeLabel;
@property (nonatomic, strong) UILabel *driverNameLabel;
@property (nonatomic, strong) UILabel *restNameLabel;

@end

@implementation OMDAllOrderCell

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
    self.readyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 25)];
    self.readyTimeLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.readyTimeLabel];
    
    self.orderCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 25)];
    self.orderCodeLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.orderCodeLabel];
    
    self.driverNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-10-100, 15, 100, 30)];
    self.driverNameLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.driverNameLabel];
    
    self.restNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderCodeLabel.frame.origin.y+self.orderCodeLabel.frame.size.height, self.bounds.size.width-10*2, 25)];
    self.restNameLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.restNameLabel];
}

- (void)setupCellWithItem:(OMDBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)action
{
    [super setupCellWithItem:item index:index actionBlock:action];
    if ([item isKindOfClass:[OMDAllOrderObject class]]) {
        OMDAllOrderObject *obj = (OMDAllOrderObject *)item;
        self.readyTimeLabel.text = [NSString stringWithFormat:@"Order Ready In %@ Mins",obj.inReadyTime];
        if (obj.status == OrderStatus_DriverConfirmed) {
            self.driverNameLabel.text = obj.driverName;
        }
        else if (obj.status == OrderStatus_DriverUnConfirm) {
            self.driverNameLabel.text = @"Pending";
        }
        self.orderCodeLabel.text = obj.orderCode;
        self.restNameLabel.text = obj.restName;
    }
}

+ (CGFloat)heightForCell
{
    return 60+25;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
