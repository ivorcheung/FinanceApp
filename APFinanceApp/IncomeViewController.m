//
//  IncomeViewController.m
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "IncomeViewController.h"
#import "DisplayFinanceViewController.h"


@interface IncomeViewController ()

@end

@implementation IncomeViewController

@synthesize objectArray, dateOfInput, categoryOfInput, amountOfInput, incomeDate, incomeAmount, incomeCategory, datePicker, incomeTemporaryDate, dateFormat, managedObjectContext;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
}

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

    self.incomeDate.delegate = self;
    
    NSDate *today = [[NSDate alloc]init];
    today = [NSDate date]; //returns an instance type of NSDate for today's date
    
    [self dateKeyboard];
    
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"d MMM yyyy"];
    NSString *todayDate = [dateFormat stringFromDate:today];
    
    
    
    NSLog(@"Date = %@",todayDate);

    [incomeDate setText:todayDate];

}

-(UIDatePicker *) dateKeyboard //method to override keyboard and display date picker instead.
{
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    incomeDate.inputView = datePicker;
    incomeDate.inputAccessoryView = [self dateKeyboardBar];
    [datePicker addTarget:self action:@selector(settingDate) forControlEvents:UIControlEventValueChanged];
    
    return datePicker;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    incomeDate = textField;
    
    return YES;
}

/*

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ([[incomeAmount text]length] == 0){
        incomeAmount.text = [[NSLocale currentLocale]objectForKey:NSLocaleCurrencySymbol];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *currencyPlaceholder = [incomeAmount.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![currencyPlaceholder hasPrefix:[[NSLocale currentLocale]objectForKey:NSLocaleCurrencySymbol]]) {
        return NO;
    }
    
    return YES;
}
  */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
 
- (IBAction)hideKeyboard:(id)sender {
    
    [incomeDate resignFirstResponder];
    [incomeCategory resignFirstResponder];
    [incomeAmount resignFirstResponder];
}


-(UIToolbar*)dateKeyboardBar {
    //Create and configure toolbar that holds "Done button"
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    [toolBar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Date"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(doneButtonPressed)];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    return toolBar;
}

-(void)doneButtonPressed {
    
    [incomeDate setText:[dateFormat stringFromDate:[datePicker date]]];
    [[self view]endEditing:YES];
    
}

-(void)settingDate{
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"d MMM yyyy"];
    dateOfInput = [datePicker date];
    incomeDate.text = [dateFormat stringFromDate:[datePicker date]];
    incomeDate.placeholder = [dateFormat stringFromDate:[datePicker date]];
    //format NSString of DateTextField to NSDate
    
    }

/* boilerplate code from apple
- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}*/

-(IBAction)addFinanceObject:(id)sender {
    
    //format NSString of DateTextField to NSNumber
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *incomeTemporaryNumber = [numberFormat numberFromString:[incomeAmount text]];
    
    dateOfInput = [self dateOfInput];
    categoryOfInput = [incomeCategory text];
    amountOfInput = incomeTemporaryNumber;
    
    NSManagedObject *financeObject = [NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:[self managedObjectContext]];
    
    [financeObject setValue:dateOfInput forKey:@"incomeDate"];
    [financeObject setValue:categoryOfInput forKey:@"incomeCategory"];
    [financeObject setValue:amountOfInput forKey:@"incomeAmount"];
    
    
    //objectArray = [[NSMutableArray alloc]init];
    
    NSLog(@"Date = %@\nCategory = %@\nAmount = %@", dateOfInput, categoryOfInput, amountOfInput);
   
    
    
    
    
    
    //[[self navigationController]popToRootViewControllerAnimated:YES];
    
}

@end