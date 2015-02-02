//
//  ShangpinTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShangpinTableCell.h"

@implementation ShangpinTableCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iconImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.iconImgView.layer.borderWidth = 1.f;
    
    self.iconImgView.cacheDir = kSmallImgCacheDir;
}

- (void)reloadWithShangpin:(ShangpinModel *)sm
{
    self.nameLabel.text = sm.gName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",nil==sm.price?@"":sm.price];
    self.guigeLabel.text = [NSString stringWithFormat:@"规格：%@",nil==sm.spec?@"":sm.spec];
    self.chandiLabel.text = [NSString stringWithFormat:@"产地：%@",nil==sm.location?@"":sm.location];
    [self.iconImgView aysnLoadImageWithUrl:sm.picURL placeHolder:@"loading_square"];
}

- (IBAction)buyButtonClicked:(id)sender
{
    [self.delegate didShangpinBuyWithCell:self];
}

@end
