//
//  FenleiDataManager.h
//  RootDirectory
//
//  Created by ryan on 1/28/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenleiDataManager : NSObject

+ (instancetype)sharedManager;

- (void)requestTest;

@end
