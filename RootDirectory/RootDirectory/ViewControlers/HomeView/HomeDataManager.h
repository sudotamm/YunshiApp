//
//  HomeDataManager.h
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DianpuModel.h"

@interface HomeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *dianpuArray;

+ (instancetype)sharedManger;

- (void)requestDianpuListWithDict:(NSMutableDictionary *)paramDict;

@end
