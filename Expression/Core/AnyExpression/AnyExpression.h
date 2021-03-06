//
//  AnyExpression.h
//  Expression
//
//  Created by bob on 2019/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Symbol;

typedef id _Nullable (^AnyEvaluator)(NSArray *args, NSError **error);
typedef  AnyEvaluator _Nullable (^AnyEvaluatorForSymbol) (Symbol * symbol);

typedef id _Nullable (^Evaluator)(NSError **error);
typedef NSString * _Nullable (^Describer)(void);


@interface AnyExpression : NSObject

@end

NS_ASSUME_NONNULL_END
