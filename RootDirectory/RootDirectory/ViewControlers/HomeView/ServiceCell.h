//
//  ServiceCell.h
//  EHome
//
//  Created by ryan on 4/10/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *serviceIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *serviceNameLabel;

@property (nonatomic, weak) IBOutlet UIImageView *honLineImageView;
@property (nonatomic, weak) IBOutlet UIImageView *verLineImageView;
@property (nonatomic, weak) IBOutlet UIImageView *topHonLineImageView;


@end
