//
//  GouwuQingdanTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwuQingdanTableCell.h"

@interface GouwuQingdanTableCell()

@property (nonatomic, strong) id qingdanModel;

@end

@implementation GouwuQingdanTableCell

@synthesize qingdanModel;

- (void)changePeisongfangshi:(PeisongFangshi)fangshi btn:(UIButton *)btn
{
    if([self.qingdanModel isKindOfClass:[GouwucheModel class]])
    {
        GouwucheModel *gm = (GouwucheModel *)self.qingdanModel;
        gm.peisongFangshi = fangshi;
    }
    else
    {
        ShanginHuikuiModel *shm = (ShanginHuikuiModel *)self.qingdanModel;
        shm.peisongFangshi = fangshi;
    }
    self.zitiButton.enabled = YES;
    self.yuyuezitiButton.enabled = YES;
    self.zaipeiButton.enabled = YES;
    btn.enabled = NO;
}

- (IBAction)zitiButtonClicked:(id)sender
{
    [self changePeisongfangshi:kPeisongFangshiZiti btn:self.zitiButton];
}

- (IBAction)yuyuezitiButtonClicked:(id)sender
{
    [self changePeisongfangshi:kPeisongFangshiYuyueziti btn:self.yuyuezitiButton];
}

- (IBAction)zaipeiButtonClicked:(id)sender
{
    [self changePeisongfangshi:kPeisongFangshiZaipei btn:self.zaipeiButton];
}

- (void)reloadWithGouwuQingdanModel:(id)gouwuQingdanModel
{
    self.qingdanModel = gouwuQingdanModel;
    PeisongFangshi peisong;
    if([gouwuQingdanModel isKindOfClass:[GouwucheModel class]])
    {
        GouwucheModel *gm = (GouwucheModel *)gouwuQingdanModel;
        self.nameLabel.text = gm.gName;
        self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",gm.price];
        self.shuliangField.text = [NSString stringWithFormat:@"%@",gm.num];
        [self.iconImgView aysnLoadImageWithUrl:gm.picURL placeHolder:@"loading_square"];
        peisong = gm.peisongFangshi;
    }
    else if([gouwuQingdanModel isKindOfClass:[ShanginHuikuiModel class]])
    {
        ShanginHuikuiModel *shm = (ShanginHuikuiModel *)gouwuQingdanModel;
        self.nameLabel.text = shm.gName;
        self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",shm.gnewPrice];
        self.shuliangField.text = @"1";
        [self.iconImgView aysnLoadImageWithUrl:shm.picURL placeHolder:@"loading_square"];
        peisong = shm.peisongFangshi;
    }
    if(peisong == kPeisongFangshiZiti)
    {
        self.zitiButton.enabled = NO;
        self.yuyuezitiButton.enabled = YES;
        self.zaipeiButton.enabled = YES;
    }
    else if(peisong == kPeisongFangshiYuyueziti)
    {
        self.yuyuezitiButton.enabled = NO;
        self.zitiButton.enabled = YES;
        self.zaipeiButton.enabled = YES;
    }
    else
    {
        self.zaipeiButton.enabled = NO;
        self.zitiButton.enabled = YES;
        self.yuyuezitiButton.enabled = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iconImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.iconImgView.layer.borderWidth = 1.f;
    self.iconImgView.cacheDir = kSmallImgCacheDir;
}

@end
