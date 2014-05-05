//
//  Income.h
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Income : NSManagedObject

@property (nonatomic, retain) NSNumber * incomeAmount;
@property (nonatomic, retain) NSString * incomeCategory;
@property (nonatomic, retain) NSDate * incomeDate;
@property (nonatomic, retain) NSData * incomePhoto; //unused variable

@end
