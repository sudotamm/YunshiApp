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

typedef NS_ENUM(NSInteger, DeliverType)
{
    kDeliverTypeZiti = 1,
    kDeliverTypeYuyueziti = 2,
    kDeliverTypeZhaipei = 3
};

typedef NS_ENUM(NSInteger, OrderType)
{
    kOrderTypeWeifukuan = 1,        //未付款
    kOrderTypeYifukuan = 2,         //已付款
    kOrderTypeLishidingdan = 3      //历史订单
};

typedef NS_ENUM(NSInteger, OrderPayType)
{
    kOrderPayTypeAlipay = 0,        //支付宝付款(默认)
    kOrderPayTypeUserpay = 1,       //收银台付款
};

typedef NS_ENUM(NSInteger, OrderCancelType)
{
    kOrderCancelTypeDelete = 1,       //删除订单
    kOrderCancelTypeCancel = 2,       //取消订单
};

#import <Foundation/Foundation.h>
#import "GouwucheModel.h"
#import "ShanginHuikuiModel.h"
#import "DingdanShangpinModel.h"
#import "DeliverModel.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"

@interface GouwucheDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *shangpinHuikuiArray;
@property (nonatomic, strong) NSMutableArray *selctedGouwuArray;
//购物清单参数
@property (nonatomic, copy) NSString *qingdanOrderId;
@property (nonatomic, strong) NSMutableArray *qingdanArray;
@property (nonatomic, assign) NSInteger deliverFee;
@property (nonatomic, assign) NSInteger deliverThreshold;
@property (nonatomic, assign) NSInteger discount;   //折扣信息
//确认支付参数
@property (nonatomic, assign) OrderPayType payType;
//预约时间
@property (nonatomic, strong) NSMutableArray *yuyueshijianArray;
//宅配时间  - 区内
@property (nonatomic, strong) NSMutableArray *quneishijianArray;
//宅配时间  - 区外
@property (nonatomic, strong) NSMutableArray *quwaishijianArray;

- (NSString *)discountStr;

+ (instancetype)sharedManager;

- (void)requestManehuikuiWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray;

- (void)requestSaveOrderWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray
                       fankuiArray:(NSMutableArray *)fankuiArray;

/*
 userId
 ordered
 yyztName
 yyztPhone
 yyztTime   yyyymmddhhmm
 zpAddrId
 zpTime     yyyymmddhhmm
 gId
 sCode
 deliverType

 */
- (void)requestUpdateDeliverInfoWithUserId:(NSString *)userId
                                   orderId:(NSString *)orderId
                                  yyztName:(NSString *)yyztName
                                     sCode:(NSString *)sCode
                                 yyztPhone:(NSString *)yyztPhone
                                  yyztTime:(NSString *)yyztTime
                                  zpAddrId:(NSString *)zpAddrId
                                    zpTime:(NSString *)zpTime
                                      list:(NSMutableArray *)list;

- (void)requestCancelOrderWithOrderId:(NSString *)orderId
                           cancelType:(OrderCancelType)cancelType;

- (void)requestPeisongshijian;
@end
