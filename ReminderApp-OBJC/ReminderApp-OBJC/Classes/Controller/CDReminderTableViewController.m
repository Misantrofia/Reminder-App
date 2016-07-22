//
//  CDReminderTableViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderTableViewController.h"
#import "CDAddReminderCell.h"
#import "CDReminderCell.h"
#import "AppDelegate.h"
#import "CDReminder.h"
#import "CDEditReminderTableViewController.h"

@interface CDReminderTableViewController () <NSFetchedResultsControllerDelegate, CDAddReminderCellDelegate, CDReminderCellDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;
@property (nonatomic, strong) CDReminder *reminderToEdit;

@end

@implementation CDReminderTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.count = 1;
	
	self.title = self.topic.title;
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44;
	
	self.managedContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Could not perform a fetch for Reminder entity, an error occured: %@", error);
	}
	
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
	if ([segue.identifier isEqualToString:@"editToReminderUnwind"]) {
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", self.reminderToEdit, error);
		}
	}
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"CDReminderCellDetailButtonToEditScreen"]) {
		CDEditReminderTableViewController *editController = segue.destinationViewController;
		editController.reminder = self.reminderToEdit;
		[self.tableView resignFirstResponder];
	}
	
}

#pragma mark - NSFetchResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (_fetchedResultsController == nil) {
		NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reminder"];
		
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
		request.sortDescriptors = @[sortDescriptor];
		
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"topic == %@", self.topic];
		request.predicate = pred;
		
		_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
		_fetchedResultsController.delegate = self;
	}
	
	return _fetchedResultsController;
	
}

#pragma mark - NSFetchResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView beginUpdates];
	
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
	switch (type) {
  		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			CDReminderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			CDReminder *reminderItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
			[self.tableView setNeedsUpdateConstraints];
			[cell updateWithReminder:reminderItem];
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			}
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
	
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView endUpdates];
	
}

#pragma mark - CDAddReminderCellDelegate + CDReminderCellDelegate

- (void)reminderCell:(CDReminderCell *)reminderCell wantsToSaveReminder:(CDReminder *)reminder {
	
	NSError *error;
	if (![self.managedContext save:&error]) {
		NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", reminder, error);
	}
	
}

- (void)reminderCell:(CDReminderCell *)reminderCell wantsToResizeTextView:(UITextView *)textView {
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
}

- (void)reminderCell:(CDReminderCell *)cell wantsToEditReminder:(CDReminder *)reminder {
	
	self.reminderToEdit = reminder;
	
}

- (void)addReminderCell:(CDAddReminderCell *)addRemindercell wantsToAddReminderWithText:(NSString *)reminderText
		detailButtonWasPressed:(BOOL)detailButton{
	
	CDReminder *newReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedContext];
	newReminder.topic = self.topic;
	newReminder.taskName = reminderText;
	
	if (detailButton) {
		self.reminderToEdit = newReminder;
		[self performSegueWithIdentifier:@"CDReminderCellDetailButtonToEditScreen" sender:self];
	}
	
	NSError *error;
	if (![self.managedContext save:&error]) {
		NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", newReminder, error);
	}
	
	NSIndexPath *indexPath = [self.tableView indexPathForCell:addRemindercell];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	
}

- (void)addReminderCell:(CDAddReminderCell *)addRemindercell wantsToResizeTextView:(UITextView *)textView {
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return self.fetchedResultsController.sections.count;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	/* We want to return the number of items in the database plus a temporary cell in which the user can add
	   another reminder when the cell its tapped */
	return self.fetchedResultsController.sections[section].numberOfObjects + 1;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < self.fetchedResultsController.sections[indexPath.section].numberOfObjects) {
		CDReminderCell *reminderCell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];

		reminderCell.delegate = self;
		CDReminder *reminder = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[reminderCell updateWithReminder:reminder];
		return reminderCell;
	} else {
		CDAddReminderCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"AddReminderCell" forIndexPath:indexPath];
		addCell.delegate = self;
		return addCell;
	}
	
	return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	  toIndexPath:(NSIndexPath *)destinationIndexPath {
	
	NSLog(@"MovedRow from row %ld, to row %ld", (long)sourceIndexPath.row, (long)destinationIndexPath.row);
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < self.fetchedResultsController.sections[indexPath.section].numberOfObjects) {
		return YES;
	}
	
	return NO;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[CDReminderCell class]]) {
			CDReminder *reminderToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
			[self.managedContext deleteObject:reminderToDelete];
			
			NSError *error;
			if (![self.managedContext save:&error]) {
				NSLog(@"Could not delete a Reminder object:%@. \n An error occured: %@", reminderToDelete, error);
			}
		}
	}
	
}

@end
