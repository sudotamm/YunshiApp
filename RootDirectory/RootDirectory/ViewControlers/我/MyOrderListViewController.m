//
//  MyOrderListViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "OrderDetailViewController.h"

@interface MyOrderListViewController ()

@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation MyOrderListViewController

@synthesize refreshControl,refreshFooterView;
@synthesize orderArray,currentPageNum;

#pragma mark - Private methods
- (UIRefreshControl *)refreshControl
{
    if(nil == refreshControl)
    {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshTrigger:) forControlEvents:UIControlEventValueChanged];
        refreshControl.tintColor = kMainProjColor;
    }
    return refreshControl;
}

- (void)refreshTrigger:(UIRefreshControl *)rc
{
    if(rc.isRefreshing)
    {
        [self callServerToGetListDataWithPage:kInitPageNumber];
    }
}

- (MJRefreshFooterView *)refreshFooterView
{
    if(nil == refreshFooterView)
    {
        refreshFooterView = [[MJRefreshFooterView alloc] init];
    }
    return refreshFooterView;
}

#pragma mark - Public methods
- (void)callServerToGetListDataWithPage:(NSInteger)pageNum
{
    self.currentPageNum = pageNum;
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kOrderListUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.userId forKey:@"userId"];
    [paramDict setObject:@(self.segmentControl.selectedSegmentIndex+1) forKey:@"orderType"];
    [paramDict setObject:[HomeDataManager sharedManger].currentDianpu.sCode forKey:@"sCode"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

- (IBAction)segmentValueChanged:(id)sender
{
    [self callServerToGetListDataWithPage:kInitPageNumber];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"我的订单"];
    //移除空cell的seperator line
    self.contentTableView.tableFooterView = [UIView new];
    //下拉刷新
    [self.contentTableView addSubview:self.refreshControl];
    //上拉刷新
    self.refreshFooterView.scrollView = self.contentTableView;
    __weak MyOrderListViewController *gvc = self;
    self.refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //上拉加载更多内容
        [gvc callServerToGetListDataWithPage:gvc.currentPageNum];
    };
    self.segmentControl.selectedSegmentIndex = 0;
    [self callServerToGetListDataWithPage:kInitPageNumber];
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil];
        cell = [nibs lastObject];
        cell.delegate = self;
        if(IsIos8)
        {
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
    }
    OrderModel *om = [self.orderArray objectAtIndex:indexPath.row];
    cell.orderNo.text = [NSString stringWithFormat:@"编号: %@",om.oId];
    if(self.segmentControl.selectedSegmentIndex+1 == kOrderTypeWeifukuan)
        cell.price.textColor = [UIColor colorWithRed:207.f/255 green:30.f/255 blue:30.f/255 alpha:1.f];
    else
        cell.price.textColor = [UIColor colorWithRed:150.f/255 green:150.f/255 blue:150.f/255 alpha:1.f];
    cell.price.text = [NSString stringWithFormat:@"价格：￥%@",om.price];
    NSDate *orderDate = [NSDate dateFromStringByFormat:@"yyyy-MM-dd HH:mm" string:om.oDatetime];
    cell.datetime.text = [NSDate dateToStringByFormat:@"yyyy-MM-dd" date:orderDate];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderDetailViewController *odvc = [mainSB instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    odvc.hidesBottomBarWhenPushed = YES;
    OrderModel *om = [self.orderArray objectAtIndex:indexPath.row];
    odvc.hidesBottomBarWhenPushed = YES;
    odvc.orderId = om.oId;
    odvc.orderType = (OrderType)(self.segmentControl.selectedSegmentIndex+1);
    [self.navigationController pushViewController:odvc animated:YES];
}

#pragma mark - OrderCellDelegate methods
- (void)didGenerateQRCodeWithCell:(OrderCell *)cell
{
    [[RYHUDManager sharedManager] showWithMessage:@"生成二维码" customView:nil hideDelay:2.f];
}


#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    [self.refreshFooterView endRefreshing];
    [self.refreshControl endRefreshing];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
    {
        NSInteger nextPage = [[dict objectForKey:@"page"] integerValue];
        NSArray *array = [dict objectForKey:@"list"];
        if(self.currentPageNum == kInitPageNumber)
        {
            //第一页数据
            self.orderArray = [NSMutableArray array];
        }
        for(NSDictionary *dictTemp in array)
        {
            OrderModel *om = [[OrderModel alloc] initWithRYDict:dictTemp];
            [self.orderArray addObject:om];
        }
        [self.contentTableView reloadData];
        if(nextPage == 0)
        {
            if(self.orderArray.count == 0)
                [[RYHUDManager sharedManager] showWithMessage:kAllDataLoaded customView:nil hideDelay:2.f];
            else
            {
                [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            }
        }
        else
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            self.currentPageNum = nextPage;
        }
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"订单列表获取失败";
        [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:4.f];
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [self.refreshFooterView endRefreshing];
    [self.refreshControl endRefreshing];
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:4.f];
}


@end
