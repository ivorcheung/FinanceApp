//
//  ExpenseViewController.h
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "expense.h"
#import <CoreData/CoreData.h>

@protocol addExpenseViewControllerDelegate;

@interface ExpenseViewController: UIViewController <UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;

@property (nonatomic, weak) id <addExpenseViewControllerDelegate> delegate;

@property (nonatomic, strong) Expense *expense;

@property (nonatomic, strong) NSDate *dateOfInput;

@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)hideKeyboard:(id)sender;
- (IBAction)addExpense:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol addExpenseViewControllerDelegate

-(void)addExpenseViewControllerDidSave;
-(void)addExpenseViewControllerDidCancel:(Expense *)expenseToDelete;

@end