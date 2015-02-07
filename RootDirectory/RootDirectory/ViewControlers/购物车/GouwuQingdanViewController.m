//
//  GouwuQingdanViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwuQingdanViewController.h"
#import "GouwuQingdanTableCell.h"

@interface GouwuQingdanViewController ()

@end

@implementation GouwuQingdanViewController

#pragma mark - Public methods

- (IBAction)xiayibuButtonClicked:(id)sender
{

}

- (void)reloadZongjiPrice
{
    CGFloat zongji = 0;
    //商品总价
    for(id qingdanModel in [GouwucheDataManager sharedManager].qingdanArray)
    {
        CGFloat price;
        if([qingdanModel isKindOfClass:[GouwucheModel class]])
        {
            GouwucheModel *gm = (GouwucheModel *)qingdanModel;
            price = [gm.price floatValue];
            zongji += price*[gm.num integerValue];
        }
        else
        {
            ShanginHuikuiModel *shm = (ShanginHuikuiModel *)qingdanModel;
            price = [shm.gnewPrice floatValue];
            zongji += price*1;
        }
    }
    if(zongji > 0)
    {
        self.xiayibuButton.enabled = YES;
    }
    else
        self.xiayibuButton.enabled = NO;
    NSInteger yunfei;
    //计算运费
    if([GouwucheDataManager sharedManager].deliverFee == 0)
    {
        //免运费
        yunfei = 0;
    }
    else
    {
        if([GouwucheDataManager sharedManager].deliverThreshold == 99999999)
        {
            //不包邮
            yunfei = [GouwucheDataManager sharedManager].deliverFee;
        }
        else
        {
            //阀值包邮
            if(zongji >= [GouwucheDataManager sharedManager].deliverThreshold)
                yunfei = 0;
            else
                yunfei = [GouwucheDataManager sharedManager].deliverFee;
        }
    }
    zongji = zongji+yunfei;
    self.zongjiLabel.text = [NSString stringWithFormat:@"￥%.2f",zongji];
}

- (void)reloadJiesuanView
{
    NSInteger deliverFee = [GouwucheDataManager sharedManager].deliverFee;
    NSInteger deliverThreshold = [GouwucheDataManager sharedManager].deliverThreshold;
    if(deliverFee == 0)
    {
        //免运费
        self.yunfeiTipLabel.hidden = YES;
        self.yunfeiLabel.hidden = NO;
        self.yunfeiLabel.text = @"免运费（指定区域）";
        self.zongjiYunfeiLabel.text = @"免运费";
    }
    else
    {
        self.zongjiYunfeiLabel.text = [NSString stringWithFormat:@"￥%@",@(deliverFee)];
        if(deliverThreshold == 99999999)
        {
            //不包邮
            self.yunfeiTipLabel.hidden = YES;
            self.yunfeiLabel.hidden = NO;
            self.yunfeiLabel.text = [NSString stringWithFormat:@"运费%@元",@(deliverFee)];
        }
        else
        {
            //阀值包邮
            self.yunfeiTipLabel.hidden = NO;
            self.yunfeiLabel.hidden = NO;
            self.yunfeiTipLabel.text = [NSString stringWithFormat:@"单笔消费满%@元免运费（指定区域）",@(deliverThreshold)];
            self.yunfeiLabel.text = [NSString stringWithFormat:@"单笔消费未满%@元运费%@元",@(deliverThreshold),@(deliverFee)];
        }
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"购物清单"];
    self.contentTableView.tableFooterView = [UIView new];
    [self reloadJiesuanView];
    [self reloadZongjiPrice];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GouwucheDataManager sharedManager].qingdanArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GouwuQingdanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GouwuQingdanTableCell"];
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    id gouwuQingdanModel = [[GouwucheDataManager sharedManager].qingdanArray objectAtIndex:indexPath.row];
    [cell reloadWithGouwuQingdanModel:gouwuQingdanModel];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}
@end
