//
//  GouwucheDataManager.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheDataManager.h"

#define kManehuikuiDownlaoderKey        @"ManehuikuiDownlaoderKey"

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

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:kManehuikuiDownlaoderKey])
    {
        //满额回馈返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            self.shangpinHuikuiArray = [NSMutableArray array];
            NSArray *array = [dict objectForKey:@"list"];
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
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"满额回馈获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

@end
