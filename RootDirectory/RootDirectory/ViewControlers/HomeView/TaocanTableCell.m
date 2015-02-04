//
//  TaocanTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "TaocanTableCell.h"

@implementation TaocanTableCell

- (IBAction)buyButtonClicked:(id)sender
{
    [self.delegate didTaocanBuyWithCell:self];
}

- (void)reloadWithTaocan:(TaocanModel *)tm
{
    self.nameLabel.text = tm.cName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",nil==tm.cNewPrice?@"":tm.cNewPrice];
    [self.iconImgView aysnLoadImageWithUrl:tm.picURL placeHolder:@"loading_square"];
    
    CGFloat youhui = tm.cOldPrice.floatValue - tm.cNewPrice.floatValue;
    self.youhuiLabel.text = [NSString stringWithFormat:@"立省：￥%.2f",youhui];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iconImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.iconImgView.layer.borderWidth = 1.f;
    
    self.iconImgView.cacheDir = kSmallImgCacheDir;
}
@end
