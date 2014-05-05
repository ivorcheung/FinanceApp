//
//  IncomeViewController.m
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "IncomeViewController.h"
#import "DisplayIncomeViewController.h"

@interface IncomeViewController ()

@end

@implementation IncomeViewController

@synthesize dateField, amountField, categoryField, datePicker, dateOfInput, dateFormat, managedObjectContext, logo;



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

    self.dateField.delegate = self; //adding the uitextfield delegate and declaring it as self.

    [self dateKeyboard]; //adding the dateKeyboard
    
    UIImage *logoImage = [UIImage imageNamed:@"scale.png"]; //setting the UIImage object.
    [logo setImage:logoImage];
    
    //setting the initial values of the textfields to the attributes.
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];

    dateField.text = [dateFormat stringFromDate:[[self income]incomeDate]];
    categoryField.text = [[self income]incomeCategory];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    amountField.text = [numberFormat stringFromNumber:[[self income]incomeAmount]];
}

//this code was heavily influenced from (Rea [Online] 2012).
-(UIDatePicker *) dateKeyboard //method to override keyboard and display date picker instead.
{
    
    datePicker = [[UIDatePicker alloc]init]; //allocating memory and initialising the datePicker
    datePicker.datePickerMode = UIDatePickerModeDate; // setting the date pickerMode to just date selection format
    [datePicker setDate:[[self income]incomeDate]]; //setting the default date of the picker to the income date (today's date by default)
    dateField.inputView = datePicker; //setting the dateField's keyboard as the datepicker
    dateField.inputAccessoryView = [self dateKeyboardBar]; //setting an accessory bar at the top of the datePicker
    [datePicker addTarget:self action:@selector(settingDate) forControlEvents:UIControlEventValueChanged];
    //the above method call specifies a target/action for the particular called event.
    //so if the date is chosen of another date - and the selector is chosed (settingDate method) - it will change the value of the dateField.
    
    return datePicker;
}

-(void)settingDate{ // method to set the date.
    
    dateFormat = [[NSDateFormatter alloc]init]; //using a date formatter to formate the date to string for dateField.
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    dateOfInput = [datePicker date];
    dateField.text = [dateFormat stringFromDate:[datePicker date]];
    
}

-(UIToolbar*)dateKeyboardBar {
    //Create and configure toolbar that holds "Set button" for adding the date to dateField
    UIToolbar *toolBar = [[UIToolbar alloc] init]; //allocate memory and initialise UIToolBar
    toolBar.barTintColor = [UIColor colorWithRed:0.498 green:0.549 blue:0.553 alpha:1.0]; //Converted UI Color - see acknowledgements.
    [toolBar sizeToFit]; //fits the toolbar to the size of the subview
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];      //initialise a BarButtonItem of a flexible space kind - this basically generates empty space.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Set"     //adding a BarButtonItem with the title "set" to set the date
                                                                   style:UIBarButtonItemStylePlain  //with a plain button style
                                                                  target:self                       //target of self object
                                                                  action:@selector(doneButtonPressed)]; //and it will trigger this method when it is pressed
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];   //set the following items onto the toolbar.
    
    return toolBar;
}

-(void)doneButtonPressed {
    
    [dateField setText:[dateFormat stringFromDate:[datePicker date]]];  //sets the datefield's text as the datepicker chosen date.
    [[self view]endEditing:YES];        //ends editing and dismisses the firstResponder - thus dismissing the datePicker
    
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
 }
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{  //these 2 methods dismiss the firstResponder for the textfiels - hence
                                                        //dismissing the keyboard. This method is a UITextFieldDelegate method
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)hideKeyboard:(id)sender {                   //Hidden button to dismiss keyboard if screen is pressed.
    
    [dateField resignFirstResponder];
    [categoryField resignFirstResponder];
    [amountField resignFirstResponder];
}




-(IBAction)addIncome:(id)sender //method to save the income object.
{

    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    [self.income setIncomeDate:[dateFormat dateFromString:[dateField text]]];
     
    [self.income setIncomeCategory:[categoryField text]];
    
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init]; //using a number format to parse number to
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.income setIncomeAmount:[numberFormat numberFromString:[amountField text]]];
    
    [[self delegate]addIncomeViewControllerDidSave]; //adding the delegate object to save the object

    
}

- (IBAction)cancel:(id)sender { //ensures that object isn't saved if cancelled.
    
    [[self delegate]addIncomeViewControllerDidCancel:[self income]];
    //using the delegate to cancel adding the object.
    
}

@end