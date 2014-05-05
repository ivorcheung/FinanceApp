//
//  DisplayExpenseViewController.m
//  APFinanceApp
//
//  Created by Ivor Cheung on 02/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "DisplayExpenseViewController.h"
#import "AppDelegate.h"

@interface DisplayExpenseViewController ()

@end

@implementation DisplayExpenseViewController

@synthesize dateField, categoryField, amountField, editButton, doneButton, dateFormat, dateOfInput, datePicker, logo;

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
    
    [[self dateField]setDelegate:self];
    [self dateKeyboard];
    
    UIImage *expenseImage = [UIImage imageNamed:@"expense.png"];
    [logo setImage:expenseImage];
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    
    dateField.text = [dateFormat stringFromDate:[[self expense]expenseDate]];
    
    categoryField.text = [[self expense]expenseCategory];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    amountField.text = [numberFormat stringFromNumber:[[self expense]expenseAmount]];
    
    UINavigationItem *navbar = self.navigationItem;
    navbar.title = categoryField.text;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//this code was heavily influenced from (Rea [Online] 2012).
-(UIDatePicker *) dateKeyboard //method to override keyboard and display date picker instead.
{
    
    datePicker = [[UIDatePicker alloc]init]; //allocating memory and initialising the datePicker
    datePicker.datePickerMode = UIDatePickerModeDate; // setting the date pickerMode to just date selection format
    [datePicker setDate:[[self expense]expenseDate]]; //setting the default date of the picker to the income date (today's date by default)
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
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Set"     //adding a BarButtonItem with the title "set" to set the date
                                                                  style:UIBarButtonItemStylePlain  //with a plain button style
                                                                 target:self                       //target of self object
                                                                 action:@selector(doneButtonPressed)]; //and it will trigger this method when it is pressed
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, setButton, nil]];   //set the following items onto the toolbar.
    
    return toolBar;
}

-(void)doneButtonPressed {
    
    [dateField setText:[dateFormat stringFromDate:[datePicker date]]];  //sets the datefield's text as the datepicker chosen date.
    [[self view]endEditing:YES];        //ends editing and dismisses the firstResponder - thus dismissing the datePicker
    
}


- (IBAction)startEditing:(id)sender {
    
    dateField.enabled = YES;
    categoryField.enabled = YES;
    amountField.enabled = YES;
    
    dateField.borderStyle = UITextBorderStyleRoundedRect;
    categoryField.borderStyle = UITextBorderStyleRoundedRect;
    amountField.borderStyle = UITextBorderStyleRoundedRect;
    
    editButton.hidden = YES;
    doneButton.hidden = NO;
    
}
- (IBAction)doneEditing:(id)sender {
    
    dateField.enabled = NO;
    categoryField.enabled = NO;
    amountField.enabled = NO;
    
    dateField.borderStyle = UITextBorderStyleNone;
    categoryField.borderStyle = UITextBorderStyleNone;
    amountField.borderStyle = UITextBorderStyleNone;
    
    editButton.hidden = NO;
    doneButton.hidden = YES;
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    
    _expense.expenseDate = [dateFormat dateFromString:[dateField text]];
    _expense.expenseCategory = [categoryField text];
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    _expense.expenseAmount = [numberFormat numberFromString:[amountField text]];
    
    
    AppDelegate *appDel = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    [appDel saveContext];
    
}
@end
