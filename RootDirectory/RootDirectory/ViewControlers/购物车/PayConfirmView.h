//
//  PayConfirmView.h
//  RootDirectory
//
//  Created by ryan on 2/10/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayConfirmView : UIView

@property (nonatomic, weak) IBOutlet UIButton *alipayButton;
@property (nonatomic, weak) IBOutlet UIButton *userpayButton;

- (IBAction)alipayButtonClicked:(id)sender;
- (IBAction)userpayButtonClicked:(id)sender;
- (IBAction)querenButtonClicked:(id)sender;

- (void)reloadWithOrderPayType:(OrderPayType)payType;

@end
