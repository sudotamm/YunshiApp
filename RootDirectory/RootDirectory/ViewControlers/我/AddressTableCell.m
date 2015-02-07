//
//  AddressTableCell.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "AddressTableCell.h"

@implementation AddressTableCell

- (IBAction)editButtonClicked:(id)sender
{
    [self.delegate didEditAddressWithCell:self];
}

- (void)reloadWithAddressModel:(AddressModel *)am
{
    if([am.isDefault integerValue] == 1)
        self.checkButton.selected = YES;
    else
        self.checkButton.selected = NO;
    self.topLabel.text = [NSString stringWithFormat:@"%@   %@",am.contactor,am.phoneNum];
    self.bottomLabel.text = am.addr;
}

@end
