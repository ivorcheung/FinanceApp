//
//  FinanceTableViewController.m
//  basicFinance
//
//  Created by Ivor Cheung on 17/11/2013.
//  Copyright (c) 2013 Ivor Cheung. All rights reserved.
//

#import "IncomeTableViewController.h"
#import "DisplayIncomeViewController.h"

@interface IncomeTableViewController ()

@end

@implementation IncomeTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

//our own protocol/delegate methods

-(void) addIncomeViewControllerDidCancel:(Income *)incomeToDelete
{
    //telling the managedObjectContext to delete the object
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:incomeToDelete]; //uses the deleteObject method.
    
    //dismisses the view controller and puts it back to the initial view controller
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

-(void) addIncomeViewControllerDidSave
{
    //uses managedObjectContext to save. if it doesn't equal to managedObjectContext, it will return an error.
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (![context save:&error]) {   //if the save method doesn't work
        NSLog(@"Error! %@", error); //it will return an error.
    }
    
    //dismisses the view controller
    [[self navigationController]popToRootViewControllerAnimated:YES];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"addIncome"]) {
        IncomeViewController *ivc = (IncomeViewController *)[segue destinationViewController];
        ivc.delegate = self;
        
        Income *newIncome = (Income *)[NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:[self managedObjectContext]];
        
        ivc.income = newIncome;
    }
    
    //the above if statement checks if the segue identifier is equal to "addIncome" - if yes then IncomeViewController
    //will become the destination view controller - and will become its own delegate. We then create a new Income
    //object and it cast it so it will prepare a new managedObjectContext to prepare to save the object into the model.
    
    if ([[segue identifier]isEqualToString:@"showIncome"]) {
        DisplayIncomeViewController *dvc = (DisplayIncomeViewController *) [segue destinationViewController];
        NSIndexPath *indexPath = [[self tableView]indexPathForSelectedRow];
        Income *selectedIncome = (Income *) [[self fetchedResultsController]objectAtIndexPath:indexPath];
        dvc.income = selectedIncome;
        
    //if the segue identifier is equal to "showIncome" then the destination view controller will DisplayIncomeViewController
    //We set an index path for the chosen row of the table view - and cast an income object to fetch the results
    //with fetchResultsController at the chosen object at indexpath. This will display the results of the chosen row.
        
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
 
    // This code generates an error if the fetchedResultsController is not successful
    NSError *error = nil;
    if(![[self fetchedResultsController]performFetch:&error]){
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView //returns the number of sections for table view
{
    
    return [[[self fetchedResultsController]sections] count];
    //returns the fetchedResultsController (which is declared as an array) section's count.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    id <NSFetchedResultsSectionInfo> secInfo = [[[self fetchedResultsController]sections]objectAtIndex:section];

    return [secInfo numberOfObjects];
    
    //using an id called secInfo which has to adhere to the NSFetchedResultsSectionInfo protocol - which defines
    //the "interface" for the section. We declare secInfo as the fetchedResultsController sections objectAtIndex with
    //parameter of sectionm and then returns the number of objects in the secInfo.
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //this method creates the cells for the tableViewController. The above dequeueReusableCellWithIdentifier method
    //is used for memory management - which helps make the cells more responsive. It basically doesn't keep the cells in
    //memory after you scroll past it - effectively dequeuing them from memory.
    
    Income *inc = [[self fetchedResultsController]objectAtIndexPath:indexPath];
    //setting an income object and using the fetchedResultsController to fetch what is at the chosen index path
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    //above - a simple number format to format a number object into a string - shown below
    
    [[cell textLabel]setText:[inc incomeCategory]]; //sets the Category as the label
    [[cell detailTextLabel]setText:[numberFormat stringFromNumber:[inc incomeAmount]]]; //sets the amount as a detail label

    return cell;
}

//Helps create the table view header for the section.
//Code influenced from (pastebin [Online] 2012)

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

//the following sections are the NSFetchedResultsController delegate methods.

-(NSFetchedResultsController *) fetchedResultsController //method that returns an instance of the fetchedResultsController
{
    
    if (_fetchedResultsController != nil) { //if statement to check if the fetchedResultsController is empty?
        return _fetchedResultsController;   //if not empty - it will just return the fetchedResultsController
    }
    //boilerplate code snippet from iOS library.
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; //declare a new object of fetch request.
    
    //uses the entity description to get the Income entity
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Income" //adds the entity
                                              inManagedObjectContext:[self managedObjectContext]];
    
    
    [fetchRequest setEntity:entity]; //sets entity to the fetchRequest object.
    
    //create a sortDescriptor which basically sorts the results of with key of entity name and sets it to ascending.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"incomeDate"
                                                                   ascending:YES];
    //Declare an array object and fill it with the above sortDescriptor
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors]; //set the fetchRequest sortDescriptors with the array.
    
    //creating the fetchedResultsController and initialising it with this method:
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"incomeDate" cacheName:nil];
    
    _fetchedResultsController.delegate = self; //declares this object as the delegate.
    
    return _fetchedResultsController;
    
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView]beginUpdates]; //method calls that begins inserting/deleting/selecting the rows of the table view
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView]endUpdates];  //end methods to insert/delete/select of rows in a tableview
}


-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
//this method is another delegate method that notifies the FetchedResultsController that something is due to be updated/added/removed/moved

{
    UITableView *tableView = [self tableView]; //declare a temporary object just to make it easier when it is called.
    
    //switch statement for giving the results adhering to a particular change:
    
    switch (type) {
        case NSFetchedResultsChangeInsert: //if something is inserted
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break; //inserts a row at the newIndexPath array with an animation fade
            
        case NSFetchedResultsChangeDelete: //if something is deleted
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break; //deletes a row in the indexPath with an animation fade
        
        case NSFetchedResultsChangeUpdate:{ //if something is updated
            Income *inc = [[self fetchedResultsController]objectAtIndexPath:indexPath]; //declare an income object as the fetchedResultsController
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];        //for chosen indexpath cell
            
            NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc]init];
            [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
            //above - a simple number format to format a number object into a string - shown below
            
            [[cell textLabel]setText:[inc incomeCategory]]; //resets the Category as the label
            [[cell detailTextLabel]setText:[numberFormat stringFromNumber:[inc incomeAmount]]]; //resets the amount as a detail label
            
            
        } break;
            
        case NSFetchedResultsChangeMove: //changes and reorders - this is just implemented but not really used.
                                         //insert - inserts the object in a new indexPath, and delete - delets the object at indexPath
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade]; 
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type //delegate for if the section changes
{
    switch (type) {
        case NSFetchedResultsChangeInsert: //inserts the new section if a new one is created
            [[self tableView]insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        case NSFetchedResultsChangeDelete: //deletes the section if the object is deleted.
            [[self tableView]deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
        //this method is implemented in the table view delegate as well. It enables the swipe left to delete the row.

{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        Income *deletionIncome = [[self fetchedResultsController]objectAtIndexPath:indexPath];
        [context deleteObject:deletionIncome]; //uses object of the managed object context and income object. Then uses the fetchedResultsController
                                               //to find the object at the index path - and delete the object from the managedObjectContext.
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error! %@", error);
        }
        
    }    
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

// method declared to make any styling changes to the tableview header section
{
    
    UITableViewHeaderFooterView *headerFooter = (UITableViewHeaderFooterView *) view; //declare a new cast object of the UITableViewHeaderFooterView
    //headerFooter.textLabel.textColor = [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:1.0]; //change the font colour
    headerFooter.textLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:17.0]; //change the font size and type
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

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
