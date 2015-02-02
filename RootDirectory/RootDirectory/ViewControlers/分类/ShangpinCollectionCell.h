//
//  ShangpinCollectionCell.h
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShangpinCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UILabel *guigeLabel;
@property (nonatomic, weak) IBOutlet UILabel *chandiLabel;

- (void)reloadWithShangpin:(ShangpinModel *)sm;

@end
