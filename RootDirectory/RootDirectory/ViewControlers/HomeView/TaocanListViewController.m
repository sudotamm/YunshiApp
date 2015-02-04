//
//  TaocanListViewController.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "TaocanListViewController.h"

@interface TaocanListViewController ()

@property (nonatomic, strong) NSMutableArray *taocaoArray;

@end

@implementation TaocanListViewController

@synthesize taocaoArray;

#pragma mark - Private methods
- (void)requestTaocaoListWithMendianId:(NSString *)mendianId
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kBasketListUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:mendianId forKey:@"sCode"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"精选礼篮"];
    self.contentTableView.tableFooterView = [UIView new];
    [self requestTaocaoListWithMendianId:[HomeDataManager sharedManger].currentDianpu.sCode];
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taocaoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaocanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaocanTableCell"];
    cell.delegate = self;
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    TaocanModel *tm = [self.taocaoArray objectAtIndex:indexPath.row];
    [cell reloadWithTaocan:tm];
    cell.indexLabel.text = [NSString stringWithFormat:@"套餐%@",@(indexPath.row+1)];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[RYHUDManager sharedManager] showWithMessage:@"套餐详情页面" customView:nil hideDelay:2.f];
}

#pragma mark - TaocanTableCellDelegate methods
- (void)didTaocanBuyWithCell:(TaocanTableCell *)cell
{
    if([[ABCMemberDataManager sharedManager] isLogined])
    {
        NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
        TaocanModel *tm = [self.taocaoArray objectAtIndex:indexPath.row];
        [[FenleiDataManager sharedManager] requestShangpinIsInBasketWithGouwuModel:tm
                                                                         gouwuType:kGouwuTypeTaocan
                                                                         chosenNum:1
                                                                         mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                            userId:[ABCMemberDataManager sharedManager].loginMember.userId];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
    }
}

- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //获取套餐列表返回
    if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
    {
        [[RYHUDManager sharedManager] stoppedNetWorkActivity];
        self.taocaoArray = [NSMutableArray array];
        NSArray *array = [dict objectForKey:@"list"];
        if(array.count > 0)
        {
            for(NSDictionary *dictTaocan in array)
            {
                TaocanModel *tm = [[TaocanModel alloc] initWithRYDict:dictTaocan];
                [self.taocaoArray addObject:tm];
            }
        }
        [self.contentTableView reloadData];
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"套餐列表获取错误";
        [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
    }
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}
@end
