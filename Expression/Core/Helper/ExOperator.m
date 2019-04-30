//
//  ExOperator.m
//  Expression
//
//  Created by bob on 2019/4/26.
//

#import "ExOperator.h"

@implementation ExOperator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.precedence = 0;
        self.isRightAssociative = NO;
    }
    return self;
}

- (NSUInteger)hash {
    return self.op.hash;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ExOperator class]]) {
        return NO;
    }

    ExOperator *that = (ExOperator *)object;

    return [self.op compare:that.op] == NSOrderedSame;
}

@end
