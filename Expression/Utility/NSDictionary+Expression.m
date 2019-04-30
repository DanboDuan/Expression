//
//  NSDictionary+Expression.m
//  Expression
//
//  Created by bob on 2019/4/25.
//

#import "NSDictionary+Expression.h"

@implementation NSDictionary (Expression)

- (ExpDictionaryMapValue) mapValues {
    __weak NSDictionary* w = self;
    return ^NSMutableDictionary *(ExpDictionaryValueMapOperator mo) {
        NSMutableDictionary *results = [NSMutableDictionary dictionary];
        __strong NSDictionary *this = w;
        [this enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            id result = mo(object);
            [results setValue:result forKey:key];
        }];
        
        return results;
    };
}

- (ExpDictionaryMap) map {
    __weak NSDictionary* w = self;
    return ^NSMutableDictionary *(ExpDictionaryMapOperator mo) {
        NSMutableDictionary *results = [NSMutableDictionary dictionary];
        __strong NSDictionary *this = w;
        [this enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            id result = mo(key, object);
            [results setValue:result forKey:key];
        }];

        return results;
    };
}

@end
