//
//  Symbol.h
//  Expression
//
//  Created by bob on 2019/4/9.
//

#import <Foundation/Foundation.h>

@class Arity;

typedef NS_ENUM(NSInteger, EXSymbolType) {
    EXSymbolTypeVariable = 0,
    EXSymbolTypeInfix,
    EXSymbolTypePrefix,
    EXSymbolTypePostfix,
    EXSymbolTypeFunction,
    EXSymbolTypeArray,
};

NS_ASSUME_NONNULL_BEGIN

@interface Symbol : NSObject<NSCopying>

@property (nonatomic, assign, readonly) EXSymbolType type;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly, nullable) Arity *arity;

@property (nonatomic, copy, readonly) NSString *escapedName;

+ (instancetype)variable:(NSString *)name;

+ (instancetype)infix:(NSString *)name;

+ (instancetype)prefix:(NSString *)name;

+ (instancetype)postfix:(NSString *)name;

+ (instancetype)function:(NSString *)name arity:(Arity *)arity;

+ (instancetype)array:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
