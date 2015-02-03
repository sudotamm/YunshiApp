//
//  RYPhotoBrowserCell.h
//  RYPhotoBrowser
//
//  Created by ryan on 7/30/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYPhotoBrowserCell : UICollectionViewCell

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) IBOutlet UIScrollView *detailScrollView;
@property (nonatomic, retain) IBOutlet RYAsynImageView *detailImageView;
#else
@property (nonatomic, weak) IBOutlet UIScrollView *detailScrollView;
@property (nonatomic, weak) IBOutlet RYAsynImageView *detailImageView;
#endif

@end
