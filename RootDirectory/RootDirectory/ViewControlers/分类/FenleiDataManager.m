//
//  FenleiDataManager.m
//  RootDirectory
//
//  Created by ryan on 1/28/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiDataManager.h"

#define kFenleiDownloaderKey            @"FenleiDownloaderKey"
#define kInBasketDownloaderKey          @"InBasketDownloaderKey"
#define kEditGouwucheDownlaoderKey      @"EditGouwucheDownlaoderKey"

@interface FenleiDataManager()

@end

@implementation FenleiDataManager

@synthesize gouwuModel,inbasketNum,inbasketType;

#pragma mark - Singleton methods

+ (instancetype)sharedManager
{
    static FenleiDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FenleiDataManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}
#pragma mark - Public methods
- (void)requestFenleiListWithUserId:(NSString *)userId
                           dianpuId:(NSString *)dianpuId
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kFenleiListUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:dianpuId forKey:@"sCode"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kFenleiDownloaderKey];
}

- (void)requestShangpinIsInBasketWithGouwuModel:(id)gouwu
                                      gouwuType:(GouwuType)gouwuType
                                      chosenNum:(NSInteger)chooseNum
                                      mendianId:(NSString *)mendianId
                                         userId:(NSString *)userId
{
    self.gouwuModel = gouwu;
    self.inbasketType = gouwuType;
    self.chosenNum = chooseNum;
    NSString *gouwuId = nil;
    if(gouwuType == kGouwuTypeTaocan)
    {
        TaocanModel *tm = (TaocanModel *)gouwu;
        gouwuId = tm.cId;
    }
    else
    {
        ShangpinModel *sm = (ShangpinModel *)gouwu;
        gouwuId = sm.gId;
    }
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kIsInBasketUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    [paramDict setObject:gouwuId forKey:@"gId"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kInBasketDownloaderKey];
}

- (void)requestEditGouwucheWithGouwuId:(NSString *)gouwuId
                             gouwuType:(GouwuType)gouwuType
                                   num:(NSInteger)num
                              editType:(GouwuEditType)editType
                             mendianId:(NSString *)mendianId
                                userId:(NSString *)userId
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kEditGouwucheUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    [paramDict setObject:gouwuId forKey:@"gId"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(gouwuType)] forKey:@"gType"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(num)] forKey:@"num"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(editType)] forKey:@"editType"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kEditGouwucheDownlaoderKey];
}


#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:kFenleiDownloaderKey])
    {
        //分类列表返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            self.fenleiArray = [NSMutableArray array];
            NSArray *array = [dict objectForKey:@"list"];
            for(NSDictionary *dictFenlei in array)
            {
                FenleiModel *fm = [[FenleiModel alloc] initWithRYDict:dictFenlei];
                [self.fenleiArray addObject:fm];
            }
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:kFenleiResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"分类获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kInBasketDownloaderKey])
    {
        //是否在购物车返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            NSInteger num = [[dict objectForKey:@"num"] integerValue];
            self.inbasketNum = num;
            [[NSNotificationCenter defaultCenter] postNotificationName:kInBasketResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"是否已加入购物车获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kEditGouwucheDownlaoderKey])
    {
        //编辑购物车返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditGouwucheResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"编辑购物车获取失败";
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditGouwucheResponseNotification object:message];
        }
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

@end
