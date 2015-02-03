//
//  RYPhotoBrowserViewController.m
//  RYPhotoBrowser
//
//  Created by ryan on 7/30/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RYPhotoBrowserViewController.h"
#import "RYPhotoBrowserCell.h"

#define kCellReuseIdentify      @"RYPhotoBrowserCell"
#define kSceenWidth             [UIScreen mainScreen].bounds.size.width

@interface RYPhotoBrowserViewController ()

@end

@implementation RYPhotoBrowserViewController
@synthesize photoCollectionView,photoArray,imageCacheDir,placeHolder,currentIndex;

#pragma mark - Private methods
- (void)showTopBar:(BOOL)show
{
    if(show)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLightStatusBarNotification object:nil];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHideStatusBarNotification object:nil];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)oneClicked
{
    [self showTopBar:self.navigationController.navigationBarHidden];
}

- (void)doubleClicked
{
    NSArray *visibleCells = [self.photoCollectionView visibleCells];
    for(RYPhotoBrowserCell *photoCell in visibleCells)
    {
        [photoCell.detailScrollView setZoomScale:1 animated:YES];
    }
}

- (void)jumpToDefaultIndex
{
    [self.photoCollectionView setContentOffset:CGPointMake(kSceenWidth*currentIndex, 0)];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (!error)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"图片已保存到相册。" customView:nil hideDelay:2.f];
	}
}


#pragma mark - Public methods

- (void)reloadWithPhotos:(NSArray *)array
{
    self.photoArray = array;
    [self.photoCollectionView reloadData];
}

#pragma mark - BaseViewController methods

- (void)rightItemTapped
{
    //图片保存到相册功能
    NSArray *visibleCells = [self.photoCollectionView visibleCells];
    if(visibleCells.count > 0)
    {
        RYPhotoBrowserCell *cell = [visibleCells objectAtIndex:0];
        if(cell.detailImageView.image)
        {
            UIImageWriteToSavedPhotosAlbum(cell.detailImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

#pragma mark - UIViewController methods
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showTopBar:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTopBar:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(IsIos7)
        self.automaticallyAdjustsScrollViewInsets = NO;
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"RYPhotoBrowserCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentify];
    [self performSelector:@selector(jumpToDefaultIndex) withObject:nil afterDelay:0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneClicked)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
#if ! __has_feature(objc_arc)
    [tapGesture release];
#endif
    
    UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClicked)];
    doubleGesture.numberOfTapsRequired = 2;
    doubleGesture.delaysTouchesEnded = YES;
    [self.view addGestureRecognizer:doubleGesture];
#if ! __has_feature(objc_arc)
    [doubleGesture release];
#endif
    
    [tapGesture requireGestureRecognizerToFail:doubleGesture];
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [imageCacheDir release];[placeHolder release];
    [photoCollectionView release];[photoArray release];
    [super dealloc];
}
#endif

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RYPhotoBrowserCell *cell = (RYPhotoBrowserCell *)[cv dequeueReusableCellWithReuseIdentifier:kCellReuseIdentify forIndexPath:indexPath];
    NSString *imageUrl = [self.photoArray objectAtIndex:indexPath.row];
    CGRect rect = CGRectMake(0, 0, cv.frame.size.width, cv.frame.size.height);
    cell.detailImageView.frame = rect;
    cell.detailImageView.originalFrame = rect;
    cell.detailImageView.shouldResize = YES;
    cell.detailImageView.cacheDir = self.imageCacheDir;
    cell.detailScrollView.zoomScale = 1.f;
    [cell.detailImageView aysnLoadImageWithUrl:imageUrl placeHolder:self.placeHolder];
//    cell.detailScrollView.zoomScale = 1.f;
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.photoCollectionView.frame.size;
}

@end
