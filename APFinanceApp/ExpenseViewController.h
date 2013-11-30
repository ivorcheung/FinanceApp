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

@interface ExpenseViewController : UIViewController <UITextFieldDelegate>

{
    
}

//Outlets for the input
@property (weak, nonatomic) IBOutlet UITextField *inputDate;
@property (weak, nonatomic) IBOutlet UITextField *inputCategory;
@property (weak, nonatomic) IBOutlet UITextField *inputAmount;

//variables for the input
@property (nonatomic, strong) NSDate *dateOfInput;
@property (nonatomic, strong) NSString *categoryOfInput;
@property (nonatomic, strong) NSNumber *amountOfInput;
@property (nonatomic, strong) NSString *typeOfInput;

@property (nonatomic, strong) NSMutableArray *objectArray;

@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (nonatomic, strong) NSDate *incomeTemporaryDate;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
