//
//  DianpuChooseView.m
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "DianpuChooseView.h"

@implementation DianpuChooseView

@synthesize dianpuArray,dianpuTableView;

- (void)relaodWithDianpuArray:(NSArray *)array
{
    self.dianpuArray = array;
    //设置popover的高度
    CGRect rect = self.frame;
    rect.size.height = /*self.contentTableView.rowHeight*/30.f*self.dianpuArray.count+20.f;
    self.frame = rect;
    [self.dianpuTableView reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dianpuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.f];
    }
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    DianpuModel *dm = [self.dianpuArray objectAtIndex:indexPath.row];
    cell.textLabel.text = dm.sName;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[RYRootBlurViewManager sharedManger] hideBlurView];
    DianpuModel *dm = [self.dianpuArray objectAtIndex:indexPath.row];
    [HomeDataManager sharedManger].currentDianpu = dm;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDianpuChangeNotification object:nil];
}

@end
