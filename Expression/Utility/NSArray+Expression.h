//
//  NSArray+Expression.h
//  Expression
//
//  Created by bob on 2019/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nonnull (^ExpArrayMapOperator)(id object);
typedef NSArray * _Nonnull (^ExpArrayMap)(ExpArrayMapOperator mapOperator);

typedef BOOL (^ExpArrayFilterOperator)(id object);
typedef NSArray * _Nonnull (^ExpArrayFilter)(ExpArrayFilterOperator filterOperator);

typedef id _Nonnull (^ExpArrayReduceOperator)(id result, id object);
typedef id _Nonnull (^ExpArrayReduce) (id _Nullable initialValue, ExpArrayReduceOperator reduceOperator);

typedef NSString * _Nonnull (^ExpArrayJoin)(NSString *sep);

typedef void (^ExpArrayForeachOperator)(id object, NSInteger index);
typedef void (^ExpArrayForeach)(ExpArrayForeachOperator foreachOperator);

typedef NSArray * _Nonnull (^ExpArrayFlatmapOperator)(id object);
typedef NSArray * _Nonnull (^ExpArrayFlatmap) (ExpArrayFlatmapOperator reduceOperator);

typedef NSArray * _Nonnull (^ExpArrayApply) (NSArray<ExpArrayMapOperator> *mapOperators);

@interface NSArray (Expression)

@property (readonly) ExpArrayMap map;

@property (readonly) ExpArrayFlatmap flatmap;

@property (readonly) ExpArrayApply apply;

@property (readonly) ExpArrayFilter filter;

@property (readonly) NSArray* reverse;

@property (readonly) NSArray* flatten;

@property (readonly) ExpArrayReduce reduce;

@property (readonly) ExpArrayJoin join;

@property (readonly) ExpArrayForeach foreach;


@end

NS_ASSUME_NONNULL_END
