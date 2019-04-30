//
//  UnicodeScalarRange.h
//  Expression
//
//  Created by bob on 2019/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnicodeScalarRange : NSObject

+ (BOOL)isInOperatorRange:(UnicodeScalarValue)character;

+ (BOOL)isInIdentifierHeadRange:(UnicodeScalarValue)character;

+ (BOOL)isInIdentifierRange:(UnicodeScalarValue)character;

+ (BOOL)isValidateUnicode:(UnicodeScalarValue)character;

@end

NS_ASSUME_NONNULL_END
