//
//  ShangpinDetailViewController.h
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface ShangpinDetailViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet RYAsynImageView *headerImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UIButton *jianButton;
@property (nonatomic, weak) IBOutlet UIButton *jiaButton;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;
@property (nonatomic, weak) IBOutlet UITextField *shuliangField;
@property (nonatomic, weak) IBOutlet UILabel *guigeLabel;
@property (nonatomic, weak) IBOutlet UILabel *shuliangLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *taocanCollectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *taocanHeightConstraint;

@property (nonatomic, copy) NSString *shangpinId;

- (IBAction)jiaButtonClicked:(id)sender;
- (IBAction)jianButtonClicked:(id)sender;
- (IBAction)buyButtonClicked:(id)sender;
- (IBAction)tuwenButtonClicked:(id)sender;
- (IBAction)jiesuanButtonClicked:(id)sender;

@end
