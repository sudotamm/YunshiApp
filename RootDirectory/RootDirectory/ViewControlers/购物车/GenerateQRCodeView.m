//
//  GenerateQRCodeView.m
//  RootDirectory
//
//  Created by ryan on 2/15/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GenerateQRCodeView.h"

@implementation GenerateQRCodeView


#pragma mark - Public methods

- (void)reloadWithQRString:(NSString *)qrString
{
    NSArray *array = [qrString componentsSeparatedByString:@"/"];
    if(array.count == 1)
    {
        //付款二维码
        self.tip1Label.text = @"下单成功";
        self.tip2Label.text = @"凭二维码支付";
    }
    else if(array.count == 2)
    {
        //提货二维码
        self.tip1Label.text = @"购买成功";
        self.tip2Label.text = @"凭二维码提货";
    }
    else
    {
        //课程预约二维码
        self.tip1Label.text = @"预约成功";
        self.tip2Label.text = @"凭二维码上课";
    }
    UIImage *qrImage = [RYCommonMethods qrImageForString:qrString];
    self.qrImageView.image = qrImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"支付二维码已保存到相册。" customView:nil hideDelay:2.f];
    }
}

- (IBAction)baocunButtonClicked:(id)sender
{
    if(self.qrImageView.image)
    {
        UIImageWriteToSavedPhotosAlbum(self.qrImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [[RYRootBlurViewManager sharedManger] hideBlurView];
    if(self.returnHome)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayResponseSucceedNotification object:nil];
    }
}

- (IBAction)guanbiButtonClicked:(id)sender
{
    [[RYRootBlurViewManager sharedManger] hideBlurView];
    if(self.returnHome)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayResponseSucceedNotification object:nil];
    }
}

@end
