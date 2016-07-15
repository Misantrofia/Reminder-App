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

@interface CDReminderTableViewController () <NSFetchedResultsControllerDelegate, CDAddReminderCellDelegate, CDReminderCellDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;

@end

@implementation CDReminderTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.count = 1;
	
	self.title = self.topic.title;
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 100;
	
	self.managedContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Could not perform a fetch for Reminder entity, an error occured: %@", error);
	}
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
}

#pragma mark - Action methods for buttons

- (IBAction)detailAction:(id)sender {
	
	NSLog(@"Pam");
	
}

#pragma mark - NSFetchResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (_fetchedResultsController == nil) {
		NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reminder"];
		
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
		request.sortDescriptors = @[sortDescriptor];
		
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"topic.title LIKE %@", self.topic.title];
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
			CDAddReminderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			CDReminder *reminderItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
			cell.textLabel.text = reminderItem.taskName;
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

- (void)reminderCell:(CDReminderCell *)cell wantsToSaveReminder:(CDReminder *)reminder {
	
}

- (void)addReminderCell:(CDAddReminderCell *)cell wantsToAddReminder:(CDReminder *)reminder {
	
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	
//	/* This was just an example, adapt this to work properly for all the cases. Do the changes
//	 after the scrolling logic is removed.
//	*/
//	if(self.tableView == scrollView) {
//		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//		[[self.tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
//	}
//	
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return self.fetchedResultsController.sections.count;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	/* We want to return the number of items in the database plus a temporary cell in which the user can add
	   another reminder when the cell its tapped */
	return self.fetchedResultsController.sections[section].numberOfObjects + 1;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CDReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
	
	if (cell) {
		if (indexPath.row < self.fetchedResultsController.sections[indexPath.section].numberOfObjects) {
			CDReminder *reminder = [self.fetchedResultsController objectAtIndexPath:indexPath];
			cell.textView.text = reminder.taskName;
		}
		cell.delegate = self;
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
		if (indexPath.row < self.fetchedResultsController.sections[indexPath.section].numberOfObjects) {
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
