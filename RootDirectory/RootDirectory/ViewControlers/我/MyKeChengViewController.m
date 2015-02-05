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



@interface MyKeChengViewController ()

@end

@implementation MyKeChengViewController

@synthesize tv;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"我的课程"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.sendBtn.hidden = YES;
//    cell.sendBtn.tag = indexPath.row;
//    [cell.sendBtn addTarget:self action:@selector(yueClick:) forControlEvents:UIControlEventTouchDown];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeChengDetailViewController* vc = [[KeChengDetailViewController alloc] initWithNibName:@"KeChengDetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
