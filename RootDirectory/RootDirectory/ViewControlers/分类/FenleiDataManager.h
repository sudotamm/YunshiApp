//
//  FenleiDataManager.h
//  RootDirectory
//
//  Created by ryan on 1/28/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FenleiModel.h"

@interface FenleiDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *fenleiArray;

+ (instancetype)sharedManager;

- (void)requestFenleiListWithUserId:(NSString *)userId
                           dianpuId:(NSString *)dianpuId;

@end
