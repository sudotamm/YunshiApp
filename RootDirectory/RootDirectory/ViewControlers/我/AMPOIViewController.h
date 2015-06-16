//
//  AMPOIViewController.h
//  RootDirectory
//
//  Created by YuanRyan on 6/8/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <CoreLocation/CoreLocation.h>

@interface AMPOIViewController : BaseViewController<AMapSearchDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) AMapSearchAPI *amSearch;
@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, strong) NSMutableArray *poiArray;
@property (nonatomic, assign) BOOL poiSelected;
@end
