//
//  OrderDetailTableCell.h
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *mingchenLabel;
@property (nonatomic, weak) IBOutlet UILabel *guigeLabel;
@property (nonatomic, weak) IBOutlet UILabel *shuliangLabel;
@property (nonatomic, weak) IBOutlet UILabel *danjiaLabel;
@property (nonatomic, weak) IBOutlet UILabel *zongjiaLabel;

- (void)reloadWithGouwucheModel:(DingdanShangpinModel *)dsm;

@end
