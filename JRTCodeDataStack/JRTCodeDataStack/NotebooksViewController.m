//
//  NotebooksViewController.m
//  JRTCodeDataStack
//
//  Created by Juan Garcia on 2/18/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import "NotebooksViewController.h"
#import "Model.h"
#import "Notebook.h"

@interface NotebooksViewController ()

@end

@implementation NotebooksViewController

#pragma mark - Class

+ (instancetype)new {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Notebook entityName]];
    fetchRequest.sortDescriptors = @[
                                     [NSSortDescriptor sortDescriptorWithKey:FileAttributes.name ascending:YES],
                                     [NSSortDescriptor sortDescriptorWithKey:FileAttributes.modificationDate ascending:NO]
                                     ];
    
    NSFetchedResultsController *fetchedResultsController = [[Model sharedInstance] fetchedResultsControllerWithFetchRequest:fetchRequest];
    
    return [[self alloc] initWithFetchedResultsController:fetchedResultsController
                                                    style:UITableViewStylePlain];
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CoreData Example.";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                        action:@selector(addNotebook:)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Find Notebook
    Notebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //Make Cell
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    //Sync Cell and Notebook
    cell.textLabel.text = notebook.name;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:notebook.modificationDate];
    
    //Return Cell
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Find Notebook
        Notebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //Delete Model
        
        [[Model sharedInstance].context deleteObject:notebook];
//        [self.fetchedResultsController.managedObjectContext deleteObject:notebook];
    }
}

#pragma mark - Actions

- (void)addNotebook:(id)sender {
    // Create notebok
    [Notebook notebookWithName:@"New Notebook"
                       context:[Model sharedInstance].context];
}

@end
