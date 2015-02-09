//
//  OrderDetailViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableCell.h"
#import "DeliverHeaderView.h"
#import "DeliverFooterView.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@end

@implementation OrderDetailViewController

@synthesize orderDetail;

#pragma mark - Private methods
- (void)requestOrderDetailWithUserId:(NSString *)userId
                             orderId:(NSString *)oId
                               sCode:(NSString *)sCode
                           orderType:(OrderType)orderType
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kOrderDetailUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:oId forKey:@"orderId"];
    [paramDict setObject:sCode forKey:@"sCode"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(orderType)] forKey:@"orderType"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

- (void)reloadOrderDetail
{
    if(self.orderDetail)
    {
        self.contentTableView.hidden = NO;
        self.dingdanhaoLabel.text = self.orderDetail.orderId;
        self.huiyuanhaoLabel.text = self.orderDetail.phone;
        self.xingmingLabel.text = self.orderDetail.name;
        self.lianxifangshiLabel.text = self.orderDetail.phone;
        self.shouhuodizhiLabel.text = self.orderDetail.addr;
        self.zongjiLabel.text = [NSString stringWithFormat:@"￥%@",self.orderDetail.price];
        [self.contentTableView reloadData];
    }
    else
    {
        self.contentTableView.hidden = YES;
    }
}

#pragma mark - Public methods
- (IBAction)qujiesuanButtonClicked:(id)sender
{
    
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"订单详情"];
    self.contentTableView.tableFooterView = [UIView new];
    [self reloadOrderDetail];
    [self requestOrderDetailWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                               orderId:self.orderId
                                 sCode:[HomeDataManager sharedManger].currentDianpu.sCode
                             orderType:self.orderType];
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount = 0;
    if(self.orderDetail.yyztList.gouwucheArray.count > 0)
        sectionCount++;
    if(self.orderDetail.zpList.gouwucheArray.count > 0)
        sectionCount++;
    if(self.orderDetail.xtList.gouwucheArray.count > 0)
        sectionCount++;
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(self.orderDetail.yyztList.gouwucheArray.count > 0)
            return self.orderDetail.yyztList.gouwucheArray.count;
        else if(self.orderDetail.zpList.gouwucheArray.count > 0)
            return self.orderDetail.zpList.gouwucheArray.count;
        else
            return self.orderDetail.xtList.gouwucheArray.count;
    }
    else if(section == 1)
    {
        if(self.orderDetail.zpList.gouwucheArray.count > 0)
            return self.orderDetail.zpList.gouwucheArray.count;
        else
            return self.orderDetail.xtList.gouwucheArray.count;
    }
    else
    {
        return self.orderDetail.xtList.gouwucheArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableCell"];
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    NSInteger section = indexPath.section;
    NSMutableArray *gouwucheArray = nil;
    if(section == 0)
    {
        if(self.orderDetail.yyztList.gouwucheArray.count > 0)
            gouwucheArray = self.orderDetail.yyztList.gouwucheArray;
        else if(self.orderDetail.zpList.gouwucheArray.count > 0)
            gouwucheArray = self.orderDetail.zpList.gouwucheArray;
        else
            gouwucheArray = self.orderDetail.xtList.gouwucheArray;
    }
    else if(section == 1)
    {
        if(self.orderDetail.zpList.gouwucheArray.count > 0)
            gouwucheArray = self.orderDetail.zpList.gouwucheArray;
        else
            gouwucheArray = self.orderDetail.xtList.gouwucheArray;
    }
    else
    {
        gouwucheArray = self.orderDetail.xtList.gouwucheArray;
    }
    DingdanShangpinModel *dsm = [gouwucheArray objectAtIndex:indexPath.row];
    [cell reloadWithGouwucheModel:dsm];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DeliverHeaderView" owner:self options:nil];
    DeliverHeaderView *hv = [nibs lastObject];
    DeliverModel *dm = nil;
    if(section == 0)
    {
        if(self.orderDetail.yyztList.gouwucheArray.count > 0)
        {
            dm = self.orderDetail.yyztList;
            hv.titleLabel.text = @"预约自提";
        }
        else if(self.orderDetail.zpList.gouwucheArray.count > 0)
        {
            dm = self.orderDetail.zpList;
            hv.titleLabel.text = @"宅配送";
        }
        else
        {
            dm = self.orderDetail.xtList;
            hv.titleLabel.text = @"现提";
        }
    }
    else if(section == 1)
    {
        if(self.orderDetail.zpList.gouwucheArray.count > 0)
        {
            dm = self.orderDetail.zpList;
            hv.titleLabel.text = @"宅配送";
        }
        else
        {
            dm = self.orderDetail.xtList;
            hv.titleLabel.text = @"现提";
        }
    }
    else
    {
        dm = self.orderDetail.xtList;
        hv.titleLabel.text = @"现提";
    }
    [hv reloadWithDeliverModel:dm];
    return hv;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DeliverFooterView" owner:self options:nil];
    DeliverFooterView *fv = [nibs lastObject];
    DeliverModel *dm = nil;
    if(section == 0)
    {
        if(self.orderDetail.yyztList.gouwucheArray.count > 0)
        {
            dm = self.orderDetail.yyztList;
        }
        else if(self.orderDetail.zpList.gouwucheArray.count > 0)
        {
            dm = self.orderDetail.zpList;
        }
        else
        {
            dm = self.orderDetail.xtList;
        }
    }
    else if(section == 1)
    {
        if(self.orderDetail.zpList.gouwucheArray.count > 0)
        {
            dm = self.orderDetail.zpList;
        }
        else
        {
            dm = self.orderDetail.xtList;
        }
    }
    else
    {
        dm = self.orderDetail.xtList;
    }
    [fv reloadWithDeliverModel:dm];
    return fv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.f;
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    //订单详情返回
    if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
    {
        [[RYHUDManager sharedManager] stoppedNetWorkActivity];
        self.orderDetail = [[OrderDetailModel alloc] initWithRYDict:dict];
        [self reloadOrderDetail];
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"订单详情获取失败";
        [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}
@end
