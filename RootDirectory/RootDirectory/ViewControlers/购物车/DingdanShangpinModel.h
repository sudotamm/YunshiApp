//
//  DingdanShangpinModel.h
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface DingdanShangpinModel : RYBaseModel

@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *totalprice;
@property (nonatomic, copy) NSString *valveType;        //满购标志0-普通商品 1-满购商品

@end
