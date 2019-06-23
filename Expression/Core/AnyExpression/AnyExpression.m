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
#import "ParsedExpression.h"
#import "EXError.h"


@interface AnyExpression()

@property (nonatomic, strong) Expression *expression;
@property (nonatomic, strong) Describer describer;
@property (nonatomic, strong) Evaluator evaluator;

@end

@implementation AnyExpression

- (instancetype)initWithExpression:(NSString *)expression
                           options:(NSArray<NSNumber *> *)options
                         constants:(NSDictionary<NSString *, id> *)constants
                           symbols:(NSDictionary<Symbol *, AnyEvaluator> *)symbols {
    ParsedExpression *parsed = [Expression parse:expression];
    if (options.count < 1) {
        options = @[@(EXOptionBoolSymbols)];
    }
    return [self initWithParsedExpression:parsed
                                  options:options
                                constants:constants
                                  symbols:symbols];
}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                                 options:(NSArray<NSNumber *> *)options
                               constants:(NSDictionary<NSString *, id> *)constants
                                 symbols:(NSDictionary<Symbol *, AnyEvaluator> *)symbols {
    // TODO

    return nil;
}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                             pureSymbols:(AnyEvaluatorForSymbol)pureSymbols {

    return [self initWithParsedExpression:expression
                            impureSymbols:nil
                              pureSymbols:pureSymbols];

}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                           impureSymbols:(AnyEvaluatorForSymbol)impureSymbols
                             pureSymbols:(AnyEvaluatorForSymbol)pureSymbols {
    return [self initWithParsedExpression:expression
                                  options:@[@(EXOptionBoolSymbols)]
                                impureSymbols:impureSymbols
                              pureSymbols:pureSymbols];

}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                                 options:(NSArray<NSNumber *> *)options
                           impureSymbols:(AnyEvaluatorForSymbol)impureSymbols
                             pureSymbols:(AnyEvaluatorForSymbol)pureSymbols {
    if (!pureSymbols) {
        pureSymbols = ^AnyEvaluator (Symbol *symbol){ return nil;};
    }
    if (!impureSymbols) {
        impureSymbols = ^AnyEvaluator (Symbol *symbol){ return nil;};
    }
    // TODO

    return nil;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        // TODO
    }
    return self;
}

@end
