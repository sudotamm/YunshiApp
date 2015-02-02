//
//  MJRefreshTableFooterView.h
//  weibo
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  上拉加载更多

#import "MJRefreshBaseView.h"
@interface MJRefreshFooterView : MJRefreshBaseView
+ (id)footer;
//默认是0，自定义给ios7 中空出tab bar的inset使用
@property (nonatomic) CGFloat bottomInset;
@end