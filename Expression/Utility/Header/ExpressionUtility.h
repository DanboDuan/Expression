//
//  ExpressionUtility.h
//  Expression
//
//  Created by bob on 2019/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Convert a UTF-32 character (equal or larger than 0x10000) to two UTF-16 surrogate pair.

 @param char32 Input: a UTF-32 character (equal or larger than 0x10000, not in BMP)
 @param char16 Output: two UTF-16 characters.
 */
static inline void UTF32CharToUTF16SurrogatePair(UTF32Char char32, UTF16Char char16[_Nonnull 2]) {
    char32 -= 0x10000;
    char16[0] = (char32 >> 10) + 0xD800;
    char16[1] = (char32 & 0x3FF) + 0xDC00;
}

/**
 Convert UTF-16 surrogate pair to a UTF-32 character.

 @param char16 Two UTF-16 characters.
 @return A single UTF-32 character.
 */
static inline UTF32Char UTF16SurrogatePairToUTF32Char(UTF16Char char16[_Nonnull 2]) {
    return ((char16[0] - 0xD800) << 10) + (char16[1] - 0xDC00) + 0x10000;
}

@interface ExpressionUtility : NSObject

+ (NSString *)stringifyDouble:(double)index;

@end

NS_ASSUME_NONNULL_END
