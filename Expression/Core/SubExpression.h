//
//  SubExpression.h
//  Expression
//
//  Created by bob on 2019/4/11.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

typedef NS_ENUM(NSInteger, EXSubExpressionType) {
    EXSubExpressionTypeLiteral = 0,
    EXSubExpressionTypeSymbol,
    EXSubExpressionTypeError,
};

NS_ASSUME_NONNULL_BEGIN

@class Symbol, SubExpression, EXError;


@interface SubExpression : NSObject

@property (nonatomic, assign) EXSubExpressionType type;

// EXSubExpressionTypeLiteral
@property (nonatomic, assign) NSNumber *literalValue;

//EXSubExpressionTypeSymbol
@property (nonatomic, strong) Symbol *symbol;
@property (nonatomic, copy) NSArray<SubExpression *> *subs;
@property (nonatomic, copy) SymbolEvaluator evaluator;

//EXSubExpressionTypeError
@property (nonatomic, strong) EXError *error;
@property (nonatomic, copy) NSString *expression;

+ (instancetype)literalWithValue:(NSNumber *)value;
+ (instancetype)symbolWithSymbol:(Symbol *)symbol subs:(NSArray<SubExpression *> *)subs evaluator:(_Nullable SymbolEvaluator)evaluator;
+ (instancetype)errorWithError:(EXError *)error express:(NSString *)expression;

- (BOOL)isOperand;
- (NSNumber *)evaluate:(NSError *__autoreleasing *)error;
- (NSSet<Symbol *> *)symbols;
- (SubExpression *)optimizedWithImpureSymbols:(SymbolEvaluator (^) (Symbol * symbol))impureSymbols
                                  pureSymbols:(SymbolEvaluator (^) (Symbol * symbol))pureSymbols;

@end

NS_ASSUME_NONNULL_END
