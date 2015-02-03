//
//  TaocanCollectionCell.m
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "TaocanCollectionCell.h"

@implementation TaocanCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iconImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.iconImgView.layer.borderWidth = 1.f;
    
    self.iconImgView.cacheDir = kSmallImgCacheDir;
}

- (void)reloadWithTaocan:(TaocanModel *)tm
{
    [self.iconImgView aysnLoadImageWithUrl:tm.picURL placeHolder:@"loading_square"];
    self.nameLabel.text = tm.cName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",tm.cNewPrice];
}

@end
