//
//  DianpuModel.h
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DianpuModel : RYBaseModel

@property (nonatomic, copy) NSString *sName;        //店铺名称
@property (nonatomic, copy) NSString *sCode;        //店铺id
@property (nonatomic, copy) NSString *sType;        //店铺类型:0-宅配中心，1-门店

@end
