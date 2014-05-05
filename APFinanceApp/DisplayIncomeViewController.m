//
//  DisplayViewController.m
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "DisplayIncomeViewController.h"
#import "AppDelegate.h"

@interface DisplayIncomeViewController ()

@end

@implementation DisplayIncomeViewController

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
    
    [[self dateField]setDelegate:self]; //setting the delegate as seld
    [self dateKeyboard];                //adding the datePicker to replace the keyboard
    
    UIImage *incomeImage = [UIImage imageNamed:@"income.png"];
    [logo setImage:incomeImage]; //set a logo into where the UIImage object is.

    dateFormat = [[NSDateFormatter alloc]init]; //a date formatter to format the date.
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    
    dateField.text = [dateFormat stringFromDate:[[self income]incomeDate]]; //set the UITextField with the incomeDate Variable with dateFormat
                                                                            //parsing the NSDate to NSString.
    
    categoryField.text = [[self income]incomeCategory]; //set the UITextField with the incomeCategory Variable
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle]; //sets the style as a decimal based style
    amountField.text = [numberFormat stringFromNumber:[[self income]incomeAmount]]; //set the UITextField with the incomeDate Variable with numberFormat
                                                                                    //parsing the NSNumber to NSString.
    
    UINavigationItem *navbar = self.navigationItem;
    navbar.title = categoryField.text; // set the navbar title as what the category is.
    
    
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startEditing:(id)sender {
    
    dateField.enabled = YES;        //Enabling the keyboard ability when you click the edit button
    categoryField.enabled = YES;    //as these fields are disabled to only display and not
    amountField.enabled = YES;      //edit.
    
    //displays the borders surrounding the UITextField as they are hidden by default
    dateField.borderStyle = UITextBorderStyleRoundedRect;
    categoryField.borderStyle = UITextBorderStyleRoundedRect;
    amountField.borderStyle = UITextBorderStyleRoundedRect;
    
    
    editButton.hidden = YES; //sets the button to hidden
    doneButton.hidden = NO;  //sets the button to be shown
    
}
- (IBAction)doneEditing:(id)sender {
    
    dateField.enabled = NO;        //Hides the keyboard ability when you click the save button
    categoryField.enabled = NO;    //as these fields are disabled to only display and not
    amountField.enabled = NO;      //edit.
    
    //hides the borders surrounding the UITextField
    dateField.borderStyle = UITextBorderStyleNone;
    categoryField.borderStyle = UITextBorderStyleNone;
    amountField.borderStyle = UITextBorderStyleNone;
    
    editButton.hidden = NO;     //sets the button to be shown
    doneButton.hidden = YES;    //sets the button to hidden
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    
    
    //If anything was edited - then the text field inputs below will be changed and saved.
    //If nothing was changed - then the values that were set before will still be there
    _income.incomeDate = [dateFormat dateFromString:[dateField text]];
    _income.incomeCategory = [categoryField text];
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    _income.incomeAmount = [numberFormat numberFromString:[amountField text]];
    
    //Since this class doesn't have a managed object context - we need to have a reference
    //to the App Delegate - which we will use the saveContext method to save the edited object.
    AppDelegate *appDel = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    [appDel saveContext]; //use the app delegate's saveContext method to save the edits.
    
    
    
}
@end
