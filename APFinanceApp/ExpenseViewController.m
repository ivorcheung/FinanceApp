//
//  ExpenseViewController.m
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "ExpenseViewController.h"
#import "DisplayExpenseViewController.h"

@interface ExpenseViewController ()

@end

@implementation ExpenseViewController

@synthesize amountField, dateField, categoryField , dateFormat, dateOfInput, datePicker, managedObjectContext, logo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dateField.delegate = self;
    
    [self dateKeyboard];
    
    UIImage *logoImage = [UIImage imageNamed:@"scale.png"];
    [logo setImage:logoImage];
    
   dateFormat = [[NSDateFormatter alloc]init];
   [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    
    dateField.text = [dateFormat stringFromDate:[[self expense]expenseDate]];
    categoryField.text = [[self expense]expenseCategory];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    amountField.text = [numberFormat stringFromNumber:[[self expense]expenseAmount]];

}

-(UIDatePicker *) dateKeyboard //method to override keyboard and display date picker instead.
{
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[[self expense]expenseDate]];
    dateField.inputView = datePicker;
    dateField.inputAccessoryView = [self dateKeyboardBar];
    [datePicker addTarget:self action:@selector(settingDate) forControlEvents:UIControlEventValueChanged];
    
    return datePicker;
}


-(UIToolbar*)dateKeyboardBar {
    //Create and configure toolbar that holds "Done button"
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barTintColor = [UIColor colorWithRed:0.498 green:0.549 blue:0.553 alpha:1.0];
    [toolBar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Set"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(doneButtonPressed)];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, setButton, nil]];
    
    return toolBar;
}

-(void)doneButtonPressed {
    
    [dateField setText:[dateFormat stringFromDate:[datePicker date]]];
    [[self view]endEditing:YES];
    
}

-(void)settingDate{
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    dateOfInput = [datePicker date];
    dateField.text = [dateFormat stringFromDate:[datePicker date]];
    //format NSString of DateTextField to NSDate
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



 /*
 -(void)textFieldDidBeginEditing:(UITextField *)textField
 {
 
 if ([[amountField text]length] == 0){
amountField.text = [[NSLocale currentLocale]objectForKey:NSLocaleCurrencySymbol];
 }
 }
 
 -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 
 NSString *currencyPlaceholder = [amountField.text stringByReplacingCharactersInRange:range withString:string];
 
 if (![currencyPlaceholder hasPrefix:[[NSLocale currentLocale]objectForKey:NSLocaleCurrencySymbol]]) {
 return NO;
 }
 
 return YES;
 }*/


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)hideKeyboard:(id)sender {
    
    [dateField resignFirstResponder];
    [categoryField resignFirstResponder];
    [amountField resignFirstResponder];
}


-(IBAction)addExpense:(id)sender
{

    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    [[self expense]setExpenseDate:[dateFormat dateFromString:[dateField text]]];
    
    [[self expense]setExpenseCategory:[categoryField text]];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [[self expense]setExpenseAmount:[numberFormat numberFromString:[amountField text]]];
    
    [[self delegate]addExpenseViewControllerDidSave];

    
}

-(IBAction)cancel:(id)sender
{

    [[self delegate]addExpenseViewControllerDidCancel:[self expense]];
}

@end
