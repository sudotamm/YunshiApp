//
//  VersionCheckManager.h
//  RootDirectory
//
//  Created by ryan on 3/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionCheckManager : NSObject

@property (nonatomic, copy) NSString *downloadURL;

+ (instancetype)sharedManager;

- (void)checkVersion;

@end
