//
//  FenleiDataManager.m
//  RootDirectory
//
//  Created by ryan on 1/28/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiDataManager.h"

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
- (void)requestTest
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kFenleiListUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:nil
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dict);
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

@end
