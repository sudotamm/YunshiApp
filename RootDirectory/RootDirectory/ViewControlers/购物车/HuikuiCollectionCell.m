//
//  HuikuiCollectionCell.m
//  RootDirectory
//
//  Created by ryan on 2/6/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "HuikuiCollectionCell.h"

@interface HuikuiCollectionCell()

@property (nonatomic, strong) ShanginHuikuiModel *currentSHM;

@end

@implementation HuikuiCollectionCell

@synthesize currentSHM,delegate;

#pragma mark - Public methods

- (IBAction)checkButtonClicked:(id)sender
{
//    self.checkButton.selected = !self.checkButton.selected;
//    self.currentSHM.isSelected = !self.currentSHM.isSelected;
    [self.delegate didCheckButtonClickedWithCell:self];
}

- (void)reloadWithShangpinHuikui:(ShanginHuikuiModel *)shm
{
    self.currentSHM = shm;
    self.nameLabel.text = shm.gName;
    [self.iconImgView aysnLoadImageWithUrl:shm.picURL placeHolder:@"loading_square"];
    self.checkButton.selected = shm.isSelected;
    self.yuanjiaLabel.text = [NSString stringWithFormat:@"原价：￥%@",shm.oldPrice];
    self.huikuijiaLabel.text = [NSString stringWithFormat:@"现价：￥%@",shm.gnewPrice];
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
