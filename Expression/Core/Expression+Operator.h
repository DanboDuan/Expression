//
//  Expression+Operator.h
//  Expression
//
//  Created by bob on 2019/4/26.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface Expression (Operator)

+ (BOOL)isOperator:(NSString *)lhs takesPrecedenceOver:(NSString *)rhs;
+ (BOOL)isOperator:(UnicodeScalarValue)character;
+ (BOOL)isIdentifierHead:(UnicodeScalarValue)character;
+ (BOOL)isIdentifier:(UnicodeScalarValue)character;

@end

NS_ASSUME_NONNULL_END
