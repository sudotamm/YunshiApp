//
//  ShangpinListViewController.m
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShangpinListViewController.h"
#import "ShangpinCollectionCell.h"
#import "ShangpinDetailViewController.h"
#import "GouwuConfirmView.h"

@interface ShangpinListViewController ()

@property (nonatomic, retain) NSMutableArray *shangpinArray;
@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation ShangpinListViewController

@synthesize refreshControl,refreshFooterView;
@synthesize shangpinArray,currentPageNum;

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
        if(self.listType == kListSearch && self.searchBar.text.length == 0)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"请输入搜索内容." customView:nil hideDelay:2.f];
            [rc endRefreshing];
            return;
        }
        
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

- (void)endFooterRefresh
{
    [self.refreshFooterView endRefreshing];
}

#pragma mark - Public methods
- (void)callServerToGetListDataWithPage:(NSInteger)pageNum
{
    self.currentPageNum = pageNum;
    if(self.listType == kListCollection)
    {
        NSString *page = [NSString stringWithFormat:@"%@",@(pageNum)];
        NSString *dataCount = [NSString stringWithFormat:@"%@",@(kPageCount)];
        NSString *sCode = [HomeDataManager sharedManger].currentDianpu.sCode;
        NSString *userId = [ABCMemberDataManager sharedManager].loginMember.userId;
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kCollectionListUrl];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:page forKey:@"page"];
        [paramDict setObject:dataCount forKey:@"dataCount"];
        [paramDict setObject:sCode forKey:@"sCode"];
        [paramDict setObject:userId forKey:@"userId"];
        [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:paramDict
                                                                contentType:@"application/json"
                                                                   delegate:self
                                                                    purpose:nil];
    }
    else
    {
        NSString *searchKeyWords = self.searchBar.text;
        if(nil == searchKeyWords)
            searchKeyWords = @"";
        NSString *page = [NSString stringWithFormat:@"%@",@(pageNum)];
        NSString *dataCount = [NSString stringWithFormat:@"%@",@(kPageCount)];
        NSString *searchType = nil;
        NSString *categoryCode = nil;
        if(self.listType == kListNormal)
        {
            categoryCode = self.fenleiModel.cCode;
            searchType = @"0";
        }
        else if(self.listType == kListBenyueqianggou)
        {
            categoryCode = @"";
            searchType = @"1";
        }
        else if(self.listType == kListGuanggao)
        {
            categoryCode = @"";
            searchType = @"0";
        }
        else
        {
            categoryCode = @"";
            searchType = @"0";
        }
        NSString *sCode = [HomeDataManager sharedManger].currentDianpu.sCode;
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kShangpinListUrl];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:searchKeyWords forKey:@"searchKeyWords"];
        [paramDict setObject:page forKey:@"page"];
        [paramDict setObject:dataCount forKey:@"dataCount"];
        [paramDict setObject:searchType forKey:@"searchType"];
        [paramDict setObject:categoryCode forKey:@"categoryCode"];
        [paramDict setObject:sCode forKey:@"sCode"];
        [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:paramDict
                                                                contentType:@"application/json"
                                                                   delegate:self
                                                                    purpose:nil];
    }
}

- (IBAction)searchButtonClicked:(id)sender
{
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - Notification methosd
- (void)cancelCollectionResponseWithNotification:(NSNotification *)notification
{
    [self callServerToGetListDataWithPage:kInitPageNumber];
}

#pragma mark - BaseViewController methods
- (void)rightItemTapped
{
    if(self.contentTableView.hidden == YES)
    {
        self.contentTableView.hidden = NO;
        self.collectionView.hidden = YES;
        [self.contentTableView setContentOffset:CGPointZero];
    }
    else
    {
        self.contentTableView.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointZero];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.listType == kListSearch)
    {
        [self setNaviTitle:@"搜索商品"];
        [self setRightNaviItemWithTitle:nil imageName:@"fenleiqiehuan"];
        self.contentTableView.tableHeaderView = self.searchView;
    }
    else if(self.listType == kListBenyueqianggou)
    {
        [self setNaviTitle:@"本周抢鲜"];
        [self setRightNaviItemWithTitle:nil imageName:@"fenleiqiehuan"];
        self.contentTableView.tableHeaderView = nil;
        [self callServerToGetListDataWithPage:kInitPageNumber];
    }
    else if(self.listType == kListCollection)
    {
        [self setNaviTitle:@"我的收藏"];
        self.contentTableView.tableHeaderView = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCollectionResponseWithNotification:) name:kDelCollectionResponseNotification object:nil];
        [self callServerToGetListDataWithPage:kInitPageNumber];
    }
    else
    {
        [self setNaviTitle:@"商品列表"];
        [self setRightNaviItemWithTitle:nil imageName:@"fenleiqiehuan"];
        self.contentTableView.tableHeaderView = nil;
        [self callServerToGetListDataWithPage:kInitPageNumber];
    }
    //移除空cell的seperator line
    self.contentTableView.tableFooterView = [UIView new];
    //下拉刷新
    [self.contentTableView addSubview:self.refreshControl];
    //上拉刷新
    self.refreshFooterView.scrollView = self.contentTableView;
    __weak ShangpinListViewController *slvc = self;
    self.refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //上拉加载更多内容
        if(slvc.currentPageNum == 0)
        {
            [slvc performSelector:@selector(endFooterRefresh) withObject:nil afterDelay:0];
            [[RYHUDManager sharedManager] showWithMessage:kAllDataLoaded customView:nil hideDelay:2.f];
        }
        else
            [slvc callServerToGetListDataWithPage:slvc.currentPageNum];
    };
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShangpinListToDetail"])
    {
        ShangpinDetailViewController *sdvc = (ShangpinDetailViewController *)segue.destinationViewController;
        sdvc.hidesBottomBarWhenPushed = YES;
        sdvc.shangpinId = sender;
    }
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shangpinArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangpinTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShangpinTableCell"];
    cell.delegate = self;
    ShangpinModel *sm = [self.shangpinArray objectAtIndex:indexPath.row];
    [cell reloadWithShangpin:sm];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShangpinModel *sm = [self.shangpinArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShangpinListToDetail" sender:sm.gId];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listType == kListCollection)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(self.listType == kListCollection)
        {
            ShangpinModel *sm = [self.shangpinArray objectAtIndex:indexPath.row];
            [[UserInfoDataManager sharedManager] requestCancelCollectionWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                                               gId:sm.gId];
        }
    }
}

#pragma mark - ShangpinTableCellDelegate methods
- (void)didShangpinBuyWithCell:(ShangpinTableCell *)cell
{
    if([[ABCMemberDataManager sharedManager] isLogined])
    {
        NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
        ShangpinModel *sm = [self.shangpinArray objectAtIndex:indexPath.row];
        [[FenleiDataManager sharedManager] requestShangpinIsInBasketWithGouwuModel:sm
                                                                         gouwuType:kGouwuTypeShangpin
                                                                         chosenNum:1
                                                                         mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                            userId:[ABCMemberDataManager sharedManager].loginMember.userId];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
    }
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    if(searchBar.text.length == 0)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入搜索内容." customView:nil hideDelay:2.f];
        return;
    }
    [self callServerToGetListDataWithPage:kInitPageNumber];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shangpinArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShangpinCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShangpinCollectionCell" forIndexPath:indexPath];
    ShangpinModel *sm = [self.shangpinArray objectAtIndex:indexPath.row];
    [cell reloadWithShangpin:sm];
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat cellWidth = (collectionView.frame.size.width-flowLayout.sectionInset.left-flowLayout.sectionInset.right-flowLayout.minimumInteritemSpacing)/2;
       return CGSizeMake(cellWidth, 180.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShangpinModel *sm = [self.shangpinArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShangpinListToDetail" sender:sm.gId];
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
            self.shangpinArray = [NSMutableArray array];
        }
        for(NSDictionary *dictTemp in array)
        {
            ShangpinModel *sm = [[ShangpinModel alloc] initWithRYDict:dictTemp];
            [self.shangpinArray addObject:sm];
        }

        [self.contentTableView reloadData];
        self.currentPageNum = nextPage;
        if(nextPage == 0)
        {
            if(self.shangpinArray.count == 0)
                [[RYHUDManager sharedManager] showWithMessage:kAllDataLoaded customView:nil hideDelay:2.f];
            else
                [[RYHUDManager sharedManager] stoppedNetWorkActivity];
        }
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"商品列表获取失败";
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
