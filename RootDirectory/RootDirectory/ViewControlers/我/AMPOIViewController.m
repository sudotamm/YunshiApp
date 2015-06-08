//
//  AMPOIViewController.m
//  RootDirectory
//
//  Created by YuanRyan on 6/8/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "AMPOIViewController.h"

@interface AMPOIViewController ()

@property (nonatomic, strong) NSMutableArray *poiArray;

@end

@implementation AMPOIViewController

#pragma mark - Public mehtods
- (IBAction)searchButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if(self.searchBar.text.length == 0)
    {
        [[RYHUDManager sharedManager] showWithMessage:self.searchBar.placeholder customView:nil hideDelay:12.f];
        return;
    }
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = self.searchBar.text;
    poiRequest.city = @[@"上海"];
    poiRequest.requireExtension = YES;
    //发起POI搜索
    [self.amSearch AMapPlaceSearch:poiRequest];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"请选择地址"];
    self.contentTableView.tableFooterView = [UIView new];
    //初始化检索对象
    self.amSearch = [[AMapSearchAPI alloc] initWithSearchKey:@"d24349dd487466f9a1c13959f846d935" Delegate:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.1f alpha:1.f];
    }
    AMapPOI *poi = [self.poiArray objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *poi = [self.poiArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAMPoiSelectedNotification object:poi];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchButtonClicked:nil];
}

#pragma mark - AMapSearchDelegate methods

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    /**
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
    */
    self.poiArray = [NSMutableArray arrayWithArray:response.pois];
    [self.contentTableView reloadData];
}

@end
