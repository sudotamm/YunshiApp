//
//  DeliverModel.h
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface DeliverModel : RYBaseModel

@property (nonatomic, copy) NSString *sName;
@property (nonatomic, copy) NSString *pickTime;
@property (nonatomic, strong) NSMutableArray *gouwucheArray;

@end
