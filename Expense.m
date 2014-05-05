//
//  Expense.m
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "Expense.h"


@implementation Expense

@dynamic expenseAmount;
@dynamic expenseCategory;
@dynamic expenseDate;
@dynamic expensePhoto; //unused object


//creates an instance of NSDate date - which equals today's date
//with this method - as soon as it's started - it will assign
//today's date to the expenseDate object.

-(void)awakeFromInsert{
    [super awakeFromInsert];
    
    self.expenseDate = [NSDate date];
}

@end
