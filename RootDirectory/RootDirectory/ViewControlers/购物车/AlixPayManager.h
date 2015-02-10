//
//  AlixPayManager.h
//  EHome
//
//  Created by ryan on 4/24/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "OrderDetailModel.h"
#import "PartnerConfig.h"
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixPayResult.h"

@interface AlixPayManager : NSObject

@property (nonatomic, strong) OrderDetailModel *payedOrderDetail;

+ (AlixPayManager *)sharedManager;

- (void)callAlixpayToPayWithOrderDetail:(OrderDetailModel *)odm;

- (void)alipayResponseWithResult:(NSString *)resultStr;

- (void)requestFinishAlixPayOrderWithUserId:(NSString *)userId
                                    orderId:(NSString *)orderId;
@end
