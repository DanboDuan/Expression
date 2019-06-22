//
//  AnyExpression.m
//  Expression
//
//  Created by bob on 2019/6/22.
//

#import "AnyExpression.h"
#import "Expression+Parse.h"
#import "Expression+Symbol.h"
#import "Expression+Operator.h"

#import "Symbol.h"
#import "EXError.h"


@interface AnyExpression()

@property (nonatomic, strong) Expression *expression;
@property (nonatomic, strong) Describer describer;
@property (nonatomic, strong) Evaluator evaluator;

@end

@implementation AnyExpression

@end
