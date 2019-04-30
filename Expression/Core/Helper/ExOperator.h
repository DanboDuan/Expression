//
//  ExOperator.h
//  Expression
//
//  Created by bob on 2019/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExOperator : NSObject

@property (nonatomic, copy) NSString *op;
@property (nonatomic, assign) NSInteger precedence;
@property (nonatomic, assign) BOOL isRightAssociative;

@end

NS_ASSUME_NONNULL_END
