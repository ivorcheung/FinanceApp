//
//  DisplayViewController.h
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Income.h"

@interface DisplayIncomeViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Income *income;

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;

@property (nonatomic, strong) NSDate *dateOfInput;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIImageView *logo;


@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)startEditing:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneEditing:(id)sender;

@end
