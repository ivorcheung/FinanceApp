//
//  Expense.h
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Expense : NSManagedObject

@property (nonatomic, retain) NSNumber * expenseAmount;
@property (nonatomic, retain) NSString * expenseCategory;
@property (nonatomic, retain) NSDate * expenseDate;
@property (nonatomic, retain) NSData * expensePhoto; //unused variable

@end
