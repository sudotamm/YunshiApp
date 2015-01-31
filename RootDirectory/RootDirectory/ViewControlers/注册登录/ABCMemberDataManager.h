//
//  ABCMemberDataManager.h
//  ACCT
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCMember.h"

@interface ABCMemberDataManager : NSObject

@property (nonatomic, strong) ABCMember *loginMember;

+ (instancetype)sharedManager;

//本地方法
- (void)saveLoginMemberData;
- (void)logout;
- (BOOL)isLogined;
//服务器请求方法
- (void)requestVerifyCodeWithDict:(NSMutableDictionary *)paramDict;
- (void)requestRegisterwithDict:(NSMutableDictionary *)paramDict userId:(NSString *)userId;
- (void)requestLoginWithDict:(NSMutableDictionary *)paramDict;
- (void)requestResetPasswordWithDict:(NSMutableDictionary *)paramDict;
- (void)requestUpdateUserInfoWithDict:(NSMutableDictionary *)paramDict;
@end
