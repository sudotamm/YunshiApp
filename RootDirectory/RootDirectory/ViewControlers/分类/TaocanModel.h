//
//  TaocanModel.h
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@class GouwucheModel;
@interface TaocanModel : RYBaseModel

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *cName;
@property (nonatomic, copy) NSString *cNewPrice;
@property (nonatomic, copy) NSString *cOldPrice;

@property (nonatomic, strong) NSMutableArray *shangpinArray;

- (id)initWithGouwucheModel:(GouwucheModel *)gm;

@end
