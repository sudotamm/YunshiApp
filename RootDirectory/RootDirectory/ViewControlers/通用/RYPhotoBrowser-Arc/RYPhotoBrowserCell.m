//
//  RYPhotoBrowserCell.m
//  RYPhotoBrowser
//
//  Created by ryan on 7/30/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RYPhotoBrowserCell.h"

@implementation RYPhotoBrowserCell

@synthesize detailImageView,detailScrollView;

#pragma mark - UIView methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.detailScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [detailImageView release];[detailScrollView release];
    [super dealloc];
}
#endif

#pragma mark - UIScrollViewDelegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.detailImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.detailImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                              scrollView.contentSize.height * 0.5 + offsetY);
}
@end
