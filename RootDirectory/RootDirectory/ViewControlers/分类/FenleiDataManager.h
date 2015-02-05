//
//  FenleiDataManager.h
//  RootDirectory
//
//  Created by ryan on 1/28/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FenleiModel.h"
#import "ShangpinModel.h"
#import "ShangpinDetailModel.h"
#import "TaocanModel.h"

typedef NS_ENUM (NSInteger, GouwuType)
{
    kGouwuTypeShangpin = 1,     //1: 商品
    kGouwuTypeTaocan = 2        //2: 套餐
};

typedef NS_ENUM (NSInteger, GouwuEditType)
{
    kGouwuEditTypeAdd = 1,      //1: 加入购物车
    kGouwuEditTypeRemove = 2    //2: 从购物车删除
};

@interface FenleiDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *fenleiArray;
@property (nonatomic, strong) NSNumber *redirectFenlei;
//判断加入购物车的数据缓存
@property (nonatomic, strong) id gouwuModel;
@property (nonatomic, assign) GouwuType inbasketType;
@property (nonatomic, assign) NSInteger inbasketNum;
@property (nonatomic, assign) NSInteger chosenNum;
@property (nonatomic, assign) BOOL hasEditedGouwuche;       //判断是否有成功添加过商品到购物车中 - “去结算”按钮是否可以跳转

+ (instancetype)sharedManager;

- (void)requestFenleiListWithUserId:(NSString *)userId
                           dianpuId:(NSString *)dianpuId;

- (void)requestShangpinIsInBasketWithGouwuModel:(id)gouwu
                                      gouwuType:(GouwuType)gouwuType
                                      chosenNum:(NSInteger)chooseNum
                                      mendianId:(NSString *)mendianId
                                         userId:(NSString *)userId;

- (void)requestEditGouwucheWithGouwuId:(NSString *)gouwuId
                             gouwuType:(GouwuType)gouwuType
                                   num:(NSInteger)num
                              editType:(GouwuEditType)editType
                             mendianId:(NSString *)mendianId
                                userId:(NSString *)userId;

@end
