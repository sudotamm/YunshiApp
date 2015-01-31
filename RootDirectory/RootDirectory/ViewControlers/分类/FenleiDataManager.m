//
//  FenleiDataManager.m
//  RootDirectory
//
//  Created by ryan on 1/28/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiDataManager.h"

#define kFenleiDownloaderKey    @"FenleiDownloaderKey"

@implementation FenleiDataManager

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
    [[RYHUDManager sharedManager] showWithMessage:@"加载中..." customView:nil hideDelay:2.f];
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

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

@end
