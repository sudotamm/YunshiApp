//
//  PayConfirmView.m
//  RootDirectory
//
//  Created by ryan on 2/10/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "PayConfirmView.h"

@implementation PayConfirmView

- (IBAction)alipayButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.alipayButton.enabled = YES;
    self.userpayButton.enabled = YES;
    btn.enabled = NO;
}

- (IBAction)userpayButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.alipayButton.enabled = YES;
    self.userpayButton.enabled = YES;
    btn.enabled = NO;
}

- (IBAction)querenButtonClicked:(id)sender
{
    if(self.alipayButton.enabled == NO)
        [GouwucheDataManager sharedManager].payType = kOrderPayTypeAlipay;
    else
        [GouwucheDataManager sharedManager].payType = kOrderPayTypeUserpay;
    [[RYRootBlurViewManager sharedManger] hideBlurView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPayConfirmResponseNotification object:nil];
}

- (void)reloadWithOrderPayType:(OrderPayType)payType
{
    if(payType == kOrderPayTypeUserpay)
    {
        self.alipayButton.enabled = YES;
        self.userpayButton.enabled = NO;
    }
    else
    {
        self.alipayButton.enabled = NO;
        self.userpayButton.enabled =YES;
    }
}
@end
