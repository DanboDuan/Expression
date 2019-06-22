//
//  ParsedExpression.h
//  Expression
//
//  Created by bob on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EXError,Symbol,SubExpression;

@interface ParsedExpression : NSObject

@property (nonatomic, readonly) NSSet<Symbol *> *symbols;
@property (nonatomic, readonly) EXError *error;
@property (nonatomic, strong, readonly) SubExpression *root;

+ (instancetype)parsedExpressionWithRoot:(SubExpression *)root;
- (instancetype)initWithSubExpression:(SubExpression *)root;

@end

NS_ASSUME_NONNULL_END
