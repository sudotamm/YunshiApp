//
//  TaocanCollectionCell.h
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaocanCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;

- (void)reloadWithTaocan:(TaocanModel *)tm;
@end
