//
//  NSString+HexValue.h
//  Expression
//
//  Created by bob on 2019/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HexValue)

@property (nonatomic, readonly) UnicodeScalarValue hexValue;

@end

NS_ASSUME_NONNULL_END
