//
//  EXError.h
//  Expression
//
//  Created by bob on 2019/4/11.
//

#import <Foundation/Foundation.h>

typedef NSInteger EXErrorCode;
@class Symbol;

FOUNDATION_EXPORT EXErrorCode const EXErrorCodeEmptyExpression;
FOUNDATION_EXPORT EXErrorCode const EXErrorCodeMessage;
FOUNDATION_EXPORT EXErrorCode const EXErrorCodeUnexpectedToken;
FOUNDATION_EXPORT EXErrorCode const EXErrorCodeMissingDelimiter;
FOUNDATION_EXPORT EXErrorCode const EXErrorCodeUndefinedSymbol;
FOUNDATION_EXPORT EXErrorCode const EXErrorCodeArityMismatch;
FOUNDATION_EXPORT EXErrorCode const EXErrorCodeArrayBounds;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const EXErrorDomain;

@interface EXError : NSError

@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, strong, readonly) Symbol *symbol;
@property (nonatomic, assign) double index;

+ (instancetype)errorWithCode:(EXErrorCode)code
                      message:(nullable NSString *)message
                       symbol:(nullable Symbol *)symbol
                        index:(double)index;

+ (instancetype)message:(NSString *)message;
+ (instancetype)unexpectedToken:(NSString *)message;
+ (instancetype)missingDelimiter:(NSString *)message;
+ (instancetype)undefinedSymbol:(Symbol *)symbol;
+ (instancetype)arityMismatch:(Symbol *)symbol;
+ (instancetype)arrayBounds:(Symbol *)symbol index:(double)index;
+ (instancetype)emptyExpression;

@end

NS_ASSUME_NONNULL_END
