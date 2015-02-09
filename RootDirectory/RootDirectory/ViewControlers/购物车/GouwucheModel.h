//
//  GouwucheModel.h
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface GouwucheModel : RYBaseModel

@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *oldPrice;
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *sCode;
@property (nonatomic, copy) NSString *gType;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, assign) PeisongFangshi peisongFangshi;
@property (nonatomic, assign) BOOL isSelected;      //购物车产品列表选中状态，默认选中

@end
