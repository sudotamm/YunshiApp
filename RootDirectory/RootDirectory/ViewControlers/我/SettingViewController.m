//
//  SettingViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "SettingViewController.h"
#import "RYPhotoBrowserViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize downloadURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"设置"];
    self.contentTableView.tableFooterView = [UIView new];
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    self.contentTableView.dataSource = nil;
    self.contentTableView.delegate = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = nil;
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    if (indexPath.row==0) {
        cell.textLabel.text = @"语言";
        cell.detailTextLabel.text = @"中文";
    }
    else if (indexPath.row==1) {
        cell.textLabel.text = @"会员章程";
    }
//    else if (indexPath.row==2) {
//        cell.textLabel.text = @"获取最新版本";
//    }
    else if (indexPath.row==2) {
        cell.textLabel.text = @"关于";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"选择语言" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"中文", nil];
            [as showInView:self.view];
        }
            break;
        case 1:
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths lastObject];
            NSString *zhangDir = [documentDirectory stringByAppendingPathComponent:@"zhangchen"];
            NSFileManager *manager = [NSFileManager defaultManager];
            if(![manager fileExistsAtPath:zhangDir])
                [manager createDirectoryAtPath:zhangDir withIntermediateDirectories:NO attributes:nil error:nil];
            UIImage *cacheImg = [UIImage imageNamed:@"img_zhangchen"];
            NSString *path = [NSString stringWithFormat:@"%@/%@",zhangDir,@"img_zhangchen"];
            NSData *cacheData = UIImageJPEGRepresentation(cacheImg, 1);
            [cacheData writeToFile:path atomically:NO];
            NSMutableArray *array = [NSMutableArray arrayWithObject:path];
            RYPhotoBrowserViewController *pbvc = [[RYPhotoBrowserViewController alloc] init];
            pbvc.photoArray = array;
            pbvc.imageCacheDir = @"zhangchen";
            pbvc.placeHolder = @"loading_square";
            [self.navigationController pushViewController:pbvc animated:YES];
        }
            break;
            /*
        case 2:
        {
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@"2" forKey:@"deviceType"];
            
            [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"版本检测中..."];
            NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"checkUpdate"];
            [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                     postParams:paramDict
                                                                    contentType:@"application/json"
                                                                       delegate:self
                                                                        purpose:@"获取版本更新"];
        }
            break;
             */
        case 2:
        {
            if(tableView.tableFooterView == self.footerView)
            {
                tableView.tableFooterView = [UIView new];
            }
            else
                tableView.tableFooterView = self.footerView;
        }
            break;
            
        default:
            break;
    }
    
}

-(IBAction)logout:(id)sender
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    av.tag = 1;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==1)
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[ABCMemberDataManager sharedManager] logout];
        }
    }
    else if (alertView.tag==2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.downloadURL]]];
    }
    else if (alertView.tag==3) {
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.downloadURL]]];
        }
    }
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:@"获取版本更新"])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            
            
            NSString* verNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"verNum"]];
//            verNum = @"1.1";
            
//            NSRange r = [verNum rangeOfString:@"."];
            
            if (verNum.length>0) {
                NSString* currentVerNum = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                
                if (![currentVerNum isEqualToString:verNum]) {
                    
                    if ([currentVerNum floatValue]<[verNum floatValue]) {
                        
                        self.downloadURL = [NSString stringWithFormat:@"%@",[dict objectForKey:@"updateURL"]];
                        
//                        self.downloadURL = @"http://www.baidu.com";
                        
                        if ([self.downloadURL length]>0) {
                            
                            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"isMust"]] isEqualToString:@"1"]) {
                                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请更新至最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                av.tag = 2;
                                [av show];
                            }
                            else {
                                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更新至最新版本?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                av.tag = 3;
                                [av show];
                            }
                            
                            
                            return;
                            
                            
                        }
                        
                    }
                    
                }
            }
            [[RYHUDManager sharedManager] showWithMessage:@"未检测到新版本" customView:nil hideDelay:2.f];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"检测版本失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
  
    
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}








@end
