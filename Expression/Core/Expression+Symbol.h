//
//  Expression+Symbol.h
//  Expression
//
//  Created by bob on 2019/5/25.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@class Symbol;

@interface Expression (Symbol)

+ (NSDictionary<Symbol *, SymbolEvaluator> *)mathSymbols;
+ (NSDictionary<Symbol *, SymbolEvaluator> *)boolSymbols;

+ (NSArray<Symbol *> *)mathSymbolKeys;
+ (NSArray<Symbol *> *)boolSymbolKeys;

+ (SymbolEvaluator)errorEvaluatorForSymbol:(Symbol *)symbol;

@end

NS_ASSUME_NONNULL_END
