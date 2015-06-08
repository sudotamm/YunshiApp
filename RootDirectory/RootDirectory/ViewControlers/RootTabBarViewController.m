//
//  RootTabBarViewController.m
//  EHome
//
//  Created by ryan on 4/4/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "UserViewController.h"
#import "GouwucheViewController.h"
#import "ShangpinListViewController.h"
#import "GouwuConfirmView.h"
#import "GouwuHuikuiView.h"
#import "GenerateQRCodeView.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

#pragma mark - Notification methods
- (void)showLoginViewWithNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"RootToLogin" sender:nil];
}

- (void)showFenleiViewWithNotification:(NSNotification *)notification
{
    NSInteger fenleiIndex = 1;
    if([self tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:fenleiIndex]])
        self.selectedIndex = fenleiIndex;
}

- (void)showGouwucheViewWithNotification:(NSNotification *)notification
{
    NSInteger gouwucheIndex = 3;
    if([self tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:gouwucheIndex]])
        self.selectedIndex = gouwucheIndex;
}

- (void)showShouYeViewWithNotification:(NSNotification *)notification
{
    NSInteger shouyeIndex = 0;
    if([self tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:shouyeIndex]])
        self.selectedIndex = shouyeIndex;
}

- (void)inbasketResponseWithNotification:(NSNotification *)notification
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GouwuConfirmView" owner:self options:nil];
    GouwuConfirmView *gcv = [nibs lastObject];
    [gcv reloadData];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:[UIImage imageNamed:@"bg_popover"] contentView:gcv position:CGPointZero];
}

- (void)shangpinHuikuiResponseWithNotification:(NSNotification *)notification
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GouwuHuikuiView" owner:self options:nil];
    GouwuHuikuiView *ghv = [nibs lastObject];
    [ghv reloadData];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:[UIImage imageNamed:@"bg_popover"] contentView:ghv position:CGPointZero];
}


- (void)showQRGenerateViewWithNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    BOOL returnHome = NO;
    if(dict)
    {
        returnHome = [[dict objectForKey:@"returnHome"] boolValue];
    }
    NSString *qrString = notification.object;
    if(qrString.length > 0)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GenerateQRCodeView" owner:self options:nil];
        GenerateQRCodeView *ghv = [nibs lastObject];
        ghv.returnHome = returnHome;
        [ghv reloadWithQRString:qrString];
        [[RYRootBlurViewManager sharedManger] showWithBlurImage:[UIImage imageNamed:@"bg_popover"] contentView:ghv position:CGPointZero];
    }
}

- (void)userLogoutWithNotification:(NSNotification *)notification
{
    NSInteger shouyeIndex = 0;
    if([self tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:shouyeIndex]])
        self.selectedIndex = shouyeIndex;
}

- (void)showShareViewWithNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *content = [dict objectForKey:@"content"];
    UIImage *image = [dict objectForKey:@"image"];
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, nil];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:image quality:0.6]
                                                title:@"ShareSDK"
                                                  url:@""
                                          description:content
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [[RYHUDManager sharedManager] showWithMessage:@"分享成功" customView:nil hideDelay:2.f];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [[RYHUDManager sharedManager] showWithMessage:@"分享失败" customView:nil hideDelay:2.f];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    if(IsIos7)
    {
        //iOS7中使用系统tintColor和barTintColor属性
        self.tabBar.tintColor = kMainProjColor;
    }
    
    //设置默认TabBarItem文字为白色
    NSDictionary *normalState = @{
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSStrikethroughColorAttributeName: [UIColor whiteColor]
                                  };
    [[UITabBarItem appearance] setTitleTextAttributes:normalState forState:UIControlStateNormal];
    //设置默认TabBarItem图片为白色
    for(UITabBarItem *barItem in self.tabBar.items)
    {
        barItem.image = [barItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //设置TabBarItem选中状态为白色
    self.tabBar.tintColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewWithNotification:) name:kShowLoginViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFenleiViewWithNotification:) name:kShowFenleiViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGouwucheViewWithNotification:) name:kShowGouwucheViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inbasketResponseWithNotification:) name:kInBasketResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shangpinHuikuiResponseWithNotification:) name:kShangpinhuiKuiResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutWithNotification:) name:kUserLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShareViewWithNotification:) name:kShowShareViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQRGenerateViewWithNotification:) name:kShowQRGenerateViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShouYeViewWithNotification:) name:kAliPayResponseSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShouYeViewWithNotification:) name:kShowShouyeViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShouYeViewWithNotification:) name:kLoginResponseNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *naviController = (UINavigationController *)viewController;
        id vc = [naviController topViewController];
        if([vc isKindOfClass:[UserViewController class]])
        {
            //点击“我”tab
            if(![[ABCMemberDataManager sharedManager] isLogined])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
                return NO;
            }
            return YES;
        }
        else if([vc isKindOfClass:[GouwucheViewController class]])
        {
            //点击“购物车”tab
            if(![[ABCMemberDataManager sharedManager] isLogined])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
                return NO;
            }
            return YES;
        }
        else if([vc isKindOfClass:[ShangpinListViewController class]])
        {
            ShangpinListViewController *slvc = (ShangpinListViewController *)vc;
            slvc.listType = kListSearch;
        }
    }
    return YES;
}
@end
