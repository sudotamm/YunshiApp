//
//  UserInfoDataManager.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "RegionModel.h"

typedef NS_ENUM(NSInteger, AddressEditType)
{
    kAddressEditTypeAdd = 0,
    kAddressEditTypeEdit = 1,
    kAddressEditTypeDelete = 2
};

@interface UserInfoDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *regionArray;

+ (instancetype)sharedManager;

- (void)requestAddressListWithUserId:(NSString *)userId;
- (void)requestAddressRegionList;
- (void)requestEditAddressWithUserId:(NSString *)userId
                            editType:(AddressEditType)editType
                           addressId:(NSString *)addressId
                            xingming:(NSString *)xingming
                              shouji:(NSString *)shouji
                            regionId:(NSString *)regionId
                             address:(NSString *)address
                           isDefault:(NSString *)isDefault;

- (void)requestCancelCollectionWithUserId:(NSString *)userId
                                      gId:(NSString *)gId;


@end
