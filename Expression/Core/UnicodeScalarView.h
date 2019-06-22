//
//  UnicodeScalarView.h
//  Expression
//
//  Created by bob on 2019/4/12.
//

#import <Foundation/Foundation.h>
// UnicodeScalar 是 char
// UnicodeScalarView是chars
// char
// UnicodeScalarValue
// UTF32Char

NS_ASSUME_NONNULL_BEGIN

@class UnicodeScalarView, SubExpression, EXError;

@interface UnicodeScalarView : NSObject<NSCopying>

@property (nonatomic, readonly) UnicodeScalarValue *unicodeScalars;
@property (nonatomic, assign, readonly) NSUInteger length;
@property (nonatomic, readonly) NSString *scalarsString;

@property (nonatomic, assign, readonly) NSUInteger startIndex;
@property (nonatomic, assign, readonly) NSUInteger endIndex;

@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, assign, readonly) UnicodeScalarValue first;
@property (nonatomic, assign, readonly) UnicodeScalarValue last;

+ (instancetype)scalarViewWithString:(NSString *)scalarView;
+ (instancetype)scalarViewWithScalarView:(UnicodeScalarView *)scalarView;

- (UnicodeScalarValue)popFirst;
- (UnicodeScalarView *)dropLast;
- (UnicodeScalarValue)characterAtIndex:(NSUInteger)index;
- (BOOL)contains:(UnicodeScalarValue)character;

- (NSString *)escapedIdentifier;

- (UnicodeScalarView *)prefix:(NSUInteger)upTo;
- (UnicodeScalarView *)suffix:(NSUInteger)from;

#pragma mark - parse

- (SubExpression *)parseSubExpression:(NSArray<NSString *> *)delimiters error:(NSError *__autoreleasing *)outError;
- (SubExpression *)parseOperator;

@end

NS_ASSUME_NONNULL_END
