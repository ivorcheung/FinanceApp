//
//  DisplayFinanceViewController.m
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "DisplayFinanceViewController.h"

@interface DisplayFinanceViewController ()

@end

@implementation DisplayFinanceViewController

@synthesize  dateLabel, categoryLabel, amountLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    
	IncomeViewController *ivc = [[IncomeViewController alloc]init];
    
    dateLabel.text = [ivc dateOfIncome];
    categoryLabel.text = [ivc categoryOfIncome];
    amountLabel.text = [ivc amountOfIncome];
    
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
