//
//  Expression.m
//  Pods-Demo
//
//  Created by bob on 2019/3/14.
//

#import "Expression.h"
#import "UnicodeScalarView.h"
#import "NSString+UnicodeScalarView.h"


@implementation Expression

+ (void)Test {
    NSString *identifier = [NSString stringWithFormat:@" \u597D%C%c",0x597D,0x7D];
    UnicodeScalarView *identifierScalar = [identifier unicodeScalars];
    UnicodeScalarValue v = [identifierScalar characterAtIndex:0];
    if (v == ' ') {
        NSLog(@"test");
    }
}

@end
