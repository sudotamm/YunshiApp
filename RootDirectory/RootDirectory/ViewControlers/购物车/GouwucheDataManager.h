//
//  GouwucheDataManager.h
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GouwucheModel.h"
#import "ShanginHuikuiModel.h"

@interface GouwucheDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *shangpinHuikuiArray;

+ (instancetype)sharedManager;

- (void)requestManehuikuiWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray;

@end
