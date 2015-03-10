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
#import "PayConfirmView.h"
#import "PayConfirmViewController.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) OrderDetailModel *orderDetail;
@property (nonatomic, assign) BOOL containYyzt;
@property (nonatomic, assign) BOOL containZp;
@property (nonatomic, assign) BOOL containXt;
@property (nonatomic, assign) NSInteger peisongCount;

@end

@implementation OrderDetailViewController

@synthesize orderDetail;
@synthesize containXt,containYyzt,containZp,peisongCount;

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
        self.lianxifangshiLabel.text = self.orderDetail.zptel;
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
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PayConfirmView" owner:self options:nil];
    PayConfirmView *pcv = [nibs lastObject];
    [GouwucheDataManager sharedManager].payType = kOrderPayTypeAlipay;  //默认支付宝付款
    [pcv reloadWithOrderPayType:[GouwucheDataManager sharedManager].payType];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:[UIImage imageNamed:@"bg_popover"] contentView:pcv position:CGPointZero];
}

#pragma mark - Notification methods
- (void)payConfirmResponseWithNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"OrderDetailToPayConfirm" sender:nil];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"订单详情"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payConfirmResponseWithNotification:) name:kPayConfirmResponseNotification object:nil];
    self.contentTableView.tableFooterView = [UIView new];
    if(self.orderType == kOrderTypeWeifukuan)
        self.bottomHeightConstraint.constant = 50.f;
    else
        self.bottomHeightConstraint.constant = 0;
    [self reloadOrderDetail];
    [self requestOrderDetailWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                               orderId:self.orderId
                                 sCode:[HomeDataManager sharedManger].currentDianpu.sCode
                             orderType:self.orderType];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"OrderDetailToPayConfirm"])
    {
        PayConfirmViewController *pcvc = (PayConfirmViewController *)segue.destinationViewController;
        pcvc.orderDetail = self.orderDetail;
    }
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.peisongCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.peisongCount == 3)
    {
        if(section == 0)
        {
            return self.orderDetail.yyztList.gouwucheArray.count;
        }
        else if(section == 1)
        {
            return self.orderDetail.zpList.gouwucheArray.count;
        }
        else
        {
            return self.orderDetail.xtList.gouwucheArray.count;
        }
    }
    else if(self.peisongCount == 2)
    {
        if(!self.containXt)
        {
            if(section == 0)
            {
                return self.orderDetail.yyztList.gouwucheArray.count;
            }
            else
            {
                return self.orderDetail.zpList.gouwucheArray.count;
            }
        }
        if(!self.containZp)
        {
            if(section == 0)
            {
                return self.orderDetail.yyztList.gouwucheArray.count;
            }
            else
            {
                return self.orderDetail.xtList.gouwucheArray.count;
            }
        }
        if(!self.containYyzt)
        {
            if(section == 0)
            {
                return self.orderDetail.zpList.gouwucheArray.count;
            }
            else
            {
                return self.orderDetail.xtList.gouwucheArray.count;
            }
        }
    }
    else
    {
        if(self.containYyzt)
            return self.orderDetail.yyztList.gouwucheArray.count;
        if(self.containZp)
            return self.orderDetail.zpList.gouwucheArray.count;
        if(self.containXt)
            return self.orderDetail.xtList.gouwucheArray.count;
    }
    return 0;
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
    if(self.peisongCount == 3)
    {
        if(section == 0)
        {
            gouwucheArray = self.orderDetail.yyztList.gouwucheArray;
        }
        else if(section == 1)
        {
            gouwucheArray = self.orderDetail.zpList.gouwucheArray;
        }
        else
        {
            gouwucheArray = self.orderDetail.xtList.gouwucheArray;
        }
    }
    else if(self.peisongCount == 2)
    {
        if(!self.containXt)
        {
            if(section == 0)
            {
                gouwucheArray = self.orderDetail.yyztList.gouwucheArray;
            }
            else
            {
                gouwucheArray = self.orderDetail.zpList.gouwucheArray;
            }
        }
        if(!self.containZp)
        {
            if(section == 0)
            {
                gouwucheArray = self.orderDetail.yyztList.gouwucheArray;
            }
            else
            {
                gouwucheArray = self.orderDetail.xtList.gouwucheArray;
            }
        }
        if(!self.containYyzt)
        {
            if(section == 0)
            {
                gouwucheArray = self.orderDetail.zpList.gouwucheArray;
            }
            else
            {
                gouwucheArray = self.orderDetail.xtList.gouwucheArray;
            }
        }
    }
    else
    {
        if(self.containYyzt)
            gouwucheArray = self.orderDetail.yyztList.gouwucheArray;
        if(self.containZp)
            gouwucheArray = self.orderDetail.zpList.gouwucheArray;
        if(self.containXt)
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
    
    if(self.peisongCount == 3)
    {
        if(section == 0)
        {
            dm = self.orderDetail.yyztList;
            hv.titleLabel.text = @"预约自提";
        }
        else if(section == 1)
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
    else if(self.peisongCount == 2)
    {
        if(!self.containXt)
        {
            if(section == 0)
            {
                dm = self.orderDetail.yyztList;
                hv.titleLabel.text = @"预约自提";
            }
            else
            {
                dm = self.orderDetail.zpList;
                hv.titleLabel.text = @"宅配送";
            }
        }
        if(!self.containZp)
        {
            if(section == 0)
            {
                dm = self.orderDetail.yyztList;
                hv.titleLabel.text = @"预约自提";
            }
            else
            {
                dm = self.orderDetail.xtList;
                hv.titleLabel.text = @"现提";
            }
        }
        if(!self.containYyzt)
        {
            if(section == 0)
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
    }
    else
    {
        if(self.containYyzt)
        {
            dm = self.orderDetail.yyztList;
            hv.titleLabel.text = @"预约自提";
        }
        if(self.containZp)
        {
            dm = self.orderDetail.zpList;
            hv.titleLabel.text = @"宅配送";
        }
        if(self.containXt)
        {
            dm = self.orderDetail.xtList;
            hv.titleLabel.text = @"现提";
        }
    }
    [hv reloadWithDeliverModel:dm];
    return hv;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DeliverFooterView" owner:self options:nil];
    DeliverFooterView *fv = [nibs lastObject];
    DeliverModel *dm = nil;
    
    if(self.peisongCount == 3)
    {
        if(section == 0)
        {
            dm = self.orderDetail.yyztList;
        }
        else if(section == 1)
        {
            dm = self.orderDetail.zpList;
        }
        else
        {
            dm = self.orderDetail.xtList;
        }
    }
    else if(self.peisongCount == 2)
    {
        if(!self.containXt)
        {
            if(section == 0)
            {
                dm = self.orderDetail.yyztList;
            }
            else
            {
                dm = self.orderDetail.zpList;
            }
        }
        if(!self.containZp)
        {
            if(section == 0)
            {
                dm = self.orderDetail.yyztList;
            }
            else
            {
                dm = self.orderDetail.xtList;
            }
        }
        if(!self.containYyzt)
        {
            if(section == 0)
            {
                dm = self.orderDetail.zpList;
            }
            else
            {
                dm = self.orderDetail.xtList;
            }
        }
    }
    else
    {
        if(self.containYyzt)
        {
            dm = self.orderDetail.yyztList;
        }
        if(self.containZp)
        {
            dm = self.orderDetail.zpList;
        }
        if(self.containXt)
        {
            dm = self.orderDetail.xtList;
        }
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
        
        if(self.orderDetail.yyztList.gouwucheArray.count > 0)
            self.containYyzt = YES;
        if(self.orderDetail.zpList.gouwucheArray.count > 0)
            self.containZp = YES;
        if(self.orderDetail.xtList.gouwucheArray.count > 0)
            self.containXt = YES;
        self.peisongCount = 0;
        if(self.containYyzt)
            self.peisongCount++;
        if(self.containZp)
            self.peisongCount++;
        if(self.containXt)
            self.peisongCount++;
        
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
