//
//  PayConfirmViewController.m
//  RootDirectory
//
//  Created by ryan on 2/10/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "PayConfirmViewController.h"

@interface PayConfirmViewController ()

@end

@implementation PayConfirmViewController

#pragma mark - Public methods
- (IBAction)querenfukuanButtonClicked:(id)sender
{
    if([GouwucheDataManager sharedManager].payType == kOrderPayTypeAlipay)
    {
        [[AlixPayManager sharedManager] callAlixpayToPayWithOrderDetail:self.orderDetail];
    }
    else
    {
        //生成付款二维码
        NSString *qrString = [NSString stringWithFormat:@"A%@",self.orderDetail.orderId];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowQRGenerateViewNotification object:qrString];
    }
}

#pragma mark - Notification methods
- (void)alipayResponseSucceedWithNotification:(NSNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"支付订单"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResponseSucceedWithNotification:) name:kAliPayResponseSucceedNotification object:nil];
    NSInteger num = self.orderDetail.xtList.gouwucheArray.count+self.orderDetail.yyztList.gouwucheArray.count+self.orderDetail.zpList.gouwucheArray.count;
    self.shuliangLabel.text = [NSString stringWithFormat:@"共%@件",@(num)];
    self.zongjiaLabel.text = [NSString stringWithFormat:@"总价：￥%@",self.orderDetail.price];
    
    if([GouwucheDataManager sharedManager].payType == kOrderPayTypeUserpay)
    {
        self.alipayHeightConstraint.constant = 0;
    }
    else
    {
        self.userpayHeightConstraint.constant = 0;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
