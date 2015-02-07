//
//  RYDatePickerView.h
//  EHome
//
//  Created by Ryan Yuan on 6/13/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

/**
 *  Ryan自定义使用的日期picker
 */

#import <UIKit/UIKit.h>

@protocol RYDatePickerViewDelegate;

@interface RYDatePickerView : UIView

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) id<RYDatePickerViewDelegate> delegate;
#else
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) id<RYDatePickerViewDelegate> delegate;
#endif

- (IBAction)pickerCancelButtonClicked:(id)sender;
- (IBAction)pickerDoneButtonClicked:(id)sender;

/**
 *  重新加载date picker
 *
 *  @param date 选中的日期
 */
- (void)reloadWithDate:(NSDate *)date;

@end

@protocol RYDatePickerViewDelegate <NSObject>

- (void)didDateCanceledWithPicker:(RYDatePickerView *)pickerView;
- (void)didDateConfirmed:(NSDate *)date withPicker:(RYDatePickerView *)pickerView;

@end
