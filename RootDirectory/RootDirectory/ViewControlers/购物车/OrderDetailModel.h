//
//  OrderDetailModel.h
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface OrderDetailModel : RYBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *orderId;  //订单号
@property (nonatomic, copy) NSString *phone;    //会员号
@property (nonatomic, copy) NSString *name;     //收货人姓名
@property (nonatomic, copy) NSString *addr;     //收货地址
@property (nonatomic, copy) NSString *price;    //总价（包含运费）
@property (nonatomic, copy) NSString *isPay;    //已支付：1；未支付：0；其他状态：2
@property (nonatomic, copy) NSString *zptel;    //宅配联系方式

@property (nonatomic, strong) DeliverModel *yyztList;   //预约自提
@property (nonatomic, strong) DeliverModel *zpList;     //宅配
@property (nonatomic, strong) DeliverModel *xtList;     //自提

@end
