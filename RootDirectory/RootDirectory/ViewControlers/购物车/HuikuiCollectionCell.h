//
//  HuikuiCollectionCell.h
//  RootDirectory
//
//  Created by ryan on 2/6/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HuikuiCollectionCellDelegate;

@interface HuikuiCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *yuanjiaLabel;
@property (nonatomic, weak) IBOutlet UILabel *huikuijiaLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, assign) id<HuikuiCollectionCellDelegate> delegate;

- (IBAction)checkButtonClicked:(id)sender;
- (void)reloadWithShangpinHuikui:(ShanginHuikuiModel *)shm;

@end

@protocol HuikuiCollectionCellDelegate <NSObject>

- (void)didCheckButtonClickedWithCell:(HuikuiCollectionCell *)huikuiCell;

@end