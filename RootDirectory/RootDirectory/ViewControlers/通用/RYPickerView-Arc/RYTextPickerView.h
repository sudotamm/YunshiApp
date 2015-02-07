//
//  RYTextPickerView.h
//  EHome
//
//  Created by Ryan Yuan on 6/13/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

/**
 *  Ryan自定义使用的单行文字picker
 */

#import <UIKit/UIKit.h>

@protocol RYTextPickerViewDelegate;

@interface RYTextPickerView : UIView

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *textPicker;
@property (nonatomic, assign) id<RYTextPickerViewDelegate> delegate;
#else
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *textPicker;
@property (nonatomic, weak) id<RYTextPickerViewDelegate> delegate;
#endif

- (IBAction)pickerCancelButtonClicked:(id)sender;
- (IBAction)pickerDoneButtonClicked:(id)sender;

/**
 *  重新加载picker
 *
 *  @param values picker显示的数组
 *  @param index  picker默认选中的index
 */
- (void)reloadData:(NSArray *)values defaultIndex:(NSInteger)index;

@end

@protocol RYTextPickerViewDelegate <NSObject>

- (void)didTextCanceledWithPicker:(RYTextPickerView *)pickerView;
- (void)didTextConfirmed:(NSString *)textValue withPicker:(RYTextPickerView *)pickerView;

@end
