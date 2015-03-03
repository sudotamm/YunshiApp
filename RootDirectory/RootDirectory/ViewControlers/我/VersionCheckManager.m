//
//  VersionCheckManager.m
//  RootDirectory
//
//  Created by ryan on 3/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "VersionCheckManager.h"

@implementation VersionCheckManager

+ (instancetype)sharedManager
{
    static VersionCheckManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VersionCheckManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

- (void)checkVersion
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@"2" forKey:@"deviceType"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"checkUpdate"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:@"获取版本更新"];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:@"获取版本更新"])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            
            
            NSString* verNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"verNum"]];
//                        verNum = @"1.1";
            
//            NSRange r = [verNum rangeOfString:@"."];
            
            if (verNum.length>0) {
                NSString* currentVerNum = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                
                if (![currentVerNum isEqualToString:verNum]) {
                    
                    if ([currentVerNum floatValue]<[verNum floatValue]) {
                        
                        self.downloadURL = [NSString stringWithFormat:@"%@",[dict objectForKey:@"updateURL"]];
//                        self.downloadURL = kAppDownloadUrl;
                        //                        self.downloadURL = @"http://www.baidu.com";
                        
                        if ([self.downloadURL length]>0) {
                            
                            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"isMust"]] isEqualToString:@"1"]) {
                                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请更新至最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                av.tag = 2;
                                [av show];
                            }
                            else {
                                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更新至最新版本?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                av.tag = 3;
                                [av show];
                            }
                            
                            
                            return;
                            
                            
                        }
                        
                    }
                    
                }
            }
//            [[RYHUDManager sharedManager] showWithMessage:@"未检测到新版本" customView:nil hideDelay:2.f];
            
            
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"检测版本失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    
    
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.downloadURL]]];
    }
    else if (alertView.tag==3) {
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.downloadURL]]];
        }
    }
}


@end
