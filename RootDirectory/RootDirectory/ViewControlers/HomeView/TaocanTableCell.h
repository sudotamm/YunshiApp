//
//  TaocanTableCell.h
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaocanTableCellDelegate;

@interface TaocanTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *indexLabel;
@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UILabel *youhuiLabel;
@property (nonatomic, weak) id<TaocanTableCellDelegate> delegate;

- (IBAction)buyButtonClicked:(id)sender;
- (void)reloadWithTaocan:(TaocanModel *)tm;

@end

@protocol TaocanTableCellDelegate <NSObject>

- (void)didTaocanBuyWithCell:(TaocanTableCell *)cell;

@end