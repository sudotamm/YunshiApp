//
//  ShangpinModel.h
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

/*
 {
 "gId":"G0002",
 "gName":"牛油果 四个装",
 "price":"56.00",
 "spec":"4个",
 "location":"美国",
 "picURL":"http://www.baidu.com/aaa.png",
	},...]
 */
@class ShangpinDetailModel;
@interface ShangpinModel : RYBaseModel

@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *number;

- (id)initWithDetailModel:(ShangpinDetailModel *)detailModel;

@end
