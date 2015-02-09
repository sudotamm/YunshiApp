//
//  DeliverHeaderView.m
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "DeliverHeaderView.h"

@implementation DeliverHeaderView

- (void)reloadWithDeliverModel:(DeliverModel *)dm
{
    self.dianpuLabel.text = dm.sName;
    NSDate *date = [NSDate dateFromStringByFormat:@"yyyy-MM-dd HH:mm" string:dm.pickTime];
    NSString *dateStr = [NSDate dateToStringByFormat:@"MM/dd HH:mm" date:date];
    self.shijianLabel.text = dateStr;
}

@end
