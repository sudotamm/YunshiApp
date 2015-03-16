//
//  AlixPayManager.m
//  EHome
//
//  Created by ryan on 4/24/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "AlixPayManager.h"

#define kSynAlixPayStatusDownloaderKey  @"SynAlixPayStatusDownloaderKey"

@interface AlixPayManager()

@end

@implementation AlixPayManager

#pragma mark - Singleton methods

- (id)init
{
    if(self = [super init])
    {
    }
    return self;
}

+ (AlixPayManager *)sharedManager
{
    static AlixPayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AlixPayManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - Public methods
- (void)alipayResponseWithResult:(NSString *)resultStr
{
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultStr];
    if (result)
    {
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名
             */
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                // 通知服务端，完成订单
                [self requestFinishAlixPayOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId orderId:self.payedOrderDetail.orderId];
                
                NSString * message = @"我们已经收到您的订单，将尽快处理!";
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"购买成功"
                                                                     message:message
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
            }
            //验签错误
            else
            {
                [[RYHUDManager sharedManager] showWithMessage:@"签名错误" customView:nil hideDelay:2.f];
            }
        }
        else
        {
            [[RYHUDManager sharedManager] showWithMessage:result.statusMessage customView:nil hideDelay:2.f];
        }
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:result.statusMessage customView:nil hideDelay:2.f];
    }
}

- (void)showPayResultSucceed:(BOOL)paySucceed
{
    if(paySucceed)
    {
        [self requestFinishAlixPayOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId orderId:self.payedOrderDetail.orderId];
        
        NSString * message = @"我们已经收到您的订单，将尽快处理!";
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"购买成功"
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        NSString * message = @"请稍后再试！";
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"购买失败"
                                                             message:message
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)callAlixpayToPayWithOrderDetail:(OrderDetailModel *)odm
{
    self.payedOrderDetail = odm;
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"缺少partner或者seller或者私钥。" customView:nil hideDelay:2.f];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.payedOrderDetail.orderId; //订单ID（由商家自行制定）
    order.productName = @"食理洋嘗"; //商品标题
    order.productDescription = @"谢谢光临食理洋嘗"; //商品描述
    order.amount = /*@"0.01";*/[NSString stringWithFormat:@"%.2f",[self.payedOrderDetail.price floatValue]]; //商品价格 测试时写死
    order.notifyURL =  AlipayNotifyUrl; //回调URL

    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"cecelife";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *finalResultStr = [resultDic objectForKey:@"success"];
            NSString *finalResultCode = [resultDic objectForKey:@"resultStatus"];
            if([finalResultStr rangeOfString:@"true"].length > 0 || [finalResultCode isEqualToString:@"9000"])
            {
                [self showPayResultSucceed:YES];
            }
            else
                [self showPayResultSucceed:NO];
        }];
    }
}

- (void)requestFinishAlixPayOrderWithUserId:(NSString *)userId
                                    orderId:(NSString *)orderId
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kPayedCallbackUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:orderId forKey:@"orderId"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kSynAlixPayStatusDownloaderKey];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"支付同步返回: %@",dict);
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayResponseSucceedNotification object:nil];
}

@end

