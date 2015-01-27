//
//  QRcodeResultViewController.m
//  p_szuniv
//
//  Created by 朱洋 on 8/28/14.
//  Copyright (c) 2014 YuLong. All rights reserved.
//

#import "QRcodeResultViewController.h"

@interface QRcodeResultViewController ()

@end

@implementation QRcodeResultViewController
@synthesize resultTextView;
@synthesize resultString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"扫描结果"];
    
    self.resultTextView.text = resultString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
