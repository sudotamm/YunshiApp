//
//  GouwucheTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheTableCell.h"

@implementation GouwucheTableCell

#pragma mark - Public methods
- (IBAction)checkButtonClicked:(id)sender
{

}
- (IBAction)jiaButtonClicked:(id)sender
{

}
- (IBAction)jianButtonClicked:(id)sender
{

}

- (void)reloadWithGouwucheModel:(GouwucheModel *)gm
{
    self.nameLabel.text = gm.gName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",gm.price];
    self.shuliangField.text = gm.num;
    [self.iconImgView aysnLoadImageWithUrl:gm.picURL placeHolder:@"loading_square"];
}

#pragma mark - UIView methods

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iconImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.iconImgView.layer.borderWidth = 1.f;
    
    self.iconImgView.cacheDir = kSmallImgCacheDir;
}
@end
