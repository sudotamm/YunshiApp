//
//  GouwucheTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheTableCell.h"

@interface GouwucheTableCell()

@property (nonatomic, strong) GouwucheModel *currentGM;

@end

@implementation GouwucheTableCell

@synthesize currentGM;

#pragma mark - Public methods
- (IBAction)checkButtonClicked:(id)sender
{
    self.checkButton.selected = !self.checkButton.selected;
    self.currentGM.isSelected = !self.currentGM.isSelected;
    [self.delegate didGouwucheClickedWithCell:self];
}
- (IBAction)jiaButtonClicked:(id)sender
{
    NSInteger count = [self.shuliangField.text integerValue];
    count++;
    self.shuliangField.text = [NSString stringWithFormat:@"%@",@(count)];
    if(count <=1)
    {
        self.jianButton.enabled = NO;
    }
    else
    {
        self.jianButton.enabled = YES;
    }
    //小计修改
    self.currentGM.num = self.shuliangField.text;
    [self.delegate didGouwucheClickedWithCell:self];
}
- (IBAction)jianButtonClicked:(id)sender
{
    NSInteger count = [self.shuliangField.text integerValue];
    count--;
    self.shuliangField.text = [NSString stringWithFormat:@"%@",@(count)];
    if(count <=1)
    {
        self.jianButton.enabled = NO;
    }
    else
    {
        self.jianButton.enabled = YES;
    }
    //小计修改
    self.currentGM.num = self.shuliangField.text;
    [self.delegate didGouwucheClickedWithCell:self];
}

- (void)reloadWithGouwucheModel:(GouwucheModel *)gm
{
    self.currentGM = gm;
    self.nameLabel.text = gm.gName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",gm.price];
    self.shuliangField.text = gm.num;
    [self.iconImgView aysnLoadImageWithUrl:gm.picURL placeHolder:@"loading_square"];
    self.checkButton.selected = gm.isSelected;
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
