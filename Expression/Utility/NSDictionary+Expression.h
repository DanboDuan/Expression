//
//  NSDictionary+Expression.h
//  Expression
//
//  Created by bob on 2019/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nonnull (^ExpDictionaryValueMapOperator)(id object);
typedef NSMutableDictionary * _Nonnull (^ExpDictionaryMapValue)(ExpDictionaryValueMapOperator mapOperator);

typedef id _Nonnull (^ExpDictionaryMapOperator)(id key, id object);
typedef NSMutableDictionary * _Nonnull (^ExpDictionaryMap)(ExpDictionaryMapOperator mapOperator);

@interface NSDictionary (Expression)

@property (readonly) ExpDictionaryMapValue mapValues;

@property (readonly) ExpDictionaryMap map;

@end

NS_ASSUME_NONNULL_END
