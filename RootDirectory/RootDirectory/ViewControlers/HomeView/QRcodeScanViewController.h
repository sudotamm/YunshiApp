//
//  QRcodeScanViewController.h
//  p_szuniv
//
//  Created by 朱洋 on 8/28/14.
//  Copyright (c) 2014 YuLong. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRcodeScanViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL hasOutputMetadataObjects;//captureOutput:didOutputMetadataObjects:fromConnection: 在iPad中会多次触发，导致多次处理。这里判断一下。
}
+(QRcodeScanViewController*)shareQRcodeScanViewController;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topAlignConstraint;
@end

