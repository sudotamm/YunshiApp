//
//  GouwucheDataManager.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheDataManager.h"

#define kManehuikuiDownlaoderKey        @"ManehuikuiDownlaoderKey"
#define kSaveOrderDownloaderKey         @"SaveOrderDownloaderKey"

@implementation GouwucheDataManager

+ (instancetype)sharedManager
{
    static GouwucheDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GouwucheDataManager alloc] init];
    });
    return manager;
}

- (void)requestManehuikuiWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray
{
    self.selctedGouwuArray = gouwuArray;
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kManehuikuiUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    NSMutableArray *list = [NSMutableArray array];
    for(GouwucheModel *gm in gouwuArray)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        [dictTemp setObject:gm.gId forKey:@"gId"];
        [dictTemp setObject:gm.gType forKey:@"gType"];
        [dictTemp setObject:gm.num forKey:@"num"];
        [list addObject:dictTemp];
    }
    [paramDict setObject:list forKey:@"list"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kManehuikuiDownlaoderKey];
}

- (void)requestSaveOrderWithUserId:(NSString *)userId
                         mendianId:(NSString *)mendianId
                        gouwuArray:(NSMutableArray *)gouwuArray
                       fankuiArray:(NSMutableArray *)fankuiArray
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kSaveOrderUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    NSMutableArray *list = [NSMutableArray array];
    //购物车选中商品列表
    for(GouwucheModel *gm in gouwuArray)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        [dictTemp setObject:gm.gId forKey:@"gId"];
        [dictTemp setObject:gm.gType forKey:@"gType"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwucheXiadannShangpinNormal)] forKey:@"valveType"];
        [dictTemp setObject:gm.num forKey:@"gNum"];
        [list addObject:dictTemp];
    }
    //满额回馈选中商品列表
    for(ShanginHuikuiModel *shm in fankuiArray)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        [dictTemp setObject:shm.gId forKey:@"gId"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwuTypeShangpin)] forKey:@"gType"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwucheXiadannShangpinHuikui)] forKey:@"valveType"];
        [dictTemp setObject:@"1" forKey:@"gNum"];
        [list addObject:dictTemp];
    }
    [paramDict setObject:list forKey:@"list"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kSaveOrderDownloaderKey];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:kManehuikuiDownlaoderKey])
    {
        //满额回馈返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            self.shangpinHuikuiArray = [NSMutableArray array];
            NSArray *array = [dict objectForKey:@"list"];
            if(array.count > 0)
            {
                //显示满额回馈页面
                [[RYHUDManager sharedManager] stoppedNetWorkActivity];
                for(NSDictionary *dictHuikui in array)
                {
                    ShanginHuikuiModel *shm = [[ShanginHuikuiModel alloc] initWithRYDict:dictHuikui];
                    shm.isSelected = NO;
                    [self.shangpinHuikuiArray addObject:shm];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kShangpinhuiKuiResponseNotification object:nil];
            }
            else
            {
                //满额回馈商品为空，跳转下单
                [self requestSaveOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                       mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                      gouwuArray:self.selctedGouwuArray
                                     fankuiArray:nil];
            }
        }
        else if([[dict objectForKey:kCodeKey] integerValue] == 0)
        {
            //无满额回馈，跳转下单
            [self requestSaveOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                   mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                  gouwuArray:self.selctedGouwuArray
                                 fankuiArray:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"满额回馈获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kSaveOrderDownloaderKey])
    {
        //保存订单返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            NSString *orderId = [dict objectForKey:@"ordered"];
            //跳转订单详情
            NSLog(@"跳转订单详情页面...%@",orderId);
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"生成订单失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

@end
