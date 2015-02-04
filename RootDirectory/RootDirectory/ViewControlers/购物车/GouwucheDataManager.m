//
//  GouwucheDataManager.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheDataManager.h"

@implementation GouwucheDataManager

+ (instancetype)sharedManager
{
    static GouwucheDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GouwucheDataManager alloc] init];
    });
    return manager;
}

@end
