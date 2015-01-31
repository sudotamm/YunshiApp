//
//  FenleiSecondTableCell.m
//  RootDirectory
//
//  Created by ryan on 1/31/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "FenleiSecondTableCell.h"

@implementation FenleiSecondTableCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.arrowImgView.hidden = !selected;
}

@end
