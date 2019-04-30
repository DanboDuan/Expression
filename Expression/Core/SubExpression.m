//
//  SubExpression.m
//  Expression
//
//  Created by bob on 2019/4/11.
//

#import "SubExpression.h"
#import "Symbol.h"
#import "Arity.h"
#import "EXError.h"
#import "NSArray+Expression.h"
#import "ExpressionUtility.h"
#import "Expression.h"

@interface SubExpression ()

@end

@implementation SubExpression

+ (instancetype)literalWithValue:(NSNumber *)value {
    SubExpression *sub = [self new];
    sub.type = EXSubExpressionTypeLiteral;
    sub.literalValue = value;

    return sub;
}

+ (instancetype)symbolWithSymbol:(Symbol *)symbol subs:(NSArray<SubExpression *> *)subs evaluator:(SymbolEvaluator)evaluator{
    SubExpression *sub = [self new];
    sub.type = EXSubExpressionTypeLiteral;
    sub.symbol = symbol;
    sub.subs = subs;
    sub.evaluator = evaluator;

    return sub;
}

+ (instancetype)errorWithError:(EXError *)error express:(NSString *)expression {
    SubExpression *sub = [self new];
    sub.type = EXSubExpressionTypeError;
    sub.error = error;
    sub.expression = expression;

    return sub;
}

- (BOOL)isOperand {
    switch (self.type) {
        case EXSubExpressionTypeError:      return NO;
        case EXSubExpressionTypeLiteral:    return YES;
        case EXSubExpressionTypeSymbol:{
            if (self.subs.count) {
                return YES;
            } else {
                switch (self.symbol.type) {
                    case EXSymbolTypePostfix:
                    case EXSymbolTypePrefix:
                    case EXSymbolTypeInfix:
                        return NO;
                    default:
                        return YES;
                }
            }
        }
    }

    return NO;
}

- (NSNumber *)evaluate:(NSError **)error {
    EXError *errorOut = nil;
    switch (self.type) {
        case EXSubExpressionTypeError:
            errorOut = self.error;
            if (error) {
                *error = errorOut;
            }
            break;
        case EXSubExpressionTypeLiteral:
            return self.literalValue;
        case EXSubExpressionTypeSymbol:{
            if (!self.evaluator) {
                errorOut = [EXError undefinedSymbol:self.symbol];
                if (error) {
                    *error = errorOut;
                }
                break;
            } else {
                NSMutableArray<NSNumber *> *values = [NSMutableArray array];
                for (SubExpression *sub in self.subs) {
                    NSNumber *value = [sub evaluate:error];
                    if (errorOut) {
                        break;
                    }
                    [values addObject:value];
                }
                if (!errorOut) {
                    return self.evaluator(values);
                }
                // return self.evaluator(self.subs.map(^ id (SubExpression * object) { return [object evaluate:error];}));
            }
        }
    }

    return @(0);
}

- (NSSet<Symbol *> *)symbols {
    switch (self.type) {
        case EXSubExpressionTypeSymbol:{
            NSMutableSet<Symbol *> *symbols = [NSMutableSet setWithObject:self.symbol];
            self.subs.foreach(^(SubExpression *object, NSInteger index) {
                [symbols unionSet:[object symbols]];
            });
            return symbols;
        }
        case EXSubExpressionTypeError:
        case EXSubExpressionTypeLiteral:
            return [NSSet set];
    }

    return [NSSet set];
}

- (SubExpression *)optimizedWithImpureSymbols:(SymbolEvaluator (^) (Symbol * symbol))impureSymbols
                                  pureSymbols:(SymbolEvaluator (^) (Symbol * symbol))pureSymbols {
    switch (self.type) {
        case EXSubExpressionTypeError:
        case EXSubExpressionTypeLiteral:
            return self;
        case EXSubExpressionTypeSymbol:{
            NSArray<SubExpression *> *args =  self.subs.map(^SubExpression *(SubExpression *object) {
                return [object optimizedWithImpureSymbols:impureSymbols pureSymbols:pureSymbols];
            });

            SymbolEvaluator fn = impureSymbols(self.symbol);
            if (fn) {
                return [SubExpression symbolWithSymbol:self.symbol subs:args evaluator:fn];
            }

            fn = pureSymbols(self.symbol);
            NSMutableArray<NSNumber *> *argValues = [NSMutableArray array];
            for (SubExpression *sub in args) {
                if (sub.type == EXSubExpressionTypeLiteral) {
                    [argValues addObject:sub.literalValue];
                } else {
                    return [SubExpression symbolWithSymbol:self.symbol subs:args evaluator:fn];
                }
            }

            if (fn) {
                NSNumber *result = fn(argValues);
                return [SubExpression literalWithValue:result];
            }
            
            return [SubExpression symbolWithSymbol:self.symbol subs:args evaluator:fn];
        }
    }

    return self;
}

- (NSString *)description {
    switch (self.type) {
        case EXSubExpressionTypeError:
            return self.expression;
        case EXSubExpressionTypeLiteral:
            return [ExpressionUtility stringifyDouble:self.literalValue.doubleValue];
        case EXSubExpressionTypeSymbol:{
            if (![self isOperand]) {
                return self.symbol.escapedName;
            }
            // todo

        }
    }
    return [NSString stringWithFormat:@"a"];
}

- (NSString *)arguments:(NSArray<SubExpression *> *)args {

    return args.map(^NSString *(SubExpression  *object) {
        if (object.type == EXSubExpressionTypeSymbol && object.symbol.type == EXSymbolTypeInfix) {
            return [NSString stringWithFormat:@"(%@)",object.description];
        }

        return object.description;
    }).join(@", ");
}

@end
