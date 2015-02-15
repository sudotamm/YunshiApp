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
}

- (IBAction)guanbiButtonClicked:(id)sender
{
    [[RYRootBlurViewManager sharedManger] hideBlurView];
}

@end
