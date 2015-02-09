//
//  OrderDetailModel.m
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            if([key isEqualToString:@"yyztList"])
            {
                NSDictionary *dictTemp = [dict objectForKey:key];
                self.yyztList = [[DeliverModel alloc] initWithRYDict:dictTemp];
                continue;
            }
            if([key isEqualToString:@"zpList"])
            {
                NSDictionary *dictTemp = [dict objectForKey:key];
                self.zpList = [[DeliverModel alloc] initWithRYDict:dictTemp];
                continue;
            }
            if([key isEqualToString:@"xtList"])
            {
                NSDictionary *dictTemp = [dict objectForKey:key];
                self.xtList = [[DeliverModel alloc] initWithRYDict:dictTemp];
                continue;
            }
            
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"id"]) {
                key = @"idTemp";
            }
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
    }
    return self;
}

@end
