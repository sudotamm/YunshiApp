//
//  GouwuQingdanTableCell.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GouwuQingdanTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UITextField *shuliangField;
@property (nonatomic, weak) IBOutlet UIButton *zitiButton;
@property (nonatomic, weak) IBOutlet UIButton *yuyuezitiButton;
@property (nonatomic, weak) IBOutlet UIButton *zaipeiButton;

- (IBAction)zitiButtonClicked:(id)sender;
- (IBAction)yuyuezitiButtonClicked:(id)sender;
- (IBAction)zaipeiButtonClicked:(id)sender;

- (void)reloadWithGouwuQingdanModel:(id)gouwuQingdanModel;

@end
