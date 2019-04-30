//
//  NSString+UnicodeScalarView.h
//  Expression
//
//  Created by bob on 2019/4/15.
//

#import <Foundation/Foundation.h>

@class UnicodeScalarView;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UnicodeScalarView)

+ (NSString *)stringWithUnicodeScalarValue:(UnicodeScalarValue)char32;

+ (NSString *)stringWithUnicodeScalarValues:(const UnicodeScalarValue *)char32 length:(NSUInteger)length;

- (nullable UnicodeScalarValue *)UnicodeScalarValues:(NSUInteger *)length;

@property (nonatomic, readonly) UnicodeScalarView *unicodeScalars;

@end

NS_ASSUME_NONNULL_END
