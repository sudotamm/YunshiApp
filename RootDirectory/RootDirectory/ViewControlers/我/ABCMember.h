//
//  ABCMember.h
//  ACCT
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYBaseModel.h"

@interface ABCMember : RYBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *birthday;

@end
