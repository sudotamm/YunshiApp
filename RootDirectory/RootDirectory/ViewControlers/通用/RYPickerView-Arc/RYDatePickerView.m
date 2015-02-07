//
//  RYDatePickerView.m
//  EHome
//
//  Created by Ryan Yuan on 6/13/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RYDatePickerView.h"

@interface RYDatePickerView()

@end

@implementation RYDatePickerView

@synthesize titleLabel,datePicker;
@synthesize delegate;

#pragma mark - Public methods
- (void)reloadWithDate:(NSDate *)date
{
    [self.datePicker setDate:date];
}

- (IBAction)pickerCancelButtonClicked:(id)sender
{
    [self.delegate didDateCanceledWithPicker:self];
}

- (IBAction)pickerDoneButtonClicked:(id)sender
{
    [self.delegate didDateConfirmed:self.datePicker.date withPicker:self];
}

#pragma mark - UIView methods

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [titleLabel release];[datePicker release];
    [super dealloc];
}
#endif
@end
