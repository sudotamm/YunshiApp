//
//  CopyOrderCell.h
//  WoYou
//
//  Created by dong dong on 4/20/14.
//  Copyright (c) 2014 上海我有信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KechengCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* addr;
@property (strong, nonatomic) IBOutlet UILabel* datetime;
@property (strong, nonatomic) IBOutlet UILabel* person;


@end
