//
//  TaocanModel.m
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "TaocanModel.h"

@implementation TaocanModel

- (id)initWithGouwucheModel:(GouwucheModel *)gm
{
    if(self = [super init])
    {
        /*
         cId;
         picURL;
         cName;
         cNewPrice;
         cOldPrice;
         */
        self.cId = gm.gId;
        self.cName = gm.gName;
        self.picURL = gm.picURL;
        self.cNewPrice = gm.price;
        self.cOldPrice = gm.oldPrice;
    }
    return self;
}

@end
