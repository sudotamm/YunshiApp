//
//  GouwucheViewController.m
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheViewController.h"

@interface GouwucheViewController ()

@property (nonatomic, strong) NSMutableArray *gouwucheArray;
@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation GouwucheViewController

@synthesize refreshControl,refreshFooterView;
@synthesize gouwucheArray,currentPageNum;

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
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGouwucheListUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.userId forKey:@"userId"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(pageNum)] forKey:@"page"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(kPageCount)] forKey:@"dataCount"];

    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

- (IBAction)xiayibuButtonClicked:(id)sender
{
    
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"购物车"];
    
    //移除空cell的seperator line
    self.contentTableView.tableFooterView = [UIView new];
    //下拉刷新
    [self.contentTableView addSubview:self.refreshControl];
    //上拉刷新
    self.refreshFooterView.scrollView = self.contentTableView;
    __weak GouwucheViewController *gvc = self;
    self.refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //上拉加载更多内容
        [gvc callServerToGetListDataWithPage:gvc.currentPageNum];
    };
    [self callServerToGetListDataWithPage:kInitPageNumber];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"ShangpinListToDetail"])
//    {
//        ShangpinDetailViewController *sdvc = (ShangpinDetailViewController *)segue.destinationViewController;
//        sdvc.hidesBottomBarWhenPushed = YES;
//        sdvc.shangpinId = sender;
//    }
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}


#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gouwucheArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GouwucheTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GouwucheTableCell"];
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    GouwucheModel *gm = [self.gouwucheArray objectAtIndex:indexPath.row];
    [cell reloadWithGouwucheModel:gm];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[RYHUDManager sharedManager] showWithMessage:@"套餐详情页面" customView:nil hideDelay:2.f];
}

#pragma mark - GouwucheTableCellDelegate methods
- (void)didGouwucheClickedWithCell:(GouwucheTableCell *)cell
{
    //点击加/减/checkbox 按钮之后重新计算当前总计
    NSLog(@"重新计算。");
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
        NSInteger deliverFee = [[dict objectForKey:@"deliverFee"] integerValue];
        NSInteger deliverThreshold = [[dict objectForKey:@"deliverThreshold"] integerValue];
        if(deliverFee == 0)
        {
            //免运费
            self.yunfeiTipLabel.hidden = YES;
            self.yunfeiLabel.hidden = NO;
            self.yunfeiLabel.text = @"免运费（指定区域）";
        }
        else
        {
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
        NSArray *array = [dict objectForKey:@"list"];
        if(self.currentPageNum == kInitPageNumber)
        {
            //第一页数据
            self.gouwucheArray = [NSMutableArray array];
        }
        for(NSDictionary *dictTemp in array)
        {
            GouwucheModel *gm = [[GouwucheModel alloc] initWithRYDict:dictTemp];
            [self.gouwucheArray addObject:gm];
        }
        
        [self.contentTableView reloadData];
        if(nextPage == 0)
        {
            [[RYHUDManager sharedManager] showWithMessage:kAllDataLoaded customView:nil hideDelay:4.f];
        }
        else
        {
            self.currentPageNum = nextPage;
        }
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"购物车列表获取失败";
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
