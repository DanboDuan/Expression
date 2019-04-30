//
//  EXError.m
//  Expression
//
//  Created by bob on 2019/4/11.
//

#import "EXError.h"
#import "Arity.h"
#import "Symbol.h"
#import "ExpressionUtility.h"

NSString * const EXErrorDomain = @"com.expression.error";
EXErrorCode const EXErrorCodeEmptyExpression        = 0x100;
EXErrorCode const EXErrorCodeMessage                = 0x101;
EXErrorCode const EXErrorCodeUnexpectedToken        = 0x102;
EXErrorCode const EXErrorCodeMissingDelimiter       = 0x103;
EXErrorCode const EXErrorCodeUndefinedSymbol        = 0x104;
EXErrorCode const EXErrorCodeArityMismatch          = 0x105;
EXErrorCode const EXErrorCodeArrayBounds            = 0x106;

@interface EXError ()

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) Symbol *symbol;

@end

@implementation EXError

+ (instancetype)errorWithCode:(EXErrorCode)code
                      message:(NSString *)message
                       symbol:(Symbol *)symbol
                        index:(double)index {
    EXError *error = [self errorWithDomain:EXErrorDomain code:code userInfo:nil];
    error.message = message;
    error.symbol = symbol;
    error.index = index;

    return error;
}

+ (instancetype)message:(NSString *)message {
    return [self errorWithCode:(EXErrorCodeMessage) message:message symbol:nil index:0.0];
}

+ (instancetype)unexpectedToken:(NSString *)message {
    return [self errorWithCode:(EXErrorCodeUnexpectedToken) message:message symbol:nil index:0.0];
}

+ (instancetype)missingDelimiter:(NSString *)message {
    return [self errorWithCode:(EXErrorCodeMissingDelimiter) message:message symbol:nil index:0.0];
}

+ (instancetype)undefinedSymbol:(Symbol *)symbol {
    return [self errorWithCode:(EXErrorCodeUndefinedSymbol) message:nil symbol:symbol index:0.0];
}

+ (instancetype)arityMismatch:(Symbol *)symbol {
    return [self errorWithCode:(EXErrorCodeArityMismatch) message:nil symbol:symbol index:0.0];
}

+ (instancetype)arrayBounds:(Symbol *)symbol index:(double)index {
    return [self errorWithCode:(EXErrorCodeArrayBounds) message:nil symbol:symbol index:index];
}

+ (instancetype)emptyExpression {
    return [self errorWithCode:(EXErrorCodeUnexpectedToken) message:@"" symbol:nil index:0.0];
}

- (NSString *)description {
    switch (self.code) {
        case EXErrorCodeEmptyExpression:
            return @"Empty expression";
        case EXErrorCodeMessage:
            return self.message;
        case EXErrorCodeUnexpectedToken:
            return [NSString stringWithFormat:@"Unexpected token %@", self.message];
        case EXErrorCodeMissingDelimiter:
            return [NSString stringWithFormat:@"Missing %@", self.message];
        case EXErrorCodeUndefinedSymbol:
            return [NSString stringWithFormat:@"Undefined %@", self.symbol];
        case EXErrorCodeArityMismatch:
            return [NSString stringWithFormat:@"%@ expects %@", self.symbol, self.symbol.arity];
        case EXErrorCodeArrayBounds:
            return [NSString stringWithFormat:@"Index %@ out of bounds for %@", [ExpressionUtility stringifyDouble:self.index],self.symbol];
    }

    return [super description];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[EXError class]]) {
        return NO;
    }

    EXError *that = (EXError *)object;
    if (that.code == self.code) {
        return [self.message isEqualToString:that.message] || [self.symbol isEqual:that.symbol];
    }

    return NO;
}

@end
