//
//  Expression+Parse.h
//  Expression
//
//  Created by bob on 2019/6/22.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@class ParsedExpression, UnicodeScalarView;

@interface Expression (Parse)

+ (BOOL)isCached:(NSString *)expression;

+ (void)clearCacheFor:(NSString *)expression;

+ (ParsedExpression *)parse:(NSString *)expression;

+ (ParsedExpression *)parse:(NSString *)expression
                 usingCache:(BOOL)usingCache;

+ (ParsedExpression *)parse:(UnicodeScalarView * _Nonnull * _Nonnull)input
             upToDelimiters:(nullable NSArray<NSString *> *)delimiters;

@end

NS_ASSUME_NONNULL_END
