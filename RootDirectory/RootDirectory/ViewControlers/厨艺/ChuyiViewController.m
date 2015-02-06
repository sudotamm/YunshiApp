//
//  ChuyiViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ChuyiViewController.h"
#import "KechengCell.h"
#import "KeChengDetailViewController.h"



@interface ChuyiViewController ()

@end

@implementation ChuyiViewController

@synthesize tv,picker,dateBtn,pickerView;
@synthesize trainingTime,page,trainingArray;

-(void)getTrainingList
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.phone forKey:@"userId"];
    [paramDict setObject:self.trainingTime forKey:@"trainingTime"];
    [paramDict setObject:@"0" forKey:@"isMyTraining"];
    [paramDict setObject:@"40" forKey:@"dataCount"];
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
    
    
    [self setNaviTitle:@"厨艺课程"];
    
    // 全部时间
    self.trainingTime = @"";
    self.page = @"1";
    self.trainingArray = [NSMutableArray array];
    
    
    [self getTrainingList];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)datePick:(id)sender
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitHour | kCFCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:self.picker.date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
//    NSInteger hour = [components hour];
//    NSInteger min = [components minute];
    
    
    NSString* tmpDate = [NSString stringWithFormat:@"%d-",year];
    
    if (month<10) {
        tmpDate = [NSString stringWithFormat:@"%@0%d-",tmpDate,month];
    }
    else {
        tmpDate = [NSString stringWithFormat:@"%@%d-",tmpDate,month];
    }
    
    if (day<10) {
        tmpDate = [NSString stringWithFormat:@"%@0%d",tmpDate,day];
    }
    else {
        tmpDate = [NSString stringWithFormat:@"%@%d",tmpDate,day];
    }
    
    
    [self.dateBtn setTitle:tmpDate forState:UIControlStateNormal];
    
    self.trainingTime = tmpDate;
    self.page = @"1";
    [self getTrainingList];
    
    
}

-(IBAction)dateClick:(id)sender
{
    CGRect frame = self.tv.frame;
    
    // 变选时间
    if (self.picker.hidden == YES) {
        
        self.picker.hidden = NO;
        
        frame.origin.y = self.picker.frame.origin.y + self.picker.frame.size.height;
        frame.size.height -= self.picker.frame.size.height;
        
    }
    // 变全部时间
    else {
        
        self.picker.hidden = YES;
        [self.dateBtn setTitle:@"全部时间" forState:UIControlStateNormal];
        
        frame.origin.y = self.picker.frame.origin.y;
        frame.size.height += self.picker.frame.size.height;
        
        self.trainingTime = @"";
        self.page = @"1";
        [self getTrainingList];
        
    }
    
    self.tv.frame = frame;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 先不做分页
    return [self.trainingArray count];
    
//    if (![self.page isEqualToString:@"0"]&&[self.trainingArray count]>0) {
//        return [self.trainingArray count]+1;
//    }
//    else {
//        return [self.trainingArray count];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == [self.trainingArray count]) {
//        
//        [self searchSaleShopWithShopCodeList];
//        
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tvCell"];
//        
//        cell.textLabel.text = @"更多";
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.textLabel.font = [UIFont systemFontOfSize:20];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        
//        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]
//                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [indicator startAnimating];
//        indicator.frame = CGRectMake(260, 18, 8 ,8);
//        
//        [cell addSubview:indicator];
//        
//        
//        
//        return cell;
//        
//    }
    
    
    
    KechengCell *cell = (KechengCell*)[[[NSBundle mainBundle] loadNibNamed:@"KechengCell" owner:nil options:nil] lastObject];
    
    TrainingBean* bean = (TrainingBean*)[self.trainingArray objectAtIndex:indexPath.row];
    
    cell.name.text = [NSString stringWithFormat:@"课程名: %@",bean.tName];
    cell.addr.text = [NSString stringWithFormat:@"地点: %@",bean.addr];
    cell.datetime.text = [NSString stringWithFormat:@"时间: %@",bean.tTime];
    cell.person.text = [NSString stringWithFormat:@"可预约的人数: %@",bean.personNum];
    
    
    if (![bean.status isEqualToString:@"1"]) {
        cell.sendBtn.hidden = YES;
    }
    else {
        cell.sendBtn.tag = indexPath.row;
        [cell.sendBtn addTarget:self action:@selector(yueClick:) forControlEvents:UIControlEventTouchDown];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeChengDetailViewController* vc = [[KeChengDetailViewController alloc] initWithNibName:@"KeChengDetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(IBAction)yueClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSLog(@"yue:%d",btn.tag);
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    [[RYHUDManager sharedManager] stoppedNetWorkActivity];
    
    if([downloader.purpose isEqualToString:@"课程列表"])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
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
                
                [self.tv reloadData];
            }
            
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"厨艺课程列表加载失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }

    
    
    
    
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] stoppedNetWorkActivity];
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}





@end
