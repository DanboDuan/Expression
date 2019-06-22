//
//  ParsedExpression.m
//  Expression
//
//  Created by bob on 2019/4/11.
//

#import "ParsedExpression.h"
#import "SubExpression.h"
#import "Symbol.h"
#import "EXError.h"

@interface ParsedExpression ()

@property (nonatomic, strong) SubExpression *root;

@end

@implementation ParsedExpression

+ (instancetype)parsedExpressionWithRoot:(SubExpression *)root {
    return [[self alloc] initWithSubExpression:root];
}

- (instancetype)initWithSubExpression:(SubExpression *)root {
    self = [super init];
    if (self) {
        self.root = root;
    }

    return self;
}

- (NSSet<Symbol *> *)symbols {
    return self.root.symbols;
}

- (EXError *)error {
    switch (self.root.type) {
        case EXSubExpressionTypeError:
            return self.root.error;
        default:
            return nil;
    }
}

- (NSString *)description {
    return self.root.description;
}

@end
