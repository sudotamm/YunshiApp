//
//  CopyOrderCell.m
//  WoYou
//
//  Created by dong dong on 4/20/14.
//  Copyright (c) 2014 上海我有信息科技有限公司. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (IBAction)shengchengerweimaButtonClicked:(id)sender
{
    [self.delegate didGenerateQRCodeWithCell:self];
}


@end

