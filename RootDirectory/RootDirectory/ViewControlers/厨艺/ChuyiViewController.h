//
//  ChuyiViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TrainingBean.h"


@interface ChuyiViewController : BaseViewController


@property (nonatomic,strong) IBOutlet UITableView* tv;
@property (nonatomic,strong) IBOutlet UIDatePicker* picker;
@property (nonatomic,strong) IBOutlet UIButton* dateBtn;
@property (nonatomic,strong) IBOutlet UIView* pickerView;
@property (nonatomic,copy) NSString* trainingTime;
@property (nonatomic,copy) NSString* page;
@property (nonatomic,strong) NSMutableArray* trainingArray;
@property (nonatomic,strong) UIImage* shareImage;
@property (nonatomic,copy) NSString* tId;



//-(IBAction)datePick:(id)sender;
-(IBAction)dateClick:(id)sender;
-(IBAction)allDateClick:(id)sender;
-(IBAction)showDateView:(id)sender;
-(IBAction)yueClick:(id)sender;


@end
