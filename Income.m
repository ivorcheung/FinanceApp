//
//  Income.m
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "Income.h"


@implementation Income

@dynamic incomeAmount;
@dynamic incomeCategory;
@dynamic incomeDate;
@dynamic incomePhoto; //unused object.

-(void)awakeFromInsert{
    [super awakeFromInsert];
    
    self.incomeDate = [NSDate date];
}

@end
