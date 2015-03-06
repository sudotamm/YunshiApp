//
//  RYPhotoBrowserViewController.h
//  RYPhotoBrowser
//
//  Created by ryan on 7/30/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RYPhotoBrowserViewController : BaseViewController

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, retain) NSArray *photoArray;      //需要展示的图片
#else
@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *photoArray;      //需要展示的图片
#endif
@property (nonatomic, copy) NSString *imageCacheDir;    //图片缓存目录
@property (nonatomic, copy) NSString *placeHolder;      //图片加载占位图
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL showShare;
- (void)reloadWithPhotos:(NSArray *)array;
@end
