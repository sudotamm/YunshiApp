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
    rect.size.height = /*self.contentTableView.rowHeight*/30.f*self.dianpuArray.count;
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
    }
    return cell;
}

@end
