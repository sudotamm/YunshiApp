//
//  FenleiViewController.m
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiViewController.h"
#import "FenleiTableCell.h"
#import "FenleiSecondTableCell.h"
#import "FenleiThirdTableCell.h"

@interface FenleiViewController ()

@property (nonatomic, strong) NSMutableArray *secondFenleiArray;
@property (nonatomic, strong )NSMutableArray *thirdFenleiArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation FenleiViewController

@synthesize secondFenleiArray,thirdFenleiArray;
@synthesize selectedIndex;

#pragma mark - Private methods
- (void)showSecondTableView:(BOOL)show
{
    if(show)
    {
        self.secondTrailingConstraint.constant = 0;
    }
    else
    {
        self.secondTrailingConstraint.constant = -200.f;
    }
}

- (void)showThirdTableView:(BOOL)show
{
    if(show)
        self.thirdTrailingConstraint.constant = 0;
    else
        self.thirdTrailingConstraint.constant = -100.f;
}


#pragma mark - Notification methods
- (void)fenleiResponseWithNotification:(NSNotification *)notification
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [self.contentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.contentTableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - BaseViewController methods
- (void)rightItemTapped
{
    [self.contentTableView reloadData];
    [self showSecondTableView:NO];
    [self showThirdTableView:NO];
}

#pragma mark - UIViewController methods
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([FenleiDataManager sharedManager].redirectFenlei)
    {
        self.selectedIndex = [FenleiDataManager sharedManager].redirectFenlei.integerValue;
        [self fenleiResponseWithNotification:nil];
        [FenleiDataManager sharedManager].redirectFenlei = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"分类"];
    [self setRightNaviItemWithTitle:@"收起" imageName:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenleiResponseWithNotification:) name:kFenleiResponseNotification object:nil];
    self.contentTableView.tableFooterView = [UIView new];
    self.secondTableView.tableFooterView = [UIView new];
    self.thirdTableView.tableFooterView = [UIView new];
    //加载本地数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainService" ofType:@"plist"];
    self.serviceArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for(NSDictionary *dict in array)
    {
        FenleiModel *fm = [[FenleiModel alloc] init];
        fm.cName = [dict objectForKey:@"name"];
        fm.imageName = [dict objectForKey:@"image"];
        fm.des = [dict objectForKey:@"des"];
        [self.serviceArray addObject:fm];
    }
    [self showSecondTableView:NO];
    [self showThirdTableView:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.contentTableView)
        return self.serviceArray.count;
    else if(tableView == self.secondTableView)
        return self.secondFenleiArray.count;
    else
        return self.thirdFenleiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.contentTableView)
    {
        FenleiTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FenleiTableCell"];
        FenleiModel *fm = [self.serviceArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = fm.cName;
        cell.iconImgView.image = [UIImage imageNamed:fm.imageName];
        cell.desLabel.text = fm.des;
        return cell;
    }
    else if(tableView == self.secondTableView)
    {
        FenleiSecondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondTableCell"];
        if(IsIos8)
        {
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
        FenleiModel *fm = [self.secondFenleiArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = fm.cName;
        return cell;
    }
    else
    {
        FenleiThirdTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdTableCell"];
        if(IsIos8)
        {
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
        FenleiModel *fm = [self.thirdFenleiArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = fm.cName;
        return cell;
    }
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.contentTableView)
    {
        if([FenleiDataManager sharedManager].fenleiArray.count == 0)
        {
            self.selectedIndex = indexPath.row;
            //请求网络分类
            [[FenleiDataManager sharedManager] requestFenleiListWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId dianpuId:[HomeDataManager sharedManger].currentDianpu.sCode];
        }
        else
        {
            FenleiModel *fm = [self.serviceArray objectAtIndex:indexPath.row];
            FenleiModel *realFm = nil;
            for(FenleiModel *fmTemp in [FenleiDataManager sharedManager].fenleiArray)
            {
                if([fmTemp.cName isEqualToString:fm.cName])
                {
                    realFm = fmTemp;
                    break;
                }
            }
            self.secondFenleiArray = [NSMutableArray arrayWithArray:realFm.subCategory];
            [self.secondTableView reloadData];
            [self showSecondTableView:YES];
            [self showThirdTableView:NO];
        }
    }
    else if(tableView == self.secondTableView)
    {
        FenleiModel *fm = [self.secondFenleiArray objectAtIndex:indexPath.row];
        self.thirdFenleiArray = [NSMutableArray arrayWithArray:fm.subCategory];
        [self.thirdTableView reloadData];
        [self showThirdTableView:YES];
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"进入商品列表" customView:nil hideDelay:2.f];
    }
}

@end
