//
//  Expression.h
//  Pods-Demo
//
//  Created by bob on 2019/3/14.
//

#import <Foundation/Foundation.h>

typedef NSNumber * _Nonnull (^SymbolEvaluator)(NSArray<NSNumber *> * _Nonnull args);

typedef NS_OPTIONS(NSInteger, EXOption) {
    EXOptionNoOptimize      = 1 << 1,
    EXOptionBoolSymbols     = 1 << 2,
    EXOptionPureSymbols     = 1 << 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface Expression : NSObject

+ (void)Test;

@end

NS_ASSUME_NONNULL_END
