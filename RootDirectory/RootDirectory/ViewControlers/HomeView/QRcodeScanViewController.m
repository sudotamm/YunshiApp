//
//  QRcodeScanViewController.m
//  p_szuniv
//
//  Created by 朱洋 on 8/28/14.
//  Copyright (c) 2014 YuLong. All rights reserved.
//

#import "QRcodeScanViewController.h"
#import "QRcodeResultViewController.h"

@interface QRcodeScanViewController ()
{
    NSInteger num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (strong,nonatomic)NSString *qrCode;
@property (strong, nonatomic)NSString *stringValue;
@end

@implementation QRcodeScanViewController

@synthesize lineVerConstraint,topAlignConstraint;

+(QRcodeScanViewController *)shareQRcodeScanViewController
{
    return [[QRcodeScanViewController alloc] initWithNibName:@"QRcodeScanViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"实体扫购"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //二维码扫描动画效果
    self.lineVerConstraint.priority = UILayoutPriorityDefaultHigh;
    self.topAlignConstraint.priority = UILayoutPriorityDefaultLow;
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [self setupCamera];
    
}

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
}

#pragma mark - methods
-(void)animation
{
    if (upOrdown == NO) {
        num ++;
        self.lineVerConstraint.constant += 2;
        if (2*num == 240) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        self.lineVerConstraint.constant -= 2;
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera
{
    hasOutputMetadataObjects = NO;

    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    NSArray *array =  _output.availableMetadataObjectTypes;
//    NSLog(@"%d", array.count);
    if (array.count <= 0) {
        return;
    }
    //    _output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(40,112,240,240);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (hasOutputMetadataObjects)
    {
        return;
    }
    hasOutputMetadataObjects = YES;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        _stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [timer invalidate];
    
    if (_stringValue)
    {
        NSLog(@"%@", _stringValue);

        //        [[RYHUDManager sharedManager] showWithMessage:_stringValue customView:nil hideDelay:2.f];
        QRcodeResultViewController *qrvc = [[QRcodeResultViewController alloc] init];
        qrvc.resultString = _stringValue;
        qrvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrvc animated:YES];
//        [qrvc release];
    }
}
@end
