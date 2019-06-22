//
//  Expression.h
//  Pods-Demo
//
//  Created by bob on 2019/3/14.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, EXOption) {
    EXOptionNoOptimize      = 1 << 1,
    EXOptionBoolSymbols     = 1 << 2,
    EXOptionPureSymbols     = 1 << 3,
};

NS_ASSUME_NONNULL_BEGIN
@class Symbol, ParsedExpression;

typedef NSNumber * _Nonnull (^SymbolEvaluator)(NSArray<NSNumber *> * args, NSError **error);
typedef  SymbolEvaluator _Nullable (^SymbolEvaluatorForSymbol) (Symbol * symbol);

@interface Expression : NSObject

@property (nonatomic, strong, readonly) NSSet<Symbol *> *symbols;

- (instancetype)initWithExpression:(NSString *)expression
                           options:(NSArray<NSNumber *> *)options
                         constants:(nullable NSDictionary<NSString *, NSNumber *> *)constants
                            arrays:(nullable NSDictionary<NSString *, NSArray *> *)arrays
                           symbols:(nullable NSDictionary<Symbol *, SymbolEvaluator> *)symbols;

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                                 options:(NSArray<NSNumber *> *)options
                               constants:(nullable NSDictionary<NSString *, NSNumber *> *)constants
                                  arrays:(nullable NSDictionary<NSString *, NSArray<NSNumber *> *> *)arrays
                                 symbols:(nullable NSDictionary<Symbol *, SymbolEvaluator> *)symbols;

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                           impureSymbols:(nullable SymbolEvaluatorForSymbol)impureSymbols
                             pureSymbols:(nullable SymbolEvaluatorForSymbol)pureSymbols;

- (instancetype)initWithParsedExpression:(ParsedExpression *)expression
                             pureSymbols:(nullable SymbolEvaluatorForSymbol)pureSymbols;

- (NSNumber *)evaluate:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
