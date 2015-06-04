//
//  OMDCalculateManager.h
//  OneMenu
//
//  Created by simmyoung on 15/4/1.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OMDCalculateManager : NSObject

+ (NSString *)addingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;
+ (NSString *)subtractingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;
+ (NSString *)multiplyingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;
+ (NSString *)dividingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;

+ (NSString *)addingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo;
+ (NSString *)subtractingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo;
+ (NSString *)multiplyingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo;
+ (NSString *)dividingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo;

+ (NSString *)upDoubleDecimalNumberWith:(NSString *)number;
+ (NSString *)upDoubleDecimalNumberWithFloat:(CGFloat)number;
+ (NSString *)downDoubleDecimalNumberWith:(NSString *)number;
+ (NSString *)downDoubleDecimalNumberWithFloat:(CGFloat)number;
+ (NSString *)roundBankerDoubleDecimalNumberWith:(NSString *)number;
+ (NSString *)roundBankerDoubleDecimalNumberWithFloat:(CGFloat)number;
+ (NSString *)plainDoubleDecimalNumberWith:(NSString *)number;
+ (NSString *)plainDoubleDecimalNumberWithFloat:(CGFloat)number;

+ (NSString *)transToRateWithString:(NSString *)numberStr;
+ (NSString *)transToRateWithFloat:(CGFloat)number;

+ (NSString *)transToInverseRateWithString:(NSString *)numberStr;
+ (NSString *)transToInverseRateWithFloat:(CGFloat)number;

+ (BOOL)isBiggerDecimalNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;
+ (BOOL)isEqualDecimalNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;
+ (BOOL)isSmallerDecimalNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo;

@end
