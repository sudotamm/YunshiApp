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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setNaviTitle:@"厨艺课程"];
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
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    
    
    NSString* tmpDate = [NSString stringWithFormat:@"%d-",year];
    
    if (month<10) {
        tmpDate = [NSString stringWithFormat:@"%@0%d-",tmpDate,month];
    }
    else {
        tmpDate = [NSString stringWithFormat:@"%@%d-",tmpDate,month];
    }
    
    if (day<10) {
        tmpDate = [NSString stringWithFormat:@"%@0%d ",tmpDate,day];
    }
    else {
        tmpDate = [NSString stringWithFormat:@"%@%d ",tmpDate,day];
    }
    
    [self.dateBtn setTitle:tmpDate forState:UIControlStateNormal];
    
    NSLog(@"tmpDate = %@",tmpDate);
    
    
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
        
    }
    
    self.tv.frame = frame;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KechengCell *cell = (KechengCell*)[[[NSBundle mainBundle] loadNibNamed:@"KechengCell" owner:nil options:nil] lastObject];
    
    cell.name.text = [NSString stringWithFormat:@"课程名: %@",@"黑芝麻糊软面包"];
    cell.addr.text = [NSString stringWithFormat:@"地点: %@",@"环球港店"];
    cell.datetime.text = [NSString stringWithFormat:@"时间: %@",@"周一 13:00"];
    cell.person.text = [NSString stringWithFormat:@"可预约的人数: %@",@"2"];
    cell.sendBtn.tag = indexPath.row;
    [cell.sendBtn addTarget:self action:@selector(yueClick:) forControlEvents:UIControlEventTouchDown];
    
    
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





@end
