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

@interface CDReminderTableViewController () <UITextViewDelegate, NSFetchedResultsControllerDelegate>

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
	
	self.managedContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Could not perform a fetch for Reminder entity, an error occured: %@", error);
	}
	
}

-(void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification object:nil];
	
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

#pragma mark - Helper methods

- (CGFloat)textViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITextView *calculationView = ((CDAddReminderCell *)[self.tableView cellForRowAtIndexPath:indexPath]).textView;
	CGFloat textViewWidth = calculationView.frame.size.width;
	
	if (!calculationView) {
		return 50;
	}

	CGSize size = [calculationView sizeThatFits:CGSizeMake(textViewWidth, FLT_MAX)];
	return size.height;
	
}

- (void)scrollToCursorForTextView:(UITextView *)textView {
	
	CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
	cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
	
	if (![self rectVisible:cursorRect]) {
		cursorRect.size.height += 8;
		[self.tableView scrollRectToVisible:cursorRect animated:YES];
	}
	
}

#pragma mark - Keyboard specific methods

- (BOOL)rectVisible:(CGRect)rect {
	
	CGRect visibleRect;
	visibleRect.origin = self.tableView.contentOffset;
	visibleRect.origin.y += self.tableView.contentInset.top;
	visibleRect.size = self.tableView.bounds.size;
	visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
	
	return CGRectContainsRect(visibleRect, rect);
	
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
	
	NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
	
	self.tableView.contentInset = contentInsets;
	self.tableView.scrollIndicatorInsets = contentInsets;
	
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
	
	self.tableView.contentInset = contentInsets;
	self.tableView.scrollIndicatorInsets = contentInsets;
	
	[UIView commitAnimations];
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	NSLog(@"Begin editing \n");
	[self scrollToCursorForTextView:textView];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	
	NSLog(@"End edititing \n");
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
	[self scrollToCursorForTextView:textView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.fetchedResultsController.sections[0].numberOfObjects inSection:0];
	CDAddReminderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		
		/* If we add a new reminder by using the last cell's textview, we create a new Reminder Instance
		   Afterwards we set the cell's text back to empty.
		 */
		if (cell.textView == textView){
			CDReminder *reminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedContext];
			reminder.taskName = textView.text;
			reminder.topic = self.topic;
			
			textView.text = @"";
			
			NSError *error;
			if (![self.managedContext save:&error]) {
				NSLog(@"Could not save a Reminder object:%@. \n An error occured: %@", reminder, error);
			}
		}else {
			
			/*
			 Case for Update cell
			 We acces the cell in which the textView is in by accesing it's superview.superview
			 Then we iterate through tableView's rows until we find the cell by computing indexPath with different row
			 Once we find its match, we break the loop and update its content
			 
			 OR: Can we pass somehow the event from the textView, to it's superview, way up to the cell. And then
			 we can get use of indexPathForSelectedRow? (like in the WWDC video with the gesture events)
			 */

			CDAddReminderCell *cellFromTextView = (CDAddReminderCell *)textView.superview.superview;
			
			for (int row = 0; row < ((int)self.fetchedResultsController.sections[0].numberOfObjects); row += 1) {
				NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
				if ([self.tableView cellForRowAtIndexPath:indexPath] == cellFromTextView) {
					CDReminder *reminderToUpdate = [self.fetchedResultsController objectAtIndexPath:indexPath];
					reminderToUpdate.taskName = textView.text;
					
					NSError *error;
					if (![self.managedContext save:&error]) {
						NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", reminderToUpdate, error);
					}
					
					break;
				}
			}
		}
		return NO;
	}
	
	return YES;
	
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
	if(self.tableView == scrollView) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[[self.tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
	}
	
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return [self textViewHeightForRowAtIndexPath:indexPath];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return self.fetchedResultsController.sections.count;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	/* We want to return the number of items in the database plus a temporary cell in which the user can add
	   another reminder when the cell its tapped */
	return self.fetchedResultsController.sections[section].numberOfObjects + 1;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CDReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
	
	if (cell) {
		if (indexPath.row < self.fetchedResultsController.sections[indexPath.section].numberOfObjects) {
			CDReminder *reminder = [self.fetchedResultsController objectAtIndexPath:indexPath];
			cell.textView.text = reminder.taskName;
		}
		cell.textView.delegate = self;
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
