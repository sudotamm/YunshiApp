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

typedef NS_ENUM(NSInteger, GouwucheXiadanShangpinType) {
    kGouwucheXiadannShangpinNormal = 0,
    kGouwucheXiadannShangpinHuikui = 1
};

@interface GouwucheDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *shangpinHuikuiArray;
@property (nonatomic, strong) NSMutableArray *selctedGouwuArray;

+ (instancetype)sharedManager;

- (void)requestManehuikuiWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray;

- (void)requestSaveOrderWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray
                       fankuiArray:(NSMutableArray *)fankuiArray;
@end
