//
//  SectionModel.h
//  Demo
//
//  Created by bob on 2019/5/5.
//  Copyright © 2019 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedModel;

NS_ASSUME_NONNULL_BEGIN

@interface SectionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<FeedModel *> *sectionList;

@end

NS_ASSUME_NONNULL_END
