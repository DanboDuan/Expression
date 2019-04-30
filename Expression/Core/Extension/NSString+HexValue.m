//
//  NSString+HexValue.m
//  Expression
//
//  Created by bob on 2019/4/28.
//

#import "NSString+HexValue.h"
#import "NSString+UnicodeScalarView.h"

@implementation NSString (HexValue)

- (UnicodeScalarValue)hexValue {
    NSUInteger length = 0;
    UnicodeScalarValue *characters = [self UnicodeScalarValues:&length];
    UnicodeScalarValue hexValue = 0;

    for (NSUInteger index = 0; index < length; index++) {
        UnicodeScalarValue character = characters[index];
        UnicodeScalarValue hex = 0;
        if (character >= '0' && character <= '9') {
            hex = character - '0';
        } else if (character >= 'A' && character <= 'F') {
            hex = character - 'A' + 10;
        } else if (character >= 'a' && character <= 'f') {
            hex = character - 'a' + 10;
        }
        
        hexValue += hex;
        if (index < length - 1) {
            hexValue *= 16;
        }
    }

    return hexValue;
}

@end
