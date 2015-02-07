//
//  AddressTableCell.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressTableCellDelegate;

@interface AddressTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) id<AddressTableCellDelegate> delegate;

- (IBAction)editButtonClicked:(id)sender;
- (void)reloadWithAddressModel:(AddressModel *)am;

@end

@protocol AddressTableCellDelegate <NSObject>

- (void)didEditAddressWithCell:(AddressTableCell *)cell;

@end