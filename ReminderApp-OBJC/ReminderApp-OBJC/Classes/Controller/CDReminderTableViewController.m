//
//  ViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 01/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderTableViewController.h"
#import "AppDelegate.h"
#import "CDReminder.h"

#pragma mark - Class extension

@interface CDReminderTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;

@end

#pragma mark - Class implementation

@implementation CDReminderTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.editButton.title = @"Edit";
	self.title = @"Reminder";
	
	self.managedContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"An error occured: %@", error);
	}
	
}

#pragma mark - Specific action buttons

- (IBAction)editTapped:(id)sender {

	if (self.tableView.editing) {
		self.editButton.title = @"Edit";
		self.tableView.editing = NO;
	} else {
		self.editButton.title = @"Back";
		self.tableView.editing = YES;
	}
	
}

- (IBAction)addTapped:(id)sender {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Reminder"
																   message:@"Add a new task with format \n \t ' Name - hh:mm'"
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction	*action) {
														   
														   NSString *textField = alert.textFields.firstObject.text;
														   NSArray<NSString *> *result = [textField componentsSeparatedByString:@"-"];
														   
														   if (result.count > 1) {
															   [self saveTask:result[0] taskHoure:result[1]];
														   }
														   
													   } ];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
														   style:UIAlertActionStyleDefault
														 handler:nil];
	
	[alert addTextFieldWithConfigurationHandler:nil];
	[alert addAction:saveAction];
	[alert addAction:cancelAction];
	
	[self presentViewController:alert animated:YES completion:nil];
	
}

#pragma mark - Helper func for addTapped

- (void) saveTask:(NSString *)taskName taskHoure:(NSString *)taskHoure {
	
	CDReminder *object = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedContext];
	object.taskName = taskName;
	object.taskHoure = taskHoure;
	
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {

	if (_fetchedResultsController == nil) {
		NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Reminder"];
		NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"taskName"
															   ascending:YES];
		
		fetch.sortDescriptors = @[sort];
		_fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch
																	   managedObjectContext:self.managedContext
																		 sectionNameKeyPath:nil
																				  cacheName:nil];
		_fetchedResultsController.delegate = self;
	}
	
	return _fetchedResultsController;
	
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView beginUpdates];
	
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			CDReminder *reminderItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
			cell.textLabel.text = reminderItem.taskName;
			cell.detailTextLabel.text = reminderItem.taskHoure;
		}
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
	
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView endUpdates];
	
}

#pragma mark - DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	
	return self.fetchedResultsController.sections.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return self.fetchedResultsController.sections[section].numberOfObjects;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SimpleReminderCell"];
	
	if (cell) {
		CDReminder *reminder = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
		cell.textLabel.text = reminder.taskName;
		cell.detailTextLabel.text = reminder.taskHoure;
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	  toIndexPath:(NSIndexPath *)destinationIndexPath {
	
	NSLog(@"MovedRow from row %ld, to row %ld", (long)sourceIndexPath.row, (long)destinationIndexPath.row);
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		CDReminder *reminderToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.managedContext deleteObject:reminderToDelete];
		
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"An error occured: %@", error.localizedDescription);
		}
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit Reminder"
																   message:@"Edit with format \n \t 'Name - hh:mm'"
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"Update"
														   style:UIAlertActionStyleDefault
														 handler:^(UIAlertAction *action) {
															 
															 NSString *inputText = alert.textFields.firstObject.text;
															 NSArray *components = [inputText componentsSeparatedByString:@"-"];
															 
															CDReminder *objectToUpdate = [self.fetchedResultsController objectAtIndexPath:indexPath];
															 if (components.count > 1) {
																objectToUpdate.taskName = [components objectAtIndex:0];
																objectToUpdate.taskHoure = [components objectAtIndex:1];
															 } else {
																 NSLog(@"IndexOutOfBounds");
															 }
														 
															 NSError *error;
															 if (![self.managedContext save:&error]) {
															 	NSLog(@"An error occured %@", error);
															 }
				
															 [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
															 
														 }];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
														   style:UIAlertActionStyleDefault
														 handler:nil];
	
	[alert addTextFieldWithConfigurationHandler:nil];
	
	[alert addAction:updateAction];
	[alert addAction:cancelAction];
	
	[self presentViewController:alert animated:YES completion:nil];
	
}

@end