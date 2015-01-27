//
//  ImagesContainView.m
//  NOAHWM
//
//  Created by Ryan on 13-6-27.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "ImagesContainView.h"

@implementation ImagesContainView

@synthesize cycleScrollView,pageControl;
@synthesize delegate;
@synthesize bgLabelImageView,nameLabel;
@synthesize productAdArray;

#pragma mark - Public methods
- (void)reloadWithProductAds:(NSArray *)productAds
{
    self.productAdArray = productAds;
    self.pageControl.numberOfPages = productAds.count;
    self.pageControl.currentPage = 0;
    
    [self.cycleScrollView reloadWithImages:productAds placeHolder:@"loading_rectangle_square.png" cacheDir:kLargeImgCacheDir];
    if (self.pageControl.numberOfPages == 1) {
        self.cycleScrollView.scrollEnabled = NO;
    }
    else
        self.cycleScrollView.scrollEnabled = YES;
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cycleScrollView.cycleDelegate = self;
    self.cycleScrollView.delegate = self.cycleScrollView.cycleDelegate;
}

#pragma mark - RYCycleScrollViewDelegate methods
- (void)didCycleScrollViewTappedWithIndex:(NSInteger)index
{
    //根据产品imageName找到产品id
    if([self.delegate respondsToSelector:@selector(didTappedWithProductAd:)])
        [self.delegate didTappedWithProductAd:[self.productAdArray objectAtIndex:index]];
}

- (void)scrollViewDidEndDecelerating:(RYCycleScrollView *)scrollView
{

    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    if(page == 0)
    {
        [scrollView setContentOffset:CGPointMake((scrollView.cycleArray.count-2)*scrollView.frame.size.width, 0)];
        self.pageControl.currentPage = scrollView.cycleArray.count-3;
    }
    else if(page == scrollView.cycleArray.count-1)
    {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
        self.pageControl.currentPage = 0;
    }
    else
    {
        self.pageControl.currentPage = page-1;
    }
//    NYProductAd *productAd = [self.productAdArray objectAtIndex:self.pageControl.currentPage];
//    self.nameLabel.text = productAd.remark;
}


@end
