//
//  MyKeChengViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "MyKeChengViewController.h"
#import "KechengCell.h"
#import "KeChengDetailViewController.h"
#import "TrainingBean.h"


@interface MyKeChengViewController ()

@end

@implementation MyKeChengViewController

@synthesize tv;
@synthesize page,trainingArray;
@synthesize segment;



-(void)getTrainingList
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.phone forKey:@"userId"];
    [paramDict setObject:@"" forKey:@"trainingTime"];
    [paramDict setObject:@"1" forKey:@"isMyTraining"];
    
    if (isHistory==YES) {
        [paramDict setObject:@"1" forKey:@"isHistory"];
    }
    else {
        if (isHistory==YES) {
            [paramDict setObject:@"0" forKey:@"isHistory"];
        }
    }
    
    [paramDict setObject:@"100" forKey:@"dataCount"];
    [paramDict setObject:self.page forKey:@"page"];
    
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载课程列表中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"trainingList"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:@"课程列表"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"我的课程"];
    
    isHistory = YES;
    
    self.trainingArray = [NSMutableArray array];
    self.page = @"1";
    
    [self getTrainingList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 先不做分页
    return [self.trainingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KechengCell *cell = (KechengCell*)[[[NSBundle mainBundle] loadNibNamed:@"KechengCell" owner:nil options:nil] lastObject];
    
    TrainingBean* bean = (TrainingBean*)[self.trainingArray objectAtIndex:indexPath.row];
    
    cell.name.text = [NSString stringWithFormat:@"课程名: %@",bean.tName];
    cell.addr.text = [NSString stringWithFormat:@"地点: %@",bean.addr];
    cell.datetime.text = [NSString stringWithFormat:@"时间: %@",bean.tTime];
    
    if (isHistory == YES) {
        cell.person.hidden = YES;
        cell.greyBtn.hidden = YES;
        cell.sendBtn.hidden = YES;
    }
    else {
        cell.person.text = [NSString stringWithFormat:@"可预约的人数: %@",bean.personNum];
        
        if (![bean.status isEqualToString:@"1"]) {
            cell.sendBtn.hidden = YES;
        }
        else {
            
            if ([bean.isApply isEqualToString:@"1"]) {
                cell.sendBtn.hidden = YES;
                
                [cell.greyBtn setTitle:@"取消报名" forState:UIControlStateNormal];
                
                [cell.greyBtn addTarget:self action:@selector(cancelTraining:) forControlEvents:UIControlEventTouchDown];
                
            }
            else {
                cell.sendBtn.tag = indexPath.row;
                [cell.sendBtn addTarget:self action:@selector(cancelTraining:) forControlEvents:UIControlEventTouchDown];
            }
        }
    }
    
    RYAsynImageView* iconImgView = [[RYAsynImageView alloc] init];
    [cell.contentView addSubview:iconImgView];
    iconImgView.frame = CGRectMake(20, 20, 100, 100);
    iconImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    iconImgView.layer.borderWidth = 1.f;
    iconImgView.cacheDir = kSmallImgCacheDir;
    [iconImgView aysnLoadImageWithUrl:bean.picURL placeHolder:@"loading_square"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeChengDetailViewController* vc = [[KeChengDetailViewController alloc] initWithNibName:@"KeChengDetailViewController" bundle:nil];
    vc.bean = (TrainingBean*)[self.trainingArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}



-(IBAction)cancelTraining:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    //    TrainingBean* bean = (TrainingBean*)[self.trainingArray objectAtIndex:btn.tag];
    
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要取消该课程吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    av.tag = btn.tag;
    [av show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        TrainingBean* bean = (TrainingBean*)[self.trainingArray objectAtIndex:alertView.tag];
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.phone forKey:@"userId"];
        [paramDict setObject:bean.tId forKey:@"tId"];
        
        [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"取消申请中..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"cancelTraining"];
        [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:paramDict
                                                                contentType:@"application/json"
                                                                   delegate:self
                                                                    purpose:@"取消课程"];
    }
}


#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if([downloader.purpose isEqualToString:@"课程列表"])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            
            if ([self.page isEqualToString:@"1"]) {
                [self.trainingArray removeAllObjects];
            }
            
            self.page = [NSString stringWithFormat:@"%@",[dict objectForKey:@"page"]];
            
            NSArray* arr = (NSArray*)[dict objectForKey:@"list"];
            
            if (arr!=nil&&[arr count]>0) {
                
                for (NSInteger i=0; i<[arr count]; i++) {
                    
                    NSDictionary* d = (NSDictionary*)[arr objectAtIndex:i];
                    TrainingBean* bean = [[TrainingBean alloc] initWithRYDict:d];
                    [self.trainingArray addObject:bean];
                    
                }
                
                
            }
            [self.tv reloadData];
            
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"厨艺课程列表加载失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:@"取消课程"]) {
        
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"取消成功" customView:nil hideDelay:2.f];
            
            self.page = @"1";
            [self getTrainingList];
            
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"取消请求失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
        
    }
    
    
    
    
    
    
    
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

-(IBAction)searchSwith:(id)sender
{
    
    if (self.segment.selectedSegmentIndex == 0) {
        isHistory = YES;
    }
    else {
        isHistory = NO;
    }
    
    self.page = @"1";
    
    [self getTrainingList];
}




@end
