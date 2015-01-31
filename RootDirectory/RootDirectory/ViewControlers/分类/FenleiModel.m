//
//  FenleiModel.m
//  RootDirectory
//
//  Created by ryan on 1/31/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiModel.h"

@implementation FenleiModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            if([key isEqualToString:@"subCategory"])
            {
                NSArray *array = [dict objectForKey:key];
                self.subCategory = [NSMutableArray array];
                for(NSDictionary *dictFenlei in array)
                {
                    FenleiModel *fm = [[FenleiModel alloc] initWithRYDict:dictFenlei];
                    [self.subCategory addObject:fm];
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
