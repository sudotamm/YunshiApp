//
//  UserInfoDataManager.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "UserInfoDataManager.h"

#define kAddressListDownloaderKey       @"AddressListDownloaderKey"
#define kAddressRegionDownloaderKey     @"AddressRegionDownloaderKey"
#define kAddressEditDownloaderKey       @"AddressEditDownloaderKey"
#define kDelCollectionDownloaderKey     @"DelCollectionDownloaderKey"

@implementation UserInfoDataManager

+ (instancetype)sharedManager
{
    static UserInfoDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserInfoDataManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

- (void)requestAddressListWithUserId:(NSString *)userId
{
//    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kAddressListUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kAddressListDownloaderKey];
}

- (void)requestAddressRegionList
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kAddressRegionUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:nil
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kAddressRegionDownloaderKey];
}

- (void)requestCancelCollectionWithUserId:(NSString *)userId
                                      gId:(NSString *)gId
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:gId forKey:@"gId"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kDelCollectionUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kDelCollectionDownloaderKey];
}

- (void)requestEditAddressWithUserId:(NSString *)userId
                            editType:(AddressEditType)editType
                           addressId:(NSString *)addressId
                            xingming:(NSString *)xingming
                              shouji:(NSString *)shouji
                            regionId:(NSString *)regionId
                             address:(NSString *)address
                           isDefault:(NSString *)isDefault
{
    /*
     userId
     editType
     addrid
     contactor
     phoneNum
     rId
     addr
     isDefault
     */
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(editType)] forKey:@"editType"];
    [paramDict setObject:addressId forKey:@"addrid"];
    [paramDict setObject:xingming forKey:@"contactor"];
    [paramDict setObject:shouji forKey:@"phoneNum"];
    [paramDict setObject:regionId forKey:@"rId"];
    [paramDict setObject:address forKey:@"addr"];
    [paramDict setObject:isDefault forKey:@"isDefault"];
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kAddressEditUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kAddressEditDownloaderKey];
}
#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    if([downloader.purpose isEqualToString:kAddressListDownloaderKey])
    {
        //地址列表返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            self.addressArray = [NSMutableArray array];
//            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            NSArray *array = [dict objectForKey:@"list"];
            for(NSDictionary *dictAddress in array)
            {
                AddressModel *am = [[AddressModel alloc] initWithRYDict:dictAddress];
                [self.addressArray addObject:am];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddressListResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"地址列表获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kAddressRegionDownloaderKey])
    {
        //区域列表返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            self.regionArray = [NSMutableArray array];
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            NSArray *array = [dict objectForKey:@"list"];
            for(NSDictionary *dictRegion in array)
            {
                RegionModel *rm = [[RegionModel alloc] initWithRYDict:dictRegion];
                [self.regionArray addObject:rm];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddressRegionResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"区域列表获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kAddressEditDownloaderKey])
    {
        //地址编辑返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddressEditResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"地址编辑失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kDelCollectionDownloaderKey])
    {
        //取消收藏返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDelCollectionResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"取消收藏失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}


@end
