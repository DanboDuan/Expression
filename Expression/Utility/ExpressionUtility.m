//
//  ExpressionUtility.m
//  Expression
//
//  Created by bob on 2019/4/8.
//

#import "ExpressionUtility.h"

@implementation ExpressionUtility

+ (NSString *)stringifyDouble:(double)index {
    if (index - floor(index) < 1e-6) {
        return [NSString stringWithFormat:@"%.0f",index];
    }
    
    return [NSString stringWithFormat:@"%.4f",index];
}

@end
