//
//  IncomeViewController.h
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Income.h"
#import <CoreData/CoreData.h>


@protocol addIncomeViewControllerDelegate; //adding a delegate protocol to ensure that the tableViewController can dismiss or save items correctly.


@interface IncomeViewController : UIViewController <UITextFieldDelegate> //utilising the textfield delegate


//input fields for the date, category & amount.
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;

@property (nonatomic, weak) id <addIncomeViewControllerDelegate> delegate; //create an id object of something that is to be the delegate.


@property (nonatomic, strong) Income *income;

@property (nonatomic, strong) NSDate *dateOfInput;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIImageView *logo;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)hideKeyboard:(id)sender;
- (IBAction)addIncome:(id)sender;
- (IBAction)cancel:(id)sender;

@end

//adding the delegate methods.

@protocol addIncomeViewControllerDelegate

-(void)addIncomeViewControllerDidSave;
-(void)addIncomeViewControllerDidCancel:(Income *)incomeToDelete;

@end
