//
//  DeliverFooterView.h
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverFooterView : UIView

@property (nonatomic, weak) IBOutlet UILabel *xiaojiLabel;

- (void)reloadWithDeliverModel:(DeliverModel *)dm;

@end
