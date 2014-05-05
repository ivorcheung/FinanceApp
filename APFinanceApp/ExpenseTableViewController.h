//
//  ExpenseTableViewController.h
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Expense.h"
#import "ExpenseViewController.h"

@interface ExpenseTableViewController : UITableViewController <addExpenseViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
