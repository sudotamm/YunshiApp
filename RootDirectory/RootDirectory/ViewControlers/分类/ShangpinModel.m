//
//  ShangpinModel.m
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShangpinModel.h"

@implementation ShangpinModel

- (id)initWithDetailModel:(ShangpinDetailModel *)detailModel
{
    if(self = [super init])
    {
        self.gId = detailModel.gId;
        self.gName = detailModel.gName;
        self.price = detailModel.price;
        self.spec = detailModel.spec;
        self.location = detailModel.location;
        self.picURL = detailModel.picURL;
    }
    return self;
}

@end
