//
//  ExpenseTableViewController.m
//  APFinanceApp
//
//  Created by Ivor Cheung on 01/12/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "ExpenseTableViewController.h"
#import "DisplayExpenseViewController.h"


@interface ExpenseTableViewController ()

@end

@implementation ExpenseTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;


-(void) addExpenseViewControllerDidCancel:(Expense *)expenseToDelete
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:expenseToDelete];
    
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

-(void) addExpenseViewControllerDidSave
{
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (![context save:&error]) {
        NSLog(@"Error! %@", error);
    }
    
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"addExpense"]) {
        ExpenseViewController *evc = (ExpenseViewController *)[segue destinationViewController];
        evc.delegate = self;
        
        Expense *newExpense = (Expense *)[NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
        
        evc.expense = newExpense;
    }
    
    if ([[segue identifier]isEqualToString:@"showExpense"]) {
        DisplayExpenseViewController *dvc = (DisplayExpenseViewController *) [segue destinationViewController];
        NSIndexPath *indexPath = [[self tableView]indexPathForSelectedRow];
        Expense *selectedExpense = (Expense *) [[self fetchedResultsController]objectAtIndexPath:indexPath];
        dvc.expense = selectedExpense;
    }
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [[[self fetchedResultsController]sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> secInfo = [[[self fetchedResultsController]sections]objectAtIndex:section];
    
    
    return [secInfo numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Expense *exp = [[self fetchedResultsController]objectAtIndexPath:indexPath];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [[cell textLabel]setText:[exp expenseCategory]];
    [[cell detailTextLabel]setText:[numberFormat stringFromNumber:[exp expenseAmount]]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //declaring the section name as an NSString.
    NSString *dateString = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    //adding a date formatter to set the date format
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
    //using date formatter to parse string to date.
    NSDate *date = [formatter dateFromString:dateString];
    
    //then reparsing the date as a NSString..
    [formatter setDateFormat:@"dd MMMM yyyy"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    
    return formattedDate;
}

#pragma mark -
#pragma mark Fetched Results Controller section

-(NSFetchedResultsController *) fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expenseDate"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"expenseDate" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView]beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView]endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [self tableView];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:{
            Expense *exp = [[self fetchedResultsController]objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
            [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];

            [[cell textLabel]setText:[exp expenseCategory]];
            [[cell detailTextLabel]setText:[numberFormat stringFromNumber:[exp expenseAmount]]];
            
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView]insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView]deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        Expense *deletionExpense = [[self fetchedResultsController]objectAtIndexPath:indexPath];
        [context deleteObject:deletionExpense];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error! %@", error);
        }
        
    }
    
    
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
