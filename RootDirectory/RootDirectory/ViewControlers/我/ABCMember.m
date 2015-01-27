//
//  ABCMember.m
//  ACCT
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "ABCMember.h"

@implementation ABCMember

@synthesize code,msg,userId,name,phone,gender,email,addr,birthday;

#pragma mark - NSCoding methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:code forKey:@"code"];
    [aCoder encodeObject:msg forKey:@"msg"];
    [aCoder encodeObject:userId forKey:@"userId"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:gender forKey:@"gender"];
    [aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:addr forKey:@"addr"];
    [aCoder encodeObject:birthday forKey:@"birthday"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.addr = [aDecoder decodeObjectForKey:@"addr"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
    }
    return self;
}
@end
