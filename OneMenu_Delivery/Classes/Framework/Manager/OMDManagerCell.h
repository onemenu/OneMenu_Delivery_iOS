//
//  OMDManagerCell.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/21.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseCell.h"

@interface OMDManagerCell : OMDBaseCell

@end

@interface OMDManagerObject : OMDBaseObject

@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *isOnDuty;

@end
