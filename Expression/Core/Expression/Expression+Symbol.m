//
//  Expression+Symbol.m
//  Expression
//
//  Created by bob on 2019/5/25.
//

#import "Expression+Symbol.h"
#import "Symbol.h"
#import "Arity.h"
#import "NSArray+Expression.h"
#import "EXError.h"

typedef NSNumber * _Nonnull (^SymbolEvaluatorWithoutError)(NSArray<NSNumber *> * args);

@implementation Expression (Symbol)

+ (SymbolEvaluator)evaluator:(SymbolEvaluatorWithoutError)block {
    return ^NSNumber *(NSArray<NSNumber *> * args, NSError **error){
        return block(args);
    };
}

+ (NSDictionary<Symbol *, SymbolEvaluator> *)mathSymbols {
    static NSMutableDictionary<Symbol *, SymbolEvaluator> *symbols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = [NSMutableDictionary dictionary];
        symbols[[Symbol variable:@"pi"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(M_PI);
        }];

        symbols[[Symbol infix:@"+"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(args[0].doubleValue + args[1].doubleValue);
        }];
        symbols[[Symbol infix:@"-"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(args[0].doubleValue - args[1].doubleValue);
        }];
        symbols[[Symbol infix:@"*"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(args[0].doubleValue * args[1].doubleValue);
        }];
        symbols[[Symbol infix:@"/"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(args[0].doubleValue/args[1].doubleValue);
        }];
        symbols[[Symbol infix:@"%"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(fmod(args[0].doubleValue, args[1].doubleValue));
        }];

        symbols[[Symbol prefix:@"-"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(-args[0].doubleValue);
        }];

        symbols[[Symbol function:@"sqrt" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(sqrt(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"floor" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(floor(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"ceil" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(ceil(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"round" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(round(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"cos" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(cos(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"acos" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(acos(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"sin" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(sin(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"asin" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(asin(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"tan" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(tan(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"atan" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(atan(args[0].doubleValue));
        }];
        symbols[[Symbol function:@"abs" arity:[Arity exactly:1]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(ABS(args[0].doubleValue));
        }];

        symbols[[Symbol function:@"pow" arity:[Arity exactly:2]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(pow(args[0].doubleValue, args[1].doubleValue));
        }];
        symbols[[Symbol function:@"atan2" arity:[Arity exactly:2]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(atan2(args[0].doubleValue, args[1].doubleValue));
        }];
        symbols[[Symbol function:@"mod" arity:[Arity exactly:2]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(fmod(args[0].doubleValue, args[1].doubleValue));
        }];

        symbols[[Symbol function:@"max" arity:[Arity atLeast:2]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args.reduce(args[0],^ NSNumber *(NSNumber *result, NSNumber *object) {
                return @(MAX(result.doubleValue, object.doubleValue));
            });
        }];
        symbols[[Symbol function:@"min" arity:[Arity atLeast:2]]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args.reduce(args[0],^ NSNumber *(NSNumber *result, NSNumber *object) {
                return @(MIN(result.doubleValue, object.doubleValue));
            });
        }];

    });

    return symbols;
}

+ (NSDictionary<Symbol *, SymbolEvaluator> *)boolSymbols {
    static NSMutableDictionary<Symbol *, SymbolEvaluator> *symbols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = [NSMutableDictionary dictionary];
        symbols[[Symbol variable:@"true"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(1);
        }];
        symbols[[Symbol variable:@"false"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(0);
        }];
        symbols[[Symbol variable:@"YES"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(1);
        }];
        symbols[[Symbol variable:@"NO"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return @(0);
        }];


        symbols[[Symbol infix:@"=="]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return [args[0] isEqualToNumber:args[1]] == 0 ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@"!="]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return ![args[0] isEqualToNumber:args[1]] == 0 ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@">"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args[0].doubleValue > args[1].doubleValue ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@">="]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args[0].doubleValue >= args[1].doubleValue ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@"<"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args[0].doubleValue < args[1].doubleValue ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@"<="]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args[0].doubleValue <= args[1].doubleValue ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@"&&"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return (args[0].integerValue != 0 && args[1].integerValue != 0) ? @(1) : @(0);
        }];
        symbols[[Symbol infix:@"||"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return (args[0].integerValue != 0 || args[1].integerValue != 0) ? @(1) : @(0);
        }];

        symbols[[Symbol infix:@"?:"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            if (args.count == 3) {
                return args[0].integerValue != 0 ? args[1] : args[2];
            }

            return args[0].integerValue != 0 ? args[0] : args[1];
        }];

        symbols[[Symbol prefix:@"!"]] = [self evaluator:^NSNumber * _Nonnull(NSArray<NSNumber *> *args) {
            return args[0].integerValue == 0 ? @(1) : @(0);
        }];

    });

    return symbols;
}

+ (NSArray<Symbol *> *)mathSymbolKeys {
    static NSArray<Symbol *> *symbols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = [self mathSymbols].allKeys.copy;
    });

    return symbols;
}

+ (NSArray<Symbol *> *)boolSymbolKeys {
    static NSArray<Symbol *> *symbols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = [self boolSymbols].allKeys.copy;
    });

    return symbols;
}

+ (SymbolEvaluator)errorEvaluatorForSymbol:(Symbol *)symbol {
    EXSymbolType type = symbol.type;
    NSString *name = symbol.name;
    if (type == EXSymbolTypeInfix
        && ([name isEqualToString:@","]
            || [name isEqualToString:@"[]"]
            || [name isEqualToString:@"()"])) {

            return ^NSNumber *(NSArray<NSNumber *> * _Nonnull args,NSError **error) {
                if (error) {
                    *error = [EXError unexpectedToken:[name substringToIndex:1]];
                }
                return @(0);
            };
        }

    if (type == EXSymbolTypeFunction
        && [name isEqualToString:@"[]"]) {

        return ^NSNumber *(NSArray<NSNumber *> * _Nonnull args,NSError **error) {
            if (error) {
                *error = [EXError unexpectedToken:[name substringToIndex:1]];
            }
            return @(0);
        };
    }

    if (type == EXSymbolTypeFunction) {
        NSMutableSet *keys = [NSMutableSet setWithArray:[Expression mathSymbolKeys]];
        [keys addObjectsFromArray:[Expression boolSymbolKeys]];
        for (Symbol *kSymbol in keys) {
            if ([symbol.name isEqualToString:kSymbol.name] && [symbol.arity isEqual:kSymbol.arity]) {
                return ^NSNumber *(NSArray<NSNumber *> * _Nonnull args,NSError **error) {
                    if (error) {
                        *error = [EXError arityMismatch:kSymbol];
                    }
                    return @(0);
                };
            }
        }
    }


    return ^NSNumber *(NSArray<NSNumber *> * _Nonnull args,NSError **error) {
        if (error) {
            *error = [EXError undefinedSymbol:symbol];
        }
        return @(0);
    };
}

@end
