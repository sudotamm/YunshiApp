//
//  FenleiViewController.m
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiViewController.h"
#import "FenleiTableCell.h"

@interface FenleiViewController ()

@end

@implementation FenleiViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"分类"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainService" ofType:@"plist"];
    self.serviceArray = [NSArray arrayWithContentsOfFile:path];
    
    self.contentTableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FenleiTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FenleiTableCell"];
    NSDictionary *dict = [self.serviceArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dict objectForKey:@"name"];
    cell.iconImgView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    cell.desLabel.text = [dict objectForKey:@"des"];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[FenleiDataManager sharedManager] requestTest];
}

@end
