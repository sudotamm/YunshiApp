//
//  AddressModel.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface AddressModel : RYBaseModel

@property (nonatomic, copy) NSString *aId;
@property (nonatomic, copy) NSString *contactor;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *rId;

@end
