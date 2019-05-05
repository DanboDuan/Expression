//
//  BenchmarkUtils.m
//  Demo
//
//  Created by bob on 2019/4/30.
//  Copyright © 2019 bob. All rights reserved.
//

#import "BenchmarkUtils.h"
#import <Expression/Symbol.h>
#import <Expression/Expression.h>
#import <Expression/EXError.h>
#import <Expression/NSArray+Expression.h>
#import "FeedModel.h"
#import "SectionModel.h"

@implementation BenchmarkUtils

+ (NSUInteger)parseRepetitions {
    return 100;
}

+ (NSUInteger)evalRepetitions {
    return 1000;
}

+ (CFTimeInterval)time:(dispatch_block_t)block {
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    block();
    return CFAbsoluteTimeGetCurrent() - start;
}

+ (CFTimeInterval)time:(void (^)(id value))block setUp:(id (^)(void))setUp {
    id value = setUp();
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    block(value);
    return CFAbsoluteTimeGetCurrent() - start;
}

+ (NSNumberFormatter *)formatter {
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSNumberFormatter new];
        formatter.groupingSeparator = @",";
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    });

    return formatter;
}

+ (NSArray *)symbols {
    static NSArray *result = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = @[];
    });

    return result;
}

+ (NSArray<SectionModel *> *)loadBenchmarkPageFeedList {
    NSMutableArray<SectionModel *> *feedList = [NSMutableArray array];

    NSMutableArray *subArray01 = [NSMutableArray array];
    [subArray01 addObject:({
        FeedModel *model = [FeedModel new];
        model.title = @"Calculator";
        model.subTitle = @"10us";
        model.subTitleColor = [UIColor greenColor];
        model;
    })];

    NSMutableArray *subArray02 = [NSMutableArray array];
    [subArray02 addObject:({
        FeedModel *model = [FeedModel new];
        model.title = @"Benchmark";
        model.subTitle = @"10ms";
        model.subTitleColor = [UIColor redColor];
        model;
    })];


    [feedList addObject:({
        SectionModel *model = [SectionModel new];
        model.title = @"Test";
        model.sectionList = @[subArray01, subArray02].flatmap(^NSArray *(id obj){
            return (NSArray *)obj;
        });
        model;
    })];


    return feedList;
}

@end
