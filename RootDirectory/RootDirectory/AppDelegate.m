//
//  AppDelegate.m
//  LeftMenuArcRoot
//
//  Created by ryan on 12/11/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize startViewController,pannelViewController,contentNaviController,rootTabBarViewController;

#pragma mark - Instance methods

- (StartViewController *)startViewController
{
    if(nil == startViewController)
    {
        startViewController = [[StartViewController alloc] init];
    }
    return startViewController;
}

- (PannelViewController *)pannelViewController
{
    if(nil == pannelViewController)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        pannelViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PannelViewController"];
    }
    return pannelViewController;
}

- (CommonNaviController *)contentNaviController
{
    if(nil == contentNaviController)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        contentNaviController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CommonNaviController"];
    }
    return contentNaviController;
}

- (RootTabBarViewController *)rootTabBarViewController
{
    if(nil == rootTabBarViewController)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        rootTabBarViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"RootTabBarViewController"];
    }
    return rootTabBarViewController;
}

- (void)showPannelViewWithNotification:(NSNotification *)notification
{
    [self.window addAnimationWithType:kCATransitionFade subtype:nil];
    if(kRootTemplateType == 0)
        self.window.rootViewController = self.pannelViewController;
    else if(kRootTemplateType == 1)
        self.window.rootViewController = self.contentNaviController;
    else
        self.window.rootViewController = self.rootTabBarViewController;
}

- (void)registerShareSDK
{
    //配置shareSDK
    [ShareSDK registerApp:@"4a88b2fb067c"];
    [ShareSDK ssoEnabled:YES];
    /**
     1
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx60b8897f9ce5c592"                  //TODO 此为ShareSDK的
                           appSecret:@"e826c005947d14ec72256bc7f607ee31"
                           wechatCls:[WXApi class]];
    

    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPannelViewWithNotification:) name:kShowPannelViewNotification object:nil];
    [self registerShareSDK];
    self.window.tintColor = kMainProjColor;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [RYAppBackgroundConfiger clearAllCachesWhenBiggerThanSize:kMaxCacheSize];
    [RYAppBackgroundConfiger preventFilesFromBeingBackedupToiCloudWithSystemVersion:[[UIDevice currentDevice] systemVersion]];
    
    [[ABCMemberDataManager sharedManager] saveLoginMemberData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"])
    {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             NSString *resultStr = resultDic[@"result"];
                                             [[AlixPayManager sharedManager] alipayResponseWithResult:resultStr];
                                         }];
        return YES;
    }
    else
    {
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
}

@end
