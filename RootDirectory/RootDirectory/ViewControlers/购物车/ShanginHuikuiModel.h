//
//  ShanginHuikuiModel.h
//  RootDirectory
//
//  Created by ryan on 2/6/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface ShanginHuikuiModel : RYBaseModel

@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *oldPrice;
@property (nonatomic, copy) NSString *gnewPrice;

@property (nonatomic, assign) BOOL isSelected;      //回馈商品产品列表选中状态，默认没选中

@end
