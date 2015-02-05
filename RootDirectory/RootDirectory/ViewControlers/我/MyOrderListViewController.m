//
//  MyOrderListViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "OrderCell.h"

@interface MyOrderListViewController ()

@end

@implementation MyOrderListViewController

@synthesize tv;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"我的订单"];
    
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
    
    OrderCell *cell = (OrderCell*)[[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil] lastObject];
    
    cell.orderNo.text = [NSString stringWithFormat:@"编号: %@",@"89412389471"];
    cell.price.text = [NSString stringWithFormat:@"￥%@",@"983"];
    cell.datetime.text = @"2015-10-10";
    cell.sendBtn.tag = indexPath.row;
    cell.sendBtn.hidden = NO;
    [cell.sendBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
    
}


-(IBAction)payClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    NSLog(@"pay:%d",btn.tag);
    
}



@end
