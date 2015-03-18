//
//  TaocanDetailViewController.m
//  RootDirectory
//
//  Created by ryan on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "TaocanDetailViewController.h"
#import "ShangpinDetailViewController.h"

@interface TaocanDetailViewController ()

@end

@implementation TaocanDetailViewController

#pragma mark - Private methods
- (void)reloadTaocanDetail
{
    self.nameLabel.text = self.taocanModel.cName;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",nil==self.taocanModel.cNewPrice?@"":self.taocanModel.cNewPrice];
    self.bianmaLabel.text = self.taocanModel.cId;
    [self.iconImgView aysnLoadImageWithUrl:self.taocanModel.picURL placeHolder:@"loading_square"];
    
    CGFloat youhui = self.taocanModel.cOldPrice.floatValue - self.taocanModel.cNewPrice.floatValue;
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥%.2f",youhui];
}

- (void)reloadShangpinList
{
    [self.contentTableView reloadData];
}

- (void)requestTaocanDetailWithTaocanId:(NSString *)taocanId
                                mendianId:(NSString *)mendianId
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kTaocanDetailUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:taocanId forKey:@"cId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

#pragma mark - Public methods
- (IBAction)buyButtonClicked:(id)sender
{
    if([[ABCMemberDataManager sharedManager] isLogined])
    {
        [[FenleiDataManager sharedManager] requestShangpinIsInBasketWithGouwuModel:self.taocanModel
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

- (IBAction)jiesuanButtonClicked:(id)sender
{
    if([FenleiDataManager sharedManager].hasEditedGouwuche)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowGouwucheViewNotification object:nil];
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"暂未添加任何商品" customView:nil hideDelay:2.f];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"套餐详情"];
    self.contentTableView.tableFooterView = [UIView new];
    [self reloadTaocanDetail];
    [self requestTaocanDetailWithTaocanId:self.taocanModel.cId
                                mendianId:[HomeDataManager sharedManger].currentDianpu.sCode];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TaocanDetailToShangpinDetail"])
    {
        ShangpinDetailViewController *sdvc = (ShangpinDetailViewController *)segue.destinationViewController;
        sdvc.hidesBottomBarWhenPushed = YES;
        sdvc.shangpinId = sender;
    }
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taocanModel.shangpinArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangpinTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShangpinTableCell"];
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.delegate = self;
    ShangpinModel *sm = [self.taocanModel.shangpinArray objectAtIndex:indexPath.row];
    [cell reloadWithShangpin:sm];
    NSInteger shuliang = [sm.number integerValue];
    cell.numberLabel.hidden = NO;
    if(shuliang < 1)
        shuliang = 1;
    cell.numberLabel.text = [NSString stringWithFormat:@"x%@",@(shuliang)];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShangpinModel *sm = [self.taocanModel.shangpinArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TaocanDetailToShangpinDetail" sender:sm.gId];
}

#pragma mark - ShangpinTableCellDelegate methods
- (void)didShangpinBuyWithCell:(ShangpinTableCell *)cell
{
    if([[ABCMemberDataManager sharedManager] isLogined])
    {
        NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
        ShangpinModel *sm = [self.taocanModel.shangpinArray objectAtIndex:indexPath.row];
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


#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
    {
        [[RYHUDManager sharedManager] stoppedNetWorkActivity];
        self.taocanModel = [[TaocanModel alloc] initWithRYDict:dict];
        self.taocanModel.shangpinArray = [NSMutableArray array];
        NSArray *array = [dict objectForKey:@"list"];
        for(NSDictionary *dictShangpin in array)
        {
            ShangpinModel *sm = [[ShangpinModel alloc] initWithRYDict:dictShangpin];
            [self.taocanModel.shangpinArray addObject:sm];
        }
        [self reloadTaocanDetail];
        [self reloadShangpinList];
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"套餐详情获取失败";
        [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:4.f];
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:4.f];
}


@end
