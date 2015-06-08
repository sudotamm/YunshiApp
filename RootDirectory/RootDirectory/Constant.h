//
//  Constant.h
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/*
 RootDirectory 是Ryan创建的一个基本的项目模板，包含内容如下：
 RYUtils.framework v1.4      - Ryan定义的私人framework，使用是替换是最新版本
 AppDelegate                 - 包含了start - pannel的切换动画，后EnterBackground后的缓存处理及云备份处理
 StartViewController         - 启动view，可加载广告
 PannelViewController        - root view，管理项目中所有子模块
 ModuleViewControlers        - 所有子模块
 
 ---------------------改版--------------------------
 修改当前单模板为两种模板形式
 kIsNaviTemplate = 1 使用StartViewController - ContentNaviController(HomeViewController as root)
 标识使用root vc为UINavigationViewController
 
 kIsNaviTemplate = 0 使用StartViewController - PannelViewController
 标识使用root vc为UIViewController
 ---------------------2013-10-29--------------------
 
 使用方法：
 1. 复制一份原项目文件
 2. 替换项目名称
 3. 重新建立项目名称匹配的scheme
 4. 替换最新的RYUtils.framework, 引入framework所依赖框架
 5. 讲各子模块加入ViewControlers中
 
 注：
 dir: group对应目录下建立实际目录
 group: 项目文件下的虚拟目录结构
 
 使用过程中的group管理：
 1. ThirdLibrary: 管理项目中应用的第三方框架内容
 3. ViewControllers dir: 管理所有页面逻辑，主模块用对应sub dir实现，再次级用sub group实现
 4. Resources
 - Images dir: 管理除icon和启动图的其他所有图片资源，分类可用sub group 实现
 - Files  dir: 管理所有文件类资源，分类可用sub group实现
 
 ====================================
 添加ios7的支持
 --------------------------------------
 旧版：
 添加ios7的支持，兼容到6.0版本
 7.0 显示区域为全屏（含status bar）
 6.0 显示区域不包含statusbar
 -------------------------------------
 新版：
 - RootDirectory是基于ARC/Autolayout/Storyboard新建的一份项目模板
 - 兼容版本ios7.0及以上
 --------------------------------------
 Utilities - Ryan的常用库，可替换最新版本
 */

#ifndef RootDirectory_Constant_h
#define RootDirectory_Constant_h

/*
    0 - 标识使用root vc = PannelViewController
    1 - 标识使用root vc = CommonNaviController - HomeViewController as root
    2 - 标识使用root vc = RootTabBarViewController - CommonNaviController - HomeViewController as root
 */
#define kRootTemplateType 2

//apple api
#define kAppAppleId         @"563444753"
#define kAppRateUrl         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
#define kAppDownloadUrl     @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%&mt=8"

//Constant Values
#define kMaxCacheSize       50*1024*1024
#define IsIPad()            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsDevicePhone5      [UIScreen mainScreen].bounds.size.height==568.f?YES:NO
#define IsIos7              [[UIDevice currentDevice].systemVersion floatValue]>=7.0?YES:NO
#define IsIos8              [[UIDevice currentDevice].systemVersion floatValue]>=8.0?YES:NO
#define Is3_5Inch           [UIScreen mainScreen].bounds.size.height==480.f?YES:NO
#define Is4Inch             [UIScreen mainScreen].bounds.size.height==568.f?YES:NO
#define Is4_7Inch           [UIScreen mainScreen].bounds.size.height==667.f?YES:NO
#define Is5_5Inch           [UIScreen mainScreen].bounds.size.height==736.f?YES:NO
#define kStatusBarHeight    [UIApplication sharedApplication].statusBarFrame.size.height
#define kAPPInitialOriginY  (IsIos7)?kStatusBarHeight:0
#define kMainProjColor      [UIColor colorWithRed:60.f/255 green:176.f/255 blue:73.f/255 alpha:1.f]
#define DOCUMENTS_FOLDER    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]
#define kNetWorkErrorString @"网络错误"
#define kAllDataLoaded      @"已加载完所有数据"
#define kUIXValue           320.f           //设计图宽度基准
#define kUIYValue           568.f           //设计图高度基准
#define kUIXScaleValue      [UIScreen mainScreen].bounds.size.width/kUIXValue
#define kUIYScaleValue      ((Is3_5Inch)?568.f:[UIScreen mainScreen].bounds.size.height)/kUIYValue  //3.5inch 高度当做4inch来计算

//App Constant Values
#define kIsWelcomeShown     @"IsWelcomeShown"
#define kSuccessCode        1
#define kCodeKey            @"code"
#define kMessageKey         @"msg"
#define kLoginUserDataFile  @"LoginUserDataFile"
#define kLargeImgCacheDir   @"LargeImgCacheDir"
#define kMaxImgCacheDir     @"MaxImgCacheDir"
#define kSmallImgCacheDir   @"SmallImgCacheDir"
#define kInitPageNumber     1
#define kPageCount          20

//Notification Keys
//view notify
#define kShowPannelViewNotification         @"ShowPannelViewNotification"
#define kUserLogoutNotification             @"UserLogoutNotification"
#define kVerifyCodeResonseNotification      @"VerifyCodeResonseNotification"
#define kRegisterResponseNoitification      @"RegisterResponseNoitification"
#define kLoginResponseNotification          @"LoginResponseNotification"
#define kUserInfoResponseNotification       @"UserInfoResponseNotification"
#define kUpdateInfoResponseNotification     @"UpdateInfoResponseNotification"
#define kDianpuListResponseNotification     @"DianpuListResponseNotification"
#define kShowLoginViewNotification          @"ShowLoginViewNotification"
#define kDianpuChangeNotification           @"DianpuChangeNotification"
#define kFenleiResponseNotification         @"FenleiResponseNotification"
#define kShowFenleiViewNotification         @"ShowFenleiViewNotification"
#define kShowGouwucheViewNotification       @"ShowGouwucheViewNotification"
#define kInBasketResponseNotification       @"InBasketResponseNotification"
#define kAddGouwucheResponseNotification    @"AddGouwucheResponseNotification"
#define kRemoveGouwucheResponseNotification @"RemoveGouwucheResponseNotification"
#define kShangpinhuiKuiResponseNotification @"ShangpinhuiKuiResponseNotification"
#define kDingdanResponseNotification        @"DingdanResponseNotification"
#define kAddressListResponseNotification    @"AddressListResponseNotification"
#define kAddressRegionResponseNotification  @"AddressRegionResponseNotification"
#define kAddressEditResponseNotification    @"AddressEditResponseNotification"
#define kAddressChosenNotification          @"AddressChosenNotification"
#define kUpdateDeliverResponseNotification  @"UpdateDeliverResponseNotification"
#define kUpdateDeliverTimeoutNotification   @"UpdateDeliverTimeoutNotification"
#define kCancelOrderResponseNotification    @"CancelOrderResponseNotification"
#define kPayConfirmResponseNotification     @"PayConfirmResponseNotification"
#define kDelCollectionResponseNotification  @"DelCollectionResponseNotification"
#define kShowShareViewNotification          @"ShowShareViewNotification"
#define kShowQRGenerateViewNotification     @"ShowQRGenerateViewNotification"
#define kAliPayResponseSucceedNotification  @"AliPayResponseSucceedNotification"
#define kShijianResponseSucceedNotification @"ShijianResponseSucceedNotification"
#define kShowShouyeViewNotification         @"ShowShouyeViewNotification"
#define kAMPoiSelectedNotification          @"AMPoiSelectedNotification"

//ServerUrl
/*
 这个是正式运营的的server 大家出下个版本时换上
 平时开发时 别用！！！
 http://61.151.247.182:8009/
 */

#define kIpAddress          @"http://61.151.247.182:8009/"//@"http://180.166.75.178:8009/"
#define kServerAddress      [kIpAddress stringByAppendingString:@"api/"]
//注册登录
#define kLoginUrl           @"login"
#define kRegisterUrl        @"register"
#define kGetVerifyCodeUrl   @"getAuthCode"
#define kUpdateInfoUrl      @"updateUserInfo"
#define kResetPwdUrl        @"resetPwd"
#define kChangPwdUrl        @"changePwd"

//首页
#define kDianpuListUrl      @"shopList"
#define kBasketListUrl      @"basketList"
#define kTaocanDetailUrl    @"comboDetail"
//分类
#define kFenleiListUrl      @"goodsCategory"
#define kShangpinListUrl    @"goodsList"
#define kShangpinDetailUrl  @"goodsInfo"
#define kIsInBasketUrl      @"isInCart"
#define kEditGouwucheUrl    @"editCart"
//购物车
#define kGouwucheListUrl    @"cartList"
#define kManehuikuiUrl      @"getGift"
#define kSaveOrderUrl       @"saveOrder"
#define kUpdateDeliverUrl   @"updateDeliverType"
#define kOrderDetailUrl     @"orderDetail"
#define kPickDetailUrl      @"pickDetail"
#define kPayedCallbackUrl   @"pushPayStatus"
#define kCancelOrderUrl     @"cancelOrder"
#define kPeisongshijianUrl  @"dispatchTime"
//我
#define kAddressListUrl     @"addrList"
#define kAddressRegionUrl   @"addrRegion"
#define kAddressEditUrl     @"editAddr"
#define kOrderListUrl       @"orderList"
#define kCollectionListUrl  @"collectionList"
#define kDelCollectionUrl   @"delCollection"
#endif
