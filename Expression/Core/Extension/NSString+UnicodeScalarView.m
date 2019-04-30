//
//  NSString+UnicodeScalarView.m
//  Expression
//
//  Created by bob on 2019/4/15.
//

#import "NSString+UnicodeScalarView.h"
#import "UnicodeScalarView.h"

@implementation NSString (UnicodeScalarView)

+ (NSString *)stringWithUnicodeScalarValue:(UnicodeScalarValue)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[self alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)stringWithUnicodeScalarValues:(const UnicodeScalarValue *)char32 length:(NSUInteger)length {
    return [[self alloc] initWithBytes:(const void *)char32
                                    length:length * 4
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

- (nullable UnicodeScalarValue *)UnicodeScalarValues:(NSUInteger *)length {
   *length = [self lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    UnicodeScalarValue *characters = (UnicodeScalarValue *)[self cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    [self UTF8String];
    return characters;
}

- (UnicodeScalarView *)unicodeScalars {
    return [UnicodeScalarView scalarViewWithString:self];
}

@end
