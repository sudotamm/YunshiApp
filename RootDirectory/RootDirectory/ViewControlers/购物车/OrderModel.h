//
//  OrderModel.h
//  RootDirectory
//
//  Created by ryan on 2/12/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

/*
 oId
 oDatetime
 price
 */

@interface OrderModel : RYBaseModel

@property (nonatomic, copy) NSString *oId;
@property (nonatomic, copy) NSString *oDatetime;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *pickcode;         //提货单号’;’分隔
@property (nonatomic, copy) NSString *singlePickCode;   //分拆后的提货号
@property (nonatomic, copy) NSString *payStatus;

@end
