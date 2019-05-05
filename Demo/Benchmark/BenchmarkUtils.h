//
//  BenchmarkUtils.h
//  Demo
//
//  Created by bob on 2019/4/30.
//  Copyright © 2019 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface BenchmarkUtils : NSObject

+ (NSUInteger)parseRepetitions;

+ (NSUInteger)evalRepetitions;

+ (CFTimeInterval)time:(dispatch_block_t)block;

+ (CFTimeInterval)time:(void (^)(id value))block setUp:(id (^)(void))setUp;

+ (NSNumberFormatter *)formatter;




+ (NSArray<SectionModel *> *)loadBenchmarkPageFeedList;

@end

NS_ASSUME_NONNULL_END
