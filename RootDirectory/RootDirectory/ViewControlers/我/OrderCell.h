//
//  CopyOrderCell.h
//  WoYou
//
//  Created by dong dong on 4/20/14.
//  Copyright (c) 2014 上海我有信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderCellDelegate;

@interface OrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* orderNo;
@property (weak, nonatomic) IBOutlet UILabel* datetime;
@property (weak, nonatomic) IBOutlet UILabel* price;
@property (nonatomic, weak) id<OrderCellDelegate> delegate;

- (IBAction)shengchengerweimaButtonClicked:(id)sender;

@end

@protocol OrderCellDelegate <NSObject>

- (void)didGenerateQRCodeWithCell:(OrderCell *)cell;

@end
