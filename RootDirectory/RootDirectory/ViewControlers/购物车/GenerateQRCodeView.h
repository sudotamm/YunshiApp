//
//  GenerateQRCodeView.h
//  RootDirectory
//
//  Created by ryan on 2/15/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenerateQRCodeView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *qrImageView;
@property (nonatomic, weak) IBOutlet UILabel *tip1Label;
@property (nonatomic, weak) IBOutlet UILabel *tip2Label;
@property (nonatomic, assign) BOOL returnHome;

- (void)reloadWithQRString:(NSString *)qrString;

- (IBAction)baocunButtonClicked:(id)sender;
- (IBAction)guanbiButtonClicked:(id)sender;

@end
