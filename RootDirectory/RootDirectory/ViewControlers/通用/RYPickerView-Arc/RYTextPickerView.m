//
//  RYTextPickerView.m
//  EHome
//
//  Created by Ryan Yuan on 6/13/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RYTextPickerView.h"

@interface RYTextPickerView()

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) NSArray *pickViewInputArray;
#else
@property (nonatomic, strong) NSArray *pickViewInputArray;
#endif

@end

@implementation RYTextPickerView

@synthesize titleLabel,textPicker;
@synthesize delegate;
@synthesize pickViewInputArray;

#pragma mark - Public methods
- (void)reloadData:(NSArray *)values defaultIndex:(NSInteger)index
{
    self.pickViewInputArray = [NSArray arrayWithArray:values];
    [self.textPicker reloadAllComponents];
    [self.textPicker selectRow:index inComponent:0 animated:NO];
}

- (IBAction)pickerCancelButtonClicked:(id)sender
{
    [self.delegate didTextCanceledWithPicker:self];
}

- (IBAction)pickerDoneButtonClicked:(id)sender
{
    NSInteger row = [self.textPicker selectedRowInComponent:0];
    NSString *strPrv = [self.pickViewInputArray objectAtIndex:row];
    [self.delegate didTextConfirmed:strPrv withPicker:self];
}

#pragma mark - UIView methods

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [pickViewInputArray release];
    [titleLabel release];[textPicker release];
    [super dealloc];
}
#endif

#pragma mark - UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickViewInputArray.count;
}

#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickViewInputArray objectAtIndex:row];
}
@end
