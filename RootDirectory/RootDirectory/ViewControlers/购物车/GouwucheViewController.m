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

#pragma mark - Notification methods
- (void)addGouwucheResponseWithNotification:(NSNotification *)notification
{
    if(nil == notification.object)
    {
        //添加购物车成功 - 重新加载购物车列表
        [self callServerToGetListDataWithPage:kInitPageNumber];
    }
}

- (void)removeGouwucheResponseWithNotification:(NSNotification *)notification
{
    if(notification.object)
    {
        //删除购物车失败
        [[RYHUDManager sharedManager] showWithMessage:notification.object customView:nil hideDelay:2.f];
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"删除购物车成功" customView:nil hideDelay:2.f];
        //删除购物车成功 - 重新加载购物车列表
        [self callServerToGetListDataWithPage:kInitPageNumber];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"购物车"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGouwucheResponseWithNotification:) name:kAddGouwucheResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeGouwucheResponseWithNotification:) name:kRemoveGouwucheResponseNotification object:nil];
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
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        GouwucheModel *gm = [self.gouwucheArray objectAtIndex:indexPath.row];
        GouwuType gouwuType = (GouwuType)[gm.gType integerValue];
        [[FenleiDataManager sharedManager] requestEditGouwucheWithGouwuId:gm.gId
                                                                gouwuType:gouwuType
                                                                      num:0
                                                                 editType:kGouwuEditTypeRemove
                                                                mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                   userId:[ABCMemberDataManager sharedManager].loginMember.userId];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[RYHUDManager sharedManager] showWithMessage:@"套餐详情页面" customView:nil hideDelay:2.f];
}

#pragma mark - GouwucheTableCellDelegate methods
- (void)reloadZongjiPrice
{
    CGFloat zongji = 0;
    for(GouwucheModel *gm in self.gouwucheArray)
    {
        if(gm.isSelected)
        {
            zongji += [gm.price floatValue]*[gm.num integerValue];
        }
    }
    self.zongjiLabel.text = [NSString stringWithFormat:@"￥%.2f",zongji];
    if(zongji > 0)
    {
        self.xiayibuButton.enabled = YES;
    }
    else
        self.xiayibuButton.enabled = NO;
}

- (void)didGouwucheClickedWithCell:(GouwucheTableCell *)cell
{
    //点击加/减/checkbox 按钮之后重新计算当前总计
    [self reloadZongjiPrice];
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
            gm.isSelected = YES;
            [self.gouwucheArray addObject:gm];
        }
        [self.contentTableView reloadData];
        [self reloadZongjiPrice];
        if(nextPage == 0)
        {
            [[RYHUDManager sharedManager] showWithMessage:kAllDataLoaded customView:nil hideDelay:2.f];
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
