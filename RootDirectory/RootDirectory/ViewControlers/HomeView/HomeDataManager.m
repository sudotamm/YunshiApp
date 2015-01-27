//
//  HomeDataManager.m
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "HomeDataManager.h"

#define kDianpuDownlaoderKey        @"DianpuDownlaoderKey"

@implementation HomeDataManager

@synthesize dianpuArray;

#pragma mark - Singleton methods

+ (instancetype)sharedManger
{
    static HomeDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HomeDataManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - Public methods

- (void)requestDianpuListWithDict:(NSMutableDictionary *)paramDict
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kDianpuListUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kDianpuDownlaoderKey];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:kDianpuDownlaoderKey])
    {
        //获取店铺列表返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            self.dianpuArray = [NSMutableArray array];
            NSArray *array = [dict objectForKey:@"list"];
            for(NSDictionary *dictDianpu in array)
            {
                DianpuModel *dm = [[DianpuModel alloc] initWithRYDict:dictDianpu];
                [self.dianpuArray addObject:dm];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kDianpuListResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"店铺列表获取错误";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}
@end
