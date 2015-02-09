//
//  DeliverFooterView.m
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "DeliverFooterView.h"

@implementation DeliverFooterView

- (void)reloadWithDeliverModel:(DeliverModel *)dm
{
    CGFloat xiaoji = 0;
    for(DingdanShangpinModel *dsm in dm.gouwucheArray)
    {
        xiaoji+= dsm.totalprice.floatValue;
    }
    self.xiaojiLabel.text = [NSString stringWithFormat:@"￥%.2f",xiaoji];
}

@end
