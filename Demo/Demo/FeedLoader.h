//
//  FeedLoader.h
//  Demo
//
//  Created by bob on 2019/5/5.
//  Copyright © 2019 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedModel;

NS_ASSUME_NONNULL_BEGIN

@interface FeedLoader : NSObject

+ (instancetype)defaultLoader;

+ (NSArray<FeedModel *> *)loadDemoPageFeedList;

+ (NSArray<FeedModel *> *)loadBenchmarkPageFeedList;

@end

NS_ASSUME_NONNULL_END
