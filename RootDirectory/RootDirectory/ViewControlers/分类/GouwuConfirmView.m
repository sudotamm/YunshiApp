//
//  GouwuConfirmView.m
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwuConfirmView.h"

@implementation GouwuConfirmView

#pragma mark - Private methods
- (void)reloadXiaoji
{
    NSInteger num = [self.shuliangField.text integerValue];
    if([FenleiDataManager sharedManager].inbasketType == kGouwuTypeShangpin)
    {
        ShangpinModel *sm = [FenleiDataManager sharedManager].gouwuModel;
        CGFloat xiaoji = [sm.price floatValue]*num;
        self.xiaojiLabel.text = [NSString stringWithFormat:@"￥%.2f",xiaoji];
    }
    else
    {
        TaocanModel *tm = [FenleiDataManager sharedManager].gouwuModel;
        CGFloat xiaoji = [tm.cNewPrice floatValue]*num;
        self.xiaojiLabel.text = [NSString stringWithFormat:@"￥%.2f",xiaoji];
    }
}

#pragma mark - Public methods
- (void)reloadData
{
    if([FenleiDataManager sharedManager].inbasketType == kGouwuTypeShangpin)
    {
        ShangpinModel *sm = [FenleiDataManager sharedManager].gouwuModel;
        self.titleLabel.text = sm.gName;
        self.danjiaLabel.text = [NSString stringWithFormat:@"￥%@",sm.price];
    }
    else
    {
        TaocanModel *tm = [FenleiDataManager sharedManager].gouwuModel;
        self.tipLabel.text = tm.cName;
        self.danjiaLabel.text = [NSString stringWithFormat:@"￥%@",tm.cNewPrice];
    }
    self.shuliangField.text = [NSString stringWithFormat:@"%@",@([FenleiDataManager sharedManager].chosenNum)];
    if([FenleiDataManager sharedManager].chosenNum > 1)
    {
        self.jianButton.enabled = YES;
    }
    else
    {
        self.jianButton.enabled = NO;
    }
    
    [self reloadXiaoji];
    if([FenleiDataManager sharedManager].inbasketNum > 0)
    {
        //购物车已有_,是否添加
        self.tipLabel.text = [NSString stringWithFormat:@"购物车已有 %@ ,是否添加",@([FenleiDataManager sharedManager].inbasketNum)];
    }
    else
    {
        self.tipLabel.text = nil;
    }
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
    [self reloadXiaoji];
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
    [self reloadXiaoji];
}
- (IBAction)querenButtonClicked:(id)sender
{
    NSInteger num = [self.shuliangField.text integerValue];
    if([FenleiDataManager sharedManager].inbasketType == kGouwuTypeShangpin)
    {
        ShangpinModel *sm = [FenleiDataManager sharedManager].gouwuModel;
        [[FenleiDataManager sharedManager] requestEditGouwucheWithGouwuId:sm.gId
                                                                gouwuType:kGouwuTypeShangpin
                                                                      num:num
                                                                 editType:kGouwuEditTypeAdd
                                                                mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                   userId:[ABCMemberDataManager sharedManager].loginMember.userId];
    }
    else
    {
        TaocanModel *tm = [FenleiDataManager sharedManager].gouwuModel;
        [[FenleiDataManager sharedManager] requestEditGouwucheWithGouwuId:tm.cId
                                                                gouwuType:kGouwuTypeTaocan
                                                                      num:num
                                                                 editType:kGouwuEditTypeAdd
                                                                mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                   userId:[ABCMemberDataManager sharedManager].loginMember.userId];
    }
}
- (IBAction)quxiaoButtonClicked:(id)sender
{
    [[RYRootBlurViewManager sharedManger] hideBlurView];
}

#pragma mark - Notification methods
- (void)editGouwucheResponseWithNotification:(NSNotification *)notification
{
    if(notification.object)
    {
        //编辑购物车失败
        [self.tipLabel addAnimationWithType:kCATransitionMoveIn subtype:kCATransitionFromBottom];
        self.tipLabel.text = notification.object;
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"编辑购物车成功" customView:nil hideDelay:2.f];
        [[RYRootBlurViewManager sharedManger] hideBlurView];
    }
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGouwucheResponseWithNotification:) name:kEditGouwucheResponseNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
