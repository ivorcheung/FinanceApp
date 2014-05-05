//
//  AppDelegate.h
//  APFinanceApp
//
//  Created by Ivor Cheung on 28/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeTableViewController.h"
#import "ExpenseTableViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
