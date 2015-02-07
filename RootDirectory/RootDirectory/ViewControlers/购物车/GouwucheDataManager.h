//
//  GouwucheDataManager.h
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

typedef NS_ENUM(NSInteger, GouwucheXiadanShangpinType) {
    kGouwucheXiadannShangpinNormal = 0,
    kGouwucheXiadannShangpinHuikui = 1
};

typedef NS_ENUM(NSInteger, PeisongFangshi)
{
    kPeisongFangshiZiti = 0,
    kPeisongFangshiYuyueziti = 1,
    kPeisongFangshiZaipei = 2
};


#import <Foundation/Foundation.h>
#import "GouwucheModel.h"
#import "ShanginHuikuiModel.h"

@interface GouwucheDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *shangpinHuikuiArray;
@property (nonatomic, strong) NSMutableArray *selctedGouwuArray;
//购物清单参数
@property (nonatomic, copy) NSString *qingdanOrderId;
@property (nonatomic, strong) NSMutableArray *qingdanArray;
@property (nonatomic, assign) NSInteger deliverFee;
@property (nonatomic, assign) NSInteger deliverThreshold;

+ (instancetype)sharedManager;

- (void)requestManehuikuiWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray;

- (void)requestSaveOrderWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray
                       fankuiArray:(NSMutableArray *)fankuiArray;
@end
