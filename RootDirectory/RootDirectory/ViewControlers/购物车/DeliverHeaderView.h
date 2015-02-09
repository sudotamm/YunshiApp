//
//  DeliverHeaderView.h
//  RootDirectory
//
//  Created by ryan on 2/9/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dianpuLabel;
@property (nonatomic, weak) IBOutlet UILabel *shijianLabel;

- (void)reloadWithDeliverModel:(DeliverModel *)dm;

@end
