//
//  ShanginHuikuiModel.m
//  RootDirectory
//
//  Created by ryan on 2/6/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShanginHuikuiModel.h"

@implementation ShanginHuikuiModel

@synthesize peisongFangshi;

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"id"]) {
                key = @"idTemp";
            }
            if([key isEqualToString:@"newPrice"])
                key = @"gnewPrice";
            if([value isKindOfClass:[NSNumber class]])
                value = [NSString stringWithFormat:@"%@",value];
            else if([value isKindOfClass:[NSNull class]])
                value = @"";
            @try {
                [self setValue:value forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"试图添加不存在的key:%@到实例:%@中.",key,NSStringFromClass([self class]));
            }
        }
        if([[HomeDataManager sharedManger].currentDianpu.sType isEqualToString:@"0"])
        {
            peisongFangshi = kPeisongFangshiZaipei;
        }
        else
            peisongFangshi = kPeisongFangshiZiti;
    }
    return self;
}

@end
