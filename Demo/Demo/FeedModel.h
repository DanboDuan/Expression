//
//  FeedModel.h
//  Demo
//
//  Created by bob on 2019/5/5.
//  Copyright © 2019 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *actionVCName;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, strong) UIColor *subTitleColor;

@end

NS_ASSUME_NONNULL_END
