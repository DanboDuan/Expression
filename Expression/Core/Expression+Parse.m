//
//  Expression+Parse.m
//  Expression
//
//  Created by bob on 2019/6/22.
//

#import "Expression+Parse.h"
#import "ParsedExpression.h"
#import "SubExpression.h"
#import "UnicodeScalarView.h"

@implementation Expression (Parse)

+ (NSMutableDictionary<NSString *, SubExpression *> *)cache {
    static NSMutableDictionary<NSString *, SubExpression *> *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMutableDictionary new];
    });

    return cache;
}

+ (dispatch_queue_t)queue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.expression.cache", DISPATCH_QUEUE_SERIAL);
    });

    return queue;
}

+ (BOOL)isCached:(NSString *)expression {
    __block BOOL isCached = NO;
    dispatch_sync([self queue], ^{
        isCached = [[self cache] objectForKey:expression] != nil;
    });

    return isCached;
}

+ (void)clearCacheFor:(NSString *)expression {
    dispatch_async([self queue], ^{
        if (expression) {
            [[self cache] removeObjectForKey:expression];
        } else {
            [[self cache] removeAllObjects];
        }

    });
}

+ (ParsedExpression *)parse:(NSString *)expression {
    return [self parse:expression usingCache:YES];
}

+ (ParsedExpression *)parse:(NSString *)expression usingCache:(BOOL)usingCache {
    if (usingCache) {
        __block SubExpression *cachedExpression = nil;
        dispatch_sync([self queue], ^{
            cachedExpression = [[self cache] objectForKey:expression];
        });
        if (cachedExpression) {
            return [ParsedExpression parsedExpressionWithRoot:cachedExpression];
        }
    }

    UnicodeScalarView *characters = [UnicodeScalarView scalarViewWithString:expression];
    ParsedExpression *parsedExpression = [self parse:&characters
                                      upToDelimiters:nil];
    if (usingCache) {
        dispatch_async([self queue], ^{
            [[self cache] setValue:parsedExpression.root forKey:expression];
        });
    }

    return parsedExpression;
}

+ (ParsedExpression *)parse:(UnicodeScalarView **)input
             upToDelimiters:(NSArray<NSString *> *)delimiters {
    UnicodeScalarView *unicodeScalarView = [UnicodeScalarView scalarViewWithScalarView:*input];
    UnicodeScalarView *start = [UnicodeScalarView scalarViewWithScalarView:*input];
    SubExpression *subexpression = nil;
    NSError *error = nil;
    subexpression = [unicodeScalarView parseSubExpression:delimiters error:&error];
    if (error) {
        NSString *expression =  [[start prefix:unicodeScalarView.startIndex] scalarsString];
        subexpression = [SubExpression errorWithError:(EXError *)error express:expression];
    }
    *input = [UnicodeScalarView scalarViewWithScalarView:unicodeScalarView];

    return [ParsedExpression parsedExpressionWithRoot:subexpression];
}

@end
