//
//  HomeViewController.m
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "HomeViewController.h"
#import "ServiceCell.h"
#import "DianpuChooseView.h"
#import "QRcodeScanViewController.h"

#define kListCount 4

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *serviceArray;

@end

@implementation HomeViewController

@synthesize serviceCollectionView;
@synthesize serviceArray;
@synthesize dianpuView;

#pragma mark - Properties methods
- (DianpuView *)dianpuView
{
    if(nil == dianpuView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DianpuView" owner:self options:nil];
        dianpuView = [nibs lastObject];
        [dianpuView.dianpuButton addTarget:self action:@selector(leftItemTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return dianpuView;
}

#pragma mark - Private methods
- (void)showDianpuChooseView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DianpuChooseView" owner:self options:nil];
    DianpuChooseView *dcv = [nibs lastObject];
    [dcv relaodWithDianpuArray:[HomeDataManager sharedManger].dianpuArray];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:nil contentView:dcv position:CGPointMake(10.f, 64.f)];
}

#pragma mark - IBAction methods
- (IBAction)shaogouButtonClicked:(id)sender
{
    if(![[ABCMemberDataManager sharedManager] isLogined])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
        return;
    }
    QRcodeScanViewController *qrsvc = [[QRcodeScanViewController alloc] init];
    qrsvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrsvc animated:YES];
}
- (IBAction)qianggouButtonClicked:(id)sender
{
    NSLog(@"本月抢购...");
}
- (IBAction)lilanButtonClicked:(id)sender
{
    NSLog(@"精选礼篮...");
}

#pragma mark - Notification methods
- (void)dianpuListResponseWithNotification:(NSNotification *)notification
{
    //显示店铺列表popover
    [self showDianpuChooseView];
}

#pragma mark - BaseViewController methods
- (void)leftItemTapped
{
    if([HomeDataManager sharedManger].dianpuArray.count > 0)
    {
        [self showDianpuChooseView];
    }
    else
    {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.userId forKey:@"userId"];
        [[HomeDataManager sharedManger] requestDianpuListWithDict:paramDict];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"首页"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianpuListResponseWithNotification:) name:kDianpuListResponseNotification object:nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.dianpuView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainService" ofType:@"plist"];
    self.serviceArray = [NSArray arrayWithContentsOfFile:path];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.serviceArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.serviceArray objectAtIndex:indexPath.row];
    cell.serviceIconImageView.image = [UIImage imageNamed:@"loading_square"];
    cell.serviceNameLabel.text = [dict objectForKey:@"name"];
    if((indexPath.row+1)%kListCount == 0)
        cell.verLineImageView.hidden = YES;
    else
        cell.verLineImageView.hidden = NO;
    
    if(indexPath.row < kListCount)
    {
        cell.topHonLineImageView.hidden = NO;
        cell.honLineImageView.hidden = NO;
    }
    else
    {
        cell.honLineImageView.hidden = NO;
        cell.topHonLineImageView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/4.f, collectionView.frame.size.height/2.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"跳转至分类页面...");
}
@end
