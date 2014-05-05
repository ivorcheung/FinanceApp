//
//  ViewController.h
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIButton *incomeButton;
@property (weak, nonatomic) IBOutlet UIButton *expenseButton;


@end
