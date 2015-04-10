//
//  GouwuHuikuiView.h
//  RootDirectory
//
//  Created by ryan on 2/6/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuikuiCollectionCell.h"

@interface GouwuHuikuiView : UIView<HuikuiCollectionCellDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)quedingButtonClicked:(id)sender;
- (IBAction)quxiaoButtonClicked:(id)sender;
- (void)reloadData;

@end
