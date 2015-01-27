//
//  ImagesContainView.h
//  NOAHWM
//
//  Created by Ryan on 13-6-27.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//
//13-9-23 更新：适应ios7.0，修改了UIView 不响应setimage:的方法，详见CustomPageControl.h。neo

#import <UIKit/UIKit.h>
#import "RYCycleScrollView.h"

@protocol ImagesContainViewDelegate;

@interface ImagesContainView : UIView<RYCycleScrollViewDelegate>

@property (nonatomic, weak) IBOutlet RYCycleScrollView *cycleScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) id<ImagesContainViewDelegate> delegate;

@property (nonatomic, strong) NSArray *productAdArray;
@property (nonatomic, weak) IBOutlet UIImageView *bgLabelImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)reloadWithProductAds:(NSArray *)productAds;
@end

@protocol ImagesContainViewDelegate <NSObject>

- (void)didTappedWithProductAd:(NSString *)productAd;

@end
