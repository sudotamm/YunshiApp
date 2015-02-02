//
//  ShangpinListViewController.h
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefreshFooterView.h"
#import "ShangpinTableCell.h"

typedef NS_ENUM(NSInteger, ShangpinListType)
{
    kListNormal = 0,
    kListBenyueqianggou = 1,
    kListSearch = 2
};

@interface ShangpinListViewController : BaseViewController<ShangpinTableCellDelegate>

@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) MJRefreshFooterView *refreshFooterView;
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

//2宫格展示
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) FenleiModel *fenleiModel;
@property (nonatomic, assign) ShangpinListType listType;

@end
