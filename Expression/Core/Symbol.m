//
//  Symbol.m
//  Expression
//
//  Created by bob on 2019/4/9.
//

#import "Symbol.h"
#import "Arity.h"
#import "UnicodeScalarView.h"

@interface Symbol ()

@property (nonatomic, assign) EXSymbolType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong, nullable) Arity *arity;

@end

@implementation Symbol

- (instancetype)initWithName:(NSString *)name type:(EXSymbolType)type arity:(Arity *)arity {
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.arity = arity;
    }
    
    return self;
}

- (NSUInteger)hash {
    return self.name.hash;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Symbol class]]) {
        return NO;
    }

    Symbol *that = (Symbol *)object;
    if (that.type == self.type) {
        if (self.type == EXSymbolTypeFunction) {
            return [that.name compare:self.name] == NSOrderedSame && [self.arity isEqual:that.arity];
        }

        return [that.name compare:self.name] == NSOrderedSame;
    }

    return NO;
}

- (Arity *)arity {
    if (!_arity) {
        switch (self.type) {
            case EXSymbolTypeFunction:      break;
            case EXSymbolTypeVariable:
                _arity = [Arity value:0];   break;
            case EXSymbolTypeArray:
            case EXSymbolTypePostfix:
            case EXSymbolTypePrefix:
                _arity = [Arity value:1];   break;
            case EXSymbolTypeInfix:
                if ([self.name compare:@"?:"] == NSOrderedSame) {
                    _arity = [Arity value:3];       break;
                } else if ([self.name compare:@"[]"] == NSOrderedSame) {
                    _arity = [Arity value:1];       break;
                } else if ([self.name compare:@"()"] == NSOrderedSame) {
                    _arity = [Arity atLeast:1];     break;
                } else {
                    _arity = [Arity value:2];       break;
                }

        }
    }

    return _arity;
}

- (NSString *)description {
    switch (self.type) {
        case EXSymbolTypeVariable:
            return [NSString stringWithFormat:@"variable %@", self.escapedName];
        case EXSymbolTypeArray:
            return [NSString stringWithFormat:@"array %@[]", self.escapedName];
        case EXSymbolTypeFunction:
            return [NSString stringWithFormat:@"function %@()", self.escapedName];
        case EXSymbolTypePostfix:
            return [NSString stringWithFormat:@"postfix operator %@", self.escapedName];
        case EXSymbolTypePrefix:
            return [NSString stringWithFormat:@"prefix operator %@", self.escapedName];
        case EXSymbolTypeInfix:
            if ([self.name compare:@"?:"] == NSOrderedSame) {
                return [NSString stringWithFormat:@"ternary operator %@", self.escapedName];
            }
            if ([self.name compare:@"[]"] == NSOrderedSame) {
                return [NSString stringWithFormat:@"subscript operator %@", self.escapedName];
            }
            if ([self.name compare:@"()"] == NSOrderedSame) {
                return [NSString stringWithFormat:@"function call operator %@", self.escapedName];
            }
            return [NSString stringWithFormat:@"infix operator %@", self.escapedName];
    }

    return @"Unknow Symbol";
}

- (NSString *)escapedName {
    return [[UnicodeScalarView scalarViewWithString:self.name] escapedIdentifier];
}

+ (instancetype)variable:(NSString *)name {
    return [[self alloc] initWithName:name type:EXSymbolTypeVariable arity:nil];
}

+ (instancetype)infix:(NSString *)name {
    return [[self alloc] initWithName:name type:EXSymbolTypeInfix arity:nil];
}

+ (instancetype)prefix:(NSString *)name {
    return [[self alloc] initWithName:name type:EXSymbolTypePrefix arity:nil];
}

+ (instancetype)postfix:(NSString *)name {
    return [[self alloc] initWithName:name type:EXSymbolTypePostfix arity:nil];
}

+ (instancetype)function:(NSString *)name arity:(Arity *)arity {
    return [[self alloc] initWithName:name type:EXSymbolTypeFunction arity:arity];
}

+ (instancetype)array:(NSString *)name {
    return [[self alloc] initWithName:name type:EXSymbolTypeArray arity:nil];
}

@end
