//
//  ABCMemberDataManager.m
//  ACCT
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "ABCMemberDataManager.h"

#define kLoginDownlaoderKey         @"LoginDownlaoderKey"
#define kRegisterLoginDownlaoderKey @"RegisterLoginDownlaoderKey"
#define kRegisterDownlaoderKey      @"RegisterDownlaoderKey"
#define kVerifyCodeDownloaderKey    @"VerifyCodeDownloaderKey"
#define kResetPwdDownloaderKey      @"ResetPwdDownloaderKey"
#define kUpdateInfoDownloaderKey    @"UpdateInfoDownloaderKey"
#define kUserInfoDownloaderKey      @"UserInfoDownloaderKey"

@interface ABCMemberDataManager()

@property (nonatomic, copy) NSString *registerUserId;
@property (nonatomic, copy) NSString *registerPwd;

@end

@implementation ABCMemberDataManager

@synthesize loginMember,registerUserId,registerPwd;

#pragma mark - Singleton methods

- (id)init
{
    if(self = [super init])
    {
        //读取本地用户信息
        NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginUserDataFile];
        self.loginMember = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataFilePath];
        if(nil == loginMember)
        {
            loginMember = [[ABCMember alloc] init];
        }
    }
    return self;
}


+ (instancetype)sharedManager
{
    static ABCMemberDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ABCMemberDataManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - Public methods
- (BOOL)isLogined
{
    if(self.loginMember.userId.length > 0)
        return YES;
    else
        return NO;
}

- (void)logout
{
    self.loginMember = [[ABCMember alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutNotification object:nil];
}

- (void)saveLoginMemberData
{
    //保存登录用户信息
    NSData *memberData = [NSKeyedArchiver archivedDataWithRootObject:self.loginMember];
    NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginUserDataFile];
    [memberData writeToFile:userDataFilePath atomically:NO];
}

#pragma mark - Network methods
- (void)requestVerifyCodeWithDict:(NSMutableDictionary *)paramDict
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"验证码获取中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetVerifyCodeUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kVerifyCodeDownloaderKey];
}

- (void)requestRegisterwithDict:(NSMutableDictionary *)paramDict userId:(NSString *)userId pwd:(NSString *)pwd
{
    self.registerUserId = userId;
    self.registerPwd = pwd;
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"注册中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kRegisterUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kRegisterDownlaoderKey];
}

- (void)requestLoginWithDict:(NSMutableDictionary *)paramDict
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"登录中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kLoginUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kLoginDownlaoderKey];
}

- (void)requestUserInfoWithDict:(NSMutableDictionary *)paramDict
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kLoginUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kUserInfoDownloaderKey];
}

- (void)requestResetPasswordWithDict:(NSMutableDictionary *)paramDict
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"重置中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kResetPwdUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kResetPwdDownloaderKey];
}

- (void)requestUpdateUserInfoWithDict:(NSMutableDictionary *)paramDict
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"更新中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUpdateInfoUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kUpdateInfoDownloaderKey];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:kVerifyCodeDownloaderKey])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"验证码获取成功" customView:nil hideDelay:2.f];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kVerifyCodeResonseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"验证码获取错误";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if ([downloader.purpose isEqualToString:kRegisterDownlaoderKey])
    {
        //注册返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"注册成功！\n\n请完善会员信息，\n生日当天凭身份证\n到门店可领取生日礼品一份。" customView:nil hideDelay:4.f];
            //登录逻辑
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:self.registerUserId forKey:@"phone"];
            [paramDict setObject:self.registerPwd forKey:@"pwd"];
            NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kLoginUrl];
            [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                     postParams:paramDict
                                                                    contentType:@"application/json"
                                                                       delegate:self
                                                                        purpose:kRegisterLoginDownlaoderKey];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"注册失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kLoginDownlaoderKey])
    {
        //登录返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            NSString *password = [self.loginMember.password copy];
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            self.loginMember = [[ABCMember alloc] initWithRYDict:dict];
            self.loginMember.password = password;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"登录失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kUserInfoDownloaderKey])
    {
        //用户信息返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            NSString *password = [self.loginMember.password copy];
            self.loginMember = [[ABCMember alloc] initWithRYDict:dict];
            self.loginMember.password = password;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"用户信息获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kRegisterLoginDownlaoderKey])
    {
        //登录返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            self.loginMember = [[ABCMember alloc] initWithRYDict:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"登录失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kResetPwdDownloaderKey])
    {
        //密码重置返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"密码重置成功！\n请检查重置密码的短信" customView:nil hideDelay:2.f];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"密码重置失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kUpdateInfoDownloaderKey])
    {
        //更新个人信息返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            //更新个人信息成功
            [[RYHUDManager sharedManager] showWithMessage:@"信息更新成功" customView:nil hideDelay:2.f];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateInfoResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"更新个人信息错误";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}
@end
