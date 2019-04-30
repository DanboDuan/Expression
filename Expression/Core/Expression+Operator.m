//
//  Expression+Operator.m
//  Expression
//
//  Created by bob on 2019/4/26.
//

#import "Expression+Operator.h"
#import "ExOperator.h"
#import "NSDictionary+Expression.h"
#import "NSString+UnicodeScalarView.h"
#import "UnicodeScalarView.h"
#import "UnicodeScalarRange.h"

@implementation Expression (Operator)

+ (NSDictionary<NSString *, ExOperator *> *)operatorPrecedence {
    static NSDictionary<NSString *, ExOperator *> *operatorPrecedence = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *precedences = @{@"[]": @(100),
                                             @"<<": @(2), @">>": @(2), @">>>": @(2),  // bitshift
                                             @"*": @(1), @"/": @(1), @"%": @(1), @"&": @(1), // multiplication
                                             // +, -, |, ^, etc: 0 (also the default)
                                             @"..": @(-1), @"...": @(-1), @"..<": @(-1), // range formation
                                             @"is": @(-2), @"as": @(-2), @"isa": @(-2), // casting
                                             @"??": @(-3), @"?:": @(-3), // null-coalescing
                                             // comparison: -4
                                             @"&&": @(-5), @"and": @(-5), // and
                                             @"||": @(-6), @"or": @(-6), // or
                                             @"?": @(-7), @":": @(-7), // ternary
                                             // assignment: -8
                                             @",": @(-100),
                                             }.map(^ExOperator *(NSString *key, NSNumber *precedence){
                                                  ExOperator *op = [ExOperator new];
                                                  op.op = key;
                                                  op.precedence = precedence.integerValue;
                                                  op.isRightAssociative = NO;
                                                  return op;
                                              });
        NSArray *comparisonOperators = @[@"<", @"<=", @">=", @">",
                                         @"==", @"!=", @"<>", @"===", @"!==",
                                         @"lt", @"le", @"lte", @"gt", @"ge", @"gte", @"eq", @"ne"];
        for (NSString *op in comparisonOperators) {
            ExOperator *oper = [ExOperator new];
            oper.op = op;
            oper.precedence = 4;
            oper.isRightAssociative = YES;
            [precedences setObject:oper forKey:op];
        }

        NSArray *assignmentOperators = @[@"=", @"*=", @"/=", @"%=", @"+=", @"-=",
                                         @"<<=", @">>=", @"&=", @"^=", @"|=", @":="];
        for (NSString *op in assignmentOperators) {
            ExOperator *oper = [ExOperator new];
            oper.op = op;
            oper.precedence = 8;
            oper.isRightAssociative = YES;
            [precedences setObject:oper forKey:op];
        }

        operatorPrecedence = precedences;
    });

    return operatorPrecedence;
}

+ (BOOL)isOperator:(NSString *)lhs takesPrecedenceOver:(NSString *)rhs {
    ExOperator *p1 = [[self operatorPrecedence] objectForKey:lhs] ?: [ExOperator new];
    ExOperator *p2 = [[self operatorPrecedence] objectForKey:rhs] ?: [ExOperator new];

    if (p1.precedence == p2.precedence) {
        return !p1.isRightAssociative;
    }

    return p1.precedence > p2.precedence;
}

+ (BOOL)isOperator:(UnicodeScalarValue)character {
    if ([@"/=­+!*%<>&|^~?:".unicodeScalars contains:character]) {
        return YES;
    }

    return [UnicodeScalarRange isInOperatorRange:character];
}

+ (BOOL)isIdentifierHead:(UnicodeScalarValue)character {
    return [UnicodeScalarRange isInIdentifierHeadRange:character];
}

+ (BOOL)isIdentifier:(UnicodeScalarValue)character {
    return [UnicodeScalarRange isInIdentifierRange:character];
}


@end
