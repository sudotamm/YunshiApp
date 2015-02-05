//
//  ChuyiViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface ChuyiViewController : BaseViewController


@property (nonatomic,strong) IBOutlet UITableView* tv;
@property (nonatomic,strong) IBOutlet UIDatePicker* picker;
@property (nonatomic,strong) IBOutlet UIButton* dateBtn;
@property (nonatomic,strong) IBOutlet UIView* pickerView;


-(IBAction)datePick:(id)sender;
-(IBAction)dateClick:(id)sender;
-(IBAction)yueClick:(id)sender;


@end
