//
//  Arity.m
//  Expression
//
//  Created by bob on 2019/4/8.
//

#import "Arity.h"

@interface Arity ()

@end

@implementation Arity

- (instancetype)initWithValue:(NSInteger)value type:(EXArityType)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.rawValue = value;
    }

    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    Arity *copyed = [[self.class allocWithZone:zone] initWithValue:self.rawValue type:self.type];

    return copyed;
}

+ (instancetype)any {
    static Arity *any = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        any = [[self alloc] initWithValue:0 type:EXArityTypeAtLeast];
    });

    return any;
}

+ (instancetype)value:(NSInteger)value {
    return [[self alloc] initWithValue:value type:EXArityTypeExactly];
}

+ (instancetype)exactly:(NSInteger)value {
    return [[self alloc] initWithValue:value type:EXArityTypeExactly];
}

+ (instancetype)atLeast:(NSInteger)value {
    return [[self alloc] initWithValue:value type:EXArityTypeAtLeast];;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%zd argument%@",
            self.type == EXArityTypeExactly ? @"":@"at least ",
            self.rawValue,
            self.rawValue == 1 ? @"": @"s"];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Arity class]]) {
        return NO;
    }

    Arity *that = (Arity *)object;
    if (that.type == self.type) {
        return that.rawValue == self.rawValue;
    }

    NSInteger min = self.type == EXArityTypeAtLeast ? self.rawValue : that.rawValue;
    NSInteger value = self.type == EXArityTypeAtLeast ? that.rawValue : self.rawValue;

    return value > min;
}

- (NSUInteger)hash {
    return self.description.hash;
}


@end
