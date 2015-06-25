//
//  OMDDeliveringCell.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDDeliveringCell.h"
#import "OMDDeliveringObject.h"

@interface OMDDeliveringCell()

@property (nonatomic, strong) UIView *containsView;
@property (nonatomic, strong) UILabel *readyInTimeLabel;
@property (nonatomic, strong) UILabel *billPirceLabel;
@property (nonatomic, strong) UILabel *custAddr;

@end

@implementation OMDDeliveringCell

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
    CGRect rect = self.bounds;
    rect.origin.x = 5;
    rect.size.width = rect.size.width-5*2;
    rect.size.height = [OMDDeliveringCell heightForCell];
    rect.origin.y = 5;
    rect.size.height -= 5*2;
    self.containsView = [[UIView alloc] initWithFrame:rect];
    self.containsView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.containsView.layer.borderWidth = 1.0f;
    self.containsView.layer.cornerRadius = 5.0;
    self.containsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containsView];
    
    self.readyInTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 21)];
    self.readyInTimeLabel.font = [UIFont systemFontOfSize:15.0];
    [self.containsView addSubview:self.readyInTimeLabel];
    
    self.billPirceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.containsView.frame.size.width-5-100, 5, 100, 21)];
    self.billPirceLabel.textAlignment = NSTextAlignmentRight;
    [self.containsView addSubview:self.billPirceLabel];
    
    self.custAddr = [[UILabel alloc] initWithFrame:CGRectMake(5, self.readyInTimeLabel.frame.origin.y+self.readyInTimeLabel.frame.size.height, rect.size.width-5*2, rect.size.height-5*2)];
    self.custAddr.lineBreakMode = NSLineBreakByTruncatingTail;
    self.custAddr.numberOfLines = 10;
    [self.containsView addSubview:self.custAddr];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithItem:(OMDBaseObject *)item
                    indexPath:(NSIndexPath *)indexPath
              actionBlock:(CellActionIndexPath)action
{
    [super setupCellWithItem:item indexPath:indexPath actionBlock:action];
    if ([item isKindOfClass:[OMDDeliveringOrderObject class]]) {
        OMDDeliveringOrderObject *obj = (OMDDeliveringOrderObject *)item;
        if (![OMDUtility StringIsEmptyWith:obj.readyInTime]) {
            if ([OMDCalculateManager isBiggerDecimalNumberWithStringOne:obj.readyInTime stringTwo:@"0"]) {
                self.readyInTimeLabel.text = [NSString stringWithFormat:@"Order ready in %@ Mins",obj.readyInTime];
            }
            else if ([OMDCalculateManager isSmallerDecimalNumberWithStringOne:obj.readyInTime stringTwo:@"0"]) {
                self.readyInTimeLabel.text = [NSString stringWithFormat:@"Order is ready %@ Mins",obj.readyInTime];
            }
            else {
                self.readyInTimeLabel.text = @"Order is ready now!";
            }
        }
        if (![OMDUtility StringIsEmptyWith:obj.custAddr]) {
            self.custAddr.text = obj.custAddr;
        }
        if (![OMDUtility StringIsEmptyWith:obj.billPrice]) {
            self.billPirceLabel.text = [NSString stringWithFormat:@"$ %@",obj.billPrice];
        }
        if (obj.status == OrderStatus_DriverUnConfirm) {
            self.containsView.backgroundColor = [UIColor redColor];
        }
        else if (obj.status == OrderStatus_DriverConfirmed) {
            self.containsView.backgroundColor = [UIColor greenColor];
        }
        else if (obj.status == OrderStatus_DriverCancel) {
            self.containsView.backgroundColor = [UIColor redColor];
        }
        else if (obj.status == OrderStatus_DriverDone) {
            self.containsView.backgroundColor = [UIColor lightGrayColor];
        }
        else {
            self.containsView.backgroundColor = [UIColor blackColor];
        }
    }
}

+ (CGFloat)heightForCell
{
    return 100;
}

@end
