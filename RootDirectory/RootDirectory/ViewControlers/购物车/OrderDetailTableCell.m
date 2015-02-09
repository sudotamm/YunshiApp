//
//  OrderDetailTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "OrderDetailTableCell.h"

@implementation OrderDetailTableCell

- (void)reloadWithGouwucheModel:(DingdanShangpinModel *)dsm
{
    /*
     mingchenLabel;
     guigeLabel;
     shuliangLabel;
     danjiaLabel;
     zongjiaLabel;
     */
    self.mingchenLabel.text = dsm.gName;
    self.guigeLabel.text = dsm.spec;
    self.shuliangLabel.text = dsm.num;
    self.danjiaLabel.text = [NSString stringWithFormat:@"￥%@",dsm.price];
    self.zongjiaLabel.text = [NSString stringWithFormat:@"￥%@",dsm.totalprice];
}
@end
