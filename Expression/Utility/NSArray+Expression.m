//
//  NSArray+Expression.m
//  Expression
//
//  Created by bob on 2019/4/8.
//

#import "NSArray+Expression.h"

@implementation NSArray (Expression)

- (ExpArrayMap)map {
    __weak NSArray* warray = self;
    return ^NSArray*(ExpArrayMapOperator mo) {
        NSMutableArray *results = [NSMutableArray array];
        __strong NSArray *this = warray;
        for(id object in this) {
            [results addObject:mo(object)];
        }
        return results;
    };
}

- (ExpArrayFilter)filter {
    __weak NSArray* warray = self;
    return ^NSArray*(ExpArrayFilterOperator fo) {
        __strong NSArray *this = warray;
        NSMutableArray *results = [NSMutableArray array];
        for(id object in this) {
            if(fo(object)) {
                [results addObject:object];
            }
        }
        return results;
    };
}

- (ExpArrayReduce)reduce {
    __weak NSArray* warray = self;
    return ^id(id initial, ExpArrayReduceOperator ro) {
        __strong NSArray *array = warray;
        id result = initial;
        for(id object in array) {
            result = ro(result, object);
        }

        return result;
    };
}

- (ExpArrayFlatmap)flatmap {
    __weak NSArray* warray = self;
    return ^NSArray*(ExpArrayFlatmapOperator fmo) {
        NSMutableArray *results = [NSMutableArray array];
        __strong NSArray *this = warray;
        for(id object in this) {
            id newArray = fmo(object);
            if(newArray == nil) continue;
            [results addObjectsFromArray:newArray];
        }
        return results;
    };
}

- (ExpArrayApply)apply {
    __weak NSArray* warray = self;
    return ^NSArray*(NSArray* operators) {
        NSMutableArray *array = [NSMutableArray array];
        for(ExpArrayMapOperator mo in operators) {
            __strong NSArray *this = warray;
            [array addObjectsFromArray:this.map(mo)];
        }
        return array;
    };
}

- (NSArray*)reverse {
    return self.reverseObjectEnumerator.allObjects;
}

- (NSArray*)flatten {
    NSMutableArray *results = [NSMutableArray array];
    for(id obj in self) {
        if([obj isKindOfClass:[NSArray class]]) {
            [results addObjectsFromArray:((NSArray*)obj).flatten];
        } else {
            [results addObject:obj];
        }
    }
    return results;
}

- (ExpArrayJoin)join {
    __weak NSArray* warray = self;
    return ^NSString*(NSString *sep) {
        __strong NSArray *this = warray;
        return this.reduce(nil, ^id(NSString *ret, id obj){
            if(ret == nil) {
                return obj;
            } else {
                return [NSString stringWithFormat:@"%@%@%@", ret, sep, obj];
            }
        });
    };
}

- (ExpArrayForeach)foreach {
    __weak NSArray* warray = self;
    return ^(ExpArrayForeachOperator foreachOperator) {
        __strong NSArray *this = warray;
        for(NSInteger index = 0; index < this.count; ++index) {
            foreachOperator([this objectAtIndex:index], index);
        }
    };
}
@end
