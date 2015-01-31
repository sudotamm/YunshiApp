//
//  FenleiModel.h
//  RootDirectory
//
//  Created by ryan on 1/31/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface FenleiModel : RYBaseModel

@property (nonatomic, copy) NSString *cCode;
@property (nonatomic, copy) NSString *cName;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSMutableArray *subCategory;

@end
