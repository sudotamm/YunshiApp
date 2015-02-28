//
//  HomeViewController.h
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "ImagesContainView.h"
#import "DianpuView.h"
#import "CCRYAsynImageView.h"

@interface HomeViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIImageView *headerImgView;
@property (nonatomic, weak) IBOutlet UIView *headerContainView;
@property (nonatomic, strong) ImagesContainView *imgContainView;
@property (nonatomic, weak) IBOutlet UICollectionView *serviceCollectionView;
@property (nonatomic, strong) DianpuView *dianpuView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *toutuHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *middleHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fenleiHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (nonatomic, strong) NSMutableArray *toutuArray;
@property (nonatomic, weak) IBOutlet CCRYAsynImageView *lilanImgView;
@property (nonatomic, weak) IBOutlet CCRYAsynImageView *qianggouImgView;
@property (nonatomic, weak) IBOutlet CCRYAsynImageView *cuyiImgView;

- (IBAction)shaogouButtonClicked:(id)sender;
- (IBAction)qianggouButtonClicked:(id)sender;
- (IBAction)lilanButtonClicked:(id)sender;
- (IBAction)cuyifenxiangButtonClicked:(id)sender;

@end
