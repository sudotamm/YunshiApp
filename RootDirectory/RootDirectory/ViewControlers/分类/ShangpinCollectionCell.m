//
//  ShangpinCollectionCell.m
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShangpinCollectionCell.h"

@implementation ShangpinCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.iconImgView.cacheDir = kSmallImgCacheDir;
}

- (void)reloadWithShangpin:(ShangpinModel *)sm
{
    self.nameLabel.text = sm.gName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",nil==sm.price?@"":sm.price];
    self.guigeLabel.text = [NSString stringWithFormat:@"/%@",nil==sm.spec?@"":sm.spec];
    self.chandiLabel.text = [NSString stringWithFormat:@"产地：%@",nil==sm.location?@"":sm.location];
    [self.iconImgView aysnLoadImageWithUrl:sm.picURL placeHolder:@"loading_square"];
}

@end
