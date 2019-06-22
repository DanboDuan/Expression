//
//  Expression.m
//  Pods-Demo
//
//  Created by bob on 2019/3/14.
//

#import "Expression.h"
#import "UnicodeScalarView.h"
#import "NSString+UnicodeScalarView.h"
#import "SubExpression.h"
#import "ParsedExpression.h"
#import "Arity.h"
#import "Symbol.h"
#import "EXError.h"

#import "Expression+Symbol.h"
#import "Expression+Operator.h"
#import "Expression+Parse.h"

@interface Expression ()

@property (nonatomic, strong) SubExpression *root;

@end

@implementation Expression

- (instancetype)initWithExpression:(NSString *)expression
                           options:(NSArray<NSNumber *> *)options
                         constants:(NSDictionary<NSString *, NSNumber *> *)constants
                            arrays:(NSDictionary<NSString *, NSArray *> *)arrays
                           symbols:(NSDictionary<Symbol *, SymbolEvaluator> *)symbols {

    ParsedExpression *parsed = [Expression parse:expression];
    return [self initWithParsedExpression:parsed
                                  options:options
                                constants:constants
                                   arrays:arrays
                                  symbols:symbols];
}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                                 options:(NSArray<NSNumber *> *)options
                               constants:(NSDictionary<NSString *, NSNumber *> *)constants
                                  arrays:(NSDictionary<NSString *, NSArray<NSNumber *> *> *)arrays
                                 symbols:(NSDictionary<Symbol *, SymbolEvaluator> *)symbols {
    NSDictionary<Symbol *, SymbolEvaluator> *boolSymbols = [options containsObject:@(EXOptionBoolSymbols)] ? [Expression boolSymbols] : @{};
    BOOL shouldOptimize = ![options containsObject:@(EXOptionNoOptimize)];
    BOOL pureSymbols = [options containsObject:@(EXOptionPureSymbols)];

    SymbolEvaluatorForSymbol symbolEvaluator = ^SymbolEvaluator (Symbol *symbol){
        if ([symbols objectForKey:symbol]) {
            return [symbols objectForKey:symbol];
        }
        if ([boolSymbols count] < 1
            && symbol.type == EXSymbolTypeInfix
            && [symbol.name isEqualToString:@"?:"]) {
            SymbolEvaluator lhs = symbols[[Symbol infix:@"?"]];
            SymbolEvaluator rhs = symbols[[Symbol infix:@":"]];
            if (lhs && rhs) {
                return ^NSNumber *(NSArray<NSNumber *> * args, NSError **error){
                    return lhs(@[rhs(@[args[0], args[1]], error), args[2]], error);
                };
            }
        }

        return nil;
    };

    SymbolEvaluatorForSymbol pureEvaluator = ^SymbolEvaluator (Symbol *symbol){
        switch (symbol.type) {
            case EXSymbolTypeVariable:
                if ([constants objectForKey:symbol.name]) {
                    NSNumber *constant = constants[symbol.name];
                    return ^NSNumber *(NSArray<NSNumber *> * args, NSError **error){
                        return constant;
                    };
                }
            case EXSymbolTypeArray:
                if ([arrays objectForKey:symbol.name]) {
                    NSArray<NSNumber *> *array = arrays[symbol.name];
                    return ^NSNumber *(NSArray<NSNumber *> * args, NSError **error){
                        NSUInteger index = [args[0] unsignedIntegerValue];
                        if (index <0 || index >= array.count) {
                            if (error) {
                                *error = [EXError arrayBounds:symbol index:args[0].doubleValue];
                            }
                            return nil;
                        }
                        return array[index];
                    };
                }
            default:
                if (!pureSymbols) {
                    SymbolEvaluator eval = symbolEvaluator(symbol);
                    if (eval) {
                        return eval;
                    }
                }
        }
        SymbolEvaluator fn = [[Expression mathSymbols] objectForKey:symbol] ?: [boolSymbols objectForKey:symbol];
        if (!fn) {
            if (EXSymbolTypeFunction == symbol.type && [symbols objectForKey:symbol]) {
                return ^NSNumber *(NSArray<NSNumber *> * args, NSError **error){
                    if (error) {
                        *error = [EXError arityMismatch:symbol];
                    }
                    return nil;
                };
            }

            return [Expression errorEvaluatorForSymbol:symbol];
        }

        return fn;
    };

    SymbolEvaluatorForSymbol impureEvaluator = ^SymbolEvaluator (Symbol *symbol){
        switch (symbol.type) {
            case EXSymbolTypeVariable:
                if (![constants objectForKey:symbol.name] && [symbols objectForKey:symbol]) {
                    return [symbols objectForKey:symbol];
                }
            case EXSymbolTypeArray:
                if (![arrays objectForKey:symbol.name] && [symbols objectForKey:symbol]) {
                    return [symbols objectForKey:symbol];
                }
            default:
                if (!pureSymbols) {
                    SymbolEvaluator eval= symbolEvaluator(symbol);
                    if (eval) {
                        return eval;
                    }
                }
        }

        return shouldOptimize ? nil : pureEvaluator(symbol);
    };

    return [self initWithParsedExpression:expression
                            impureSymbols:impureEvaluator
                              pureSymbols:pureEvaluator];
}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                           impureSymbols:(SymbolEvaluatorForSymbol)impureSymbols
                             pureSymbols:(SymbolEvaluatorForSymbol)pureSymbols {
    self = [super init];
    if (self) {
        if (!pureSymbols) {
            pureSymbols = ^SymbolEvaluator (Symbol *symbol){ return nil;};
        }
        if (!impureSymbols) {
            impureSymbols = ^SymbolEvaluator (Symbol *symbol){ return nil;};
        }
        
        SymbolEvaluatorForSymbol pureEvaluator = ^SymbolEvaluator (Symbol *symbol){

            SymbolEvaluator fn = pureSymbols(symbol) ?: [[Expression mathSymbols] objectForKey:symbol] ?: [[Expression boolSymbols] objectForKey:symbol];
            if (fn) {
                return fn;
            }

            if (EXSymbolTypeFunction == symbol.type) {
                for (NSUInteger index = 0; index <= 10; index++) {
                    Symbol *s = [Symbol function:symbol.name arity:[Arity exactly:index]];
                    fn = impureSymbols(s) ?: pureSymbols(s);
                    if (fn) {
                        return ^NSNumber *(NSArray<NSNumber *> * args, NSError **error){
                            if (error) {
                                *error = [EXError arityMismatch:s];
                            }
                            return nil;
                        };
                    }
                }
            }

            return [Expression errorEvaluatorForSymbol:symbol];;
        };
        self.root = [expression.root optimizedWithImpureSymbols:impureSymbols
                                                    pureSymbols:pureEvaluator];
    }
    return self;
}

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                             pureSymbols:(SymbolEvaluatorForSymbol)pureSymbols {
    return [self initWithParsedExpression:expression
                            impureSymbols:nil
                              pureSymbols:pureSymbols];
}

- (NSString *)description {
    return self.root.description;
}

- (NSSet<Symbol *> *)symbols {
    return [self.root symbols];
}

- (NSNumber *)evaluate:(NSError **)error {
    return [self.root evaluate:error];
}

@end
