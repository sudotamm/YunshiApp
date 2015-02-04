//
//  ShangpinDetailModel.h
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShangpinDetailModel : RYBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, strong) NSMutableArray *taocanArray;

@end
