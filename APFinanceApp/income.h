//
//  income.h
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface income : NSObject

@property (nonatomic, strong) NSDate *date; //date of input
@property (nonatomic, strong) NSString *category; //category of input
@property (nonatomic, strong) NSNumber *amount; //amount of input
@property (nonatomic, strong) NSString *typeOfInput; //type of input

@property (nonatomic, strong) NSMutableArray *objectArray;

-(void)addItemsToArray;

@end
