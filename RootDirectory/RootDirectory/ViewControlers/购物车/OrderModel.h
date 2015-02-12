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

@end
