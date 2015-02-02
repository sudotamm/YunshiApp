//
//  ShangpinTableCell.h
//  RootDirectory
//
//  Created by ryan on 2/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShangpinTableCellDelegate;

@interface ShangpinTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UILabel *guigeLabel;
@property (nonatomic, weak) IBOutlet UILabel *chandiLabel;
@property (nonatomic, weak) id<ShangpinTableCellDelegate> delegate;

- (IBAction)buyButtonClicked:(id)sender;
- (void)reloadWithShangpin:(ShangpinModel *)sm;

@end

@protocol ShangpinTableCellDelegate <NSObject>

- (void)didShangpinBuyWithCell:(ShangpinTableCell *)cell;

@end