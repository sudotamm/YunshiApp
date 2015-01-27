//
//  DianpuChooseView.h
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DianpuChooseView : UIView

@property (nonatomic, weak) IBOutlet UITableView *dianpuTableView;
@property (nonatomic, strong) NSArray *dianpuArray;

- (void)relaodWithDianpuArray:(NSArray *)array;

@end
