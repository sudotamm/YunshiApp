//
//  GouwucheTableCell.h
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GouwucheTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UIButton *jianButton;
@property (nonatomic, weak) IBOutlet UIButton *jiaButton;
@property (nonatomic, weak) IBOutlet UITextField *shuliangField;

- (IBAction)checkButtonClicked:(id)sender;
- (IBAction)jiaButtonClicked:(id)sender;
- (IBAction)jianButtonClicked:(id)sender;
- (void)reloadWithGouwucheModel:(GouwucheModel *)gm;

@end
