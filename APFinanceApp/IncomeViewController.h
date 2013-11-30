//
//  IncomeViewController.h
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseViewController.h"
#import <CoreData/CoreData.h>


@interface IncomeViewController : ExpenseViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *incomeDate;
@property (weak, nonatomic) IBOutlet UITextField *incomeCategory;
@property (weak, nonatomic) IBOutlet UITextField *incomeAmount;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)addFinanceObject:(id)sender;

@end
