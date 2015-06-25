//
//  OMDCalculateManager.m
//  OneMenu
//
//  Created by simmyoung on 15/4/1.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDCalculateManager.h"
#import "OMDUtility.h"

@implementation OMDCalculateManager

+ (NSString *)addingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEmptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEmptyStringTwo = stringTwo;
    }
    NSDecimalNumber *numberOne = [[NSDecimalNumber alloc] initWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [[NSDecimalNumber alloc] initWithString:nonEmptyStringTwo];
    numberOne = [numberOne decimalNumberByAdding:numberTwo];
    NSString *numberOneStr = [NSString stringWithFormat:@"%@",numberOne];
    return numberOneStr;
}

+ (NSString *)subtractingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEmptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEmptyStringTwo = stringTwo;
    }
    NSDecimalNumber *numberOne = [[NSDecimalNumber alloc] initWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [[NSDecimalNumber alloc] initWithString:nonEmptyStringTwo];
    numberOne = [numberOne decimalNumberBySubtracting:numberTwo];
    NSString *numberOneStr = [NSString stringWithFormat:@"%@",numberOne];
    return numberOneStr;
}

+ (NSString *)multiplyingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEmptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEmptyStringTwo = stringTwo;
    }
    NSDecimalNumber *numberOne = [[NSDecimalNumber alloc] initWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [[NSDecimalNumber alloc] initWithString:nonEmptyStringTwo];
    numberOne = [numberOne decimalNumberByMultiplyingBy:numberTwo];
    NSString *numberOneStr = [NSString stringWithFormat:@"%@",numberOne];
    return numberOneStr;
}

+ (NSString *)dividingNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEmptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEmptyStringTwo = stringTwo;
    }
    NSDecimalNumber *numberOne = [[NSDecimalNumber alloc] initWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [[NSDecimalNumber alloc] initWithString:nonEmptyStringTwo];
    numberOne = [numberOne decimalNumberByDividingBy:numberTwo];
    NSString *numberOneStr = [NSString stringWithFormat:@"%@",numberOne];
    return numberOneStr;
}

+ (NSString *)addingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo
{
    NSString *stringOne = [NSString stringWithFormat:@"%f",floatOne];
    NSString *stringTwo = [NSString stringWithFormat:@"%f",floatTwo];
    return [OMDCalculateManager addingNumberWithStringOne:stringOne stringTwo:stringTwo];
}

+ (NSString *)subtractingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo
{
    NSString *stringOne = [NSString stringWithFormat:@"%f",floatOne];
    NSString *stringTwo = [NSString stringWithFormat:@"%f",floatTwo];
    return [OMDCalculateManager subtractingNumberWithStringOne:stringOne stringTwo:stringTwo];
}

+ (NSString *)multiplyingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo
{
    NSString *stringOne = [NSString stringWithFormat:@"%f",floatOne];
    NSString *stringTwo = [NSString stringWithFormat:@"%f",floatTwo];
    return [OMDCalculateManager multiplyingNumberWithStringOne:stringOne stringTwo:stringTwo];
}

+ (NSString *)dividingNumberWithFloatOne:(CGFloat)floatOne floatTwo:(CGFloat)floatTwo
{
    NSString *stringOne = [NSString stringWithFormat:@"%f",floatOne];
    NSString *stringTwo = [NSString stringWithFormat:@"%f",floatTwo];
    return [OMDCalculateManager dividingNumberWithStringOne:stringOne stringTwo:stringTwo];
}

+ (NSString *)upDoubleDecimalNumberWith:(NSString *)number
{
//    CGFloat num = [number floatValue];
    NSString *nonEmptyNumber = @"0.00";
    if (![OMDUtility StringIsEmptyWith:number]) {
        nonEmptyNumber = number;
    }
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp
                                                                                                      scale:2
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:nonEmptyNumber];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)upDoubleDecimalNumberWithFloat:(CGFloat)number
{
    NSString *numberStr = [NSString stringWithFormat:@"%f",number];
    return [OMDCalculateManager upDoubleDecimalNumberWith:numberStr];
}

+ (NSString *)downDoubleDecimalNumberWith:(NSString *)number
{
    NSString *nonEmptyNumber = @"0.00";
    if (![OMDUtility StringIsEmptyWith:number]) {
        nonEmptyNumber = number;
    }
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:2
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:nonEmptyNumber];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)downDoubleDecimalNumberWithFloat:(CGFloat)number
{
    NSString *numberStr = [NSString stringWithFormat:@"%f",number];
    return [OMDCalculateManager downDoubleDecimalNumberWith:numberStr];
}

+ (NSString *)roundBankerDoubleDecimalNumberWith:(NSString *)number
{
    NSString *nonEmptyNumber = @"0.00";
    if (![OMDUtility StringIsEmptyWith:number]) {
        nonEmptyNumber = number;
    }
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                                      scale:2
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:nonEmptyNumber];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)roundBankerDoubleDecimalNumberWithFloat:(CGFloat)number
{
    NSString *numberStr = [NSString stringWithFormat:@"%f",number];
    return [OMDCalculateManager roundBankerDoubleDecimalNumberWith:numberStr];
}

+ (NSString *)plainDoubleDecimalNumberWith:(NSString *)number
{
    NSString *nonEmptyNumber = @"0.00";
    if (![OMDUtility StringIsEmptyWith:number]) {
        nonEmptyNumber = number;
    }
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                      scale:2
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:nonEmptyNumber];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)plainDoubleDecimalNumberWithFloat:(CGFloat)number
{
    NSString *numerStr = [NSString stringWithFormat:@"%f",number];
    return [OMDCalculateManager plainDoubleDecimalNumberWith:numerStr];
}

+ (NSString *)transToRateWithString:(NSString *)numberStr
{
    NSString *nonEmptyNumber = @"0.00";
    if (![OMDUtility StringIsEmptyWith:numberStr]) {
        nonEmptyNumber = numberStr;
    }
    NSString *rateStr = [OMDCalculateManager dividingNumberWithStringOne:nonEmptyNumber stringTwo:@"100"];
    return rateStr;
}

+ (NSString *)transToRateWithFloat:(CGFloat)number
{
    NSString *numberStr = [NSString stringWithFormat:@"%f",number];
    return [OMDCalculateManager transToRateWithString:numberStr];
}

+ (NSString *)transToInverseRateWithString:(NSString *)numberStr
{
    NSString *nonEmptyNumber = @"0.00";
    if (![OMDUtility StringIsEmptyWith:numberStr]) {
        nonEmptyNumber = numberStr;
    }
    NSString *rateStr = [OMDCalculateManager transToRateWithString:nonEmptyNumber];
    NSString *inverseRateStr = [OMDCalculateManager subtractingNumberWithStringOne:@"1" stringTwo:rateStr];
    return inverseRateStr;
}

+ (NSString *)transToInverseRateWithFloat:(CGFloat)number
{
    NSString *numberStr = [NSString stringWithFormat:@"%f",number];
    NSString *rateStr = [OMDCalculateManager transToRateWithString:numberStr];
    return [OMDCalculateManager transToInverseRateWithString:rateStr];
}

+ (BOOL)isBiggerDecimalNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEMptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEMptyStringTwo = stringTwo;
    }
    BOOL isBigger = NO;
    NSDecimalNumber *numberOne = [NSDecimalNumber decimalNumberWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [NSDecimalNumber decimalNumberWithString:nonEMptyStringTwo];
    NSComparisonResult result = [numberOne compare:numberTwo];
    if (result == NSOrderedAscending) {
        isBigger = NO;
        // <
    }
    else if (result == NSOrderedSame) {
        isBigger = NO;
        // =
    } else if (result == NSOrderedDescending) {
        // >
        isBigger = YES;
    }
    return isBigger;
}

+ (BOOL)isEqualDecimalNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEMptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEMptyStringTwo = stringTwo;
    }
    BOOL isEqual = NO;
    NSDecimalNumber *numberOne = [NSDecimalNumber decimalNumberWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [NSDecimalNumber decimalNumberWithString:nonEMptyStringTwo];
    NSComparisonResult result = [numberOne compare:numberTwo];
    if (result == NSOrderedAscending) {
        isEqual = NO;
        // <
    }
    else if (result == NSOrderedSame) {
        isEqual = YES;
        // =
    } else if (result == NSOrderedDescending) {
        // >
        isEqual = NO;
    }
    return isEqual;
}

+ (BOOL)isSmallerDecimalNumberWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo
{
    NSString *nonEmptyStringOne = @"0.00";
    NSString *nonEMptyStringTwo = @"0.00";
    if (![OMDUtility StringIsEmptyWith:stringOne]) {
        nonEmptyStringOne = stringOne;
    }
    if (![OMDUtility StringIsEmptyWith:stringTwo]) {
        nonEMptyStringTwo = stringTwo;
    }
    BOOL isSmaller = NO;
    NSDecimalNumber *numberOne = [NSDecimalNumber decimalNumberWithString:nonEmptyStringOne];
    NSDecimalNumber *numberTwo = [NSDecimalNumber decimalNumberWithString:nonEMptyStringTwo];
    NSComparisonResult result = [numberOne compare:numberTwo];
    if (result == NSOrderedAscending) {
        isSmaller = YES;
        // <
    }
    else if (result == NSOrderedSame) {
        isSmaller = NO;
        // =
    } else if (result == NSOrderedDescending) {
        // >
        isSmaller = NO;
    }
    return isSmaller;
}

@end
