//
//  QRcodeResultViewController.h
//  p_szuniv
//
//  Created by 朱洋 on 8/28/14.
//  Copyright (c) 2014 YuLong. All rights reserved.
//

#import "BaseViewController.h"

@interface QRcodeResultViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (copy, nonatomic)NSString *resultString;
@end
