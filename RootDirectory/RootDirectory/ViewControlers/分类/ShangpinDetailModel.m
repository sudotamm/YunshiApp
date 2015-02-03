//
//  ShangpinDetailModel.m
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShangpinDetailModel.h"

@implementation ShangpinDetailModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            if([key isEqualToString:@"list"])
            {
                NSArray *array = [dict objectForKey:key];
                self.taocanArray = [NSMutableArray array];
                for(NSDictionary *taocanDict in array)
                {
                    TaocanModel *tm = [[TaocanModel alloc] initWithRYDict:taocanDict];
                    [self.taocanArray addObject:tm];
                }
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
