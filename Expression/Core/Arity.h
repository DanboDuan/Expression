//
//  Arity.h
//  Expression
//
//  Created by bob on 2019/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EXArityType) {
    EXArityTypeExactly = 0,
    EXArityTypeAtLeast,
};

@interface Arity : NSObject

@property (nonatomic, assign) EXArityType type;

@property (nonatomic, assign) NSInteger rawValue;

+ (instancetype)any;

+ (instancetype)value:(NSInteger)value;

+ (instancetype)exactly:(NSInteger)value;

+ (instancetype)atLeast:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
