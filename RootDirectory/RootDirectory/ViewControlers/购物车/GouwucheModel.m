//
//  GouwucheModel.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheModel.h"

@implementation GouwucheModel

@synthesize peisongFangshi;

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super initWithRYDict:dict])
    {
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
