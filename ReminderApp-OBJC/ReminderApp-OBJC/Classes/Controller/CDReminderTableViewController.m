//
//  CDReminderTableViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderTableViewController.h"
#import "CDReminderCell.h"
#import "AppDelegate.h"
#import "CDReminder.h"
#import "CDEditReminderTableViewController.h"

@interface CDReminderTableViewController () <NSFetchedResultsControllerDelegate, CDReminderCellDelegate, UITextViewDelegate, CDAppDelegateNotificationHandlerDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;
@property (nonatomic, strong) CDReminder *reminderToEdit;
@property (nonatomic, assign) BOOL placeholder;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, assign) NSInteger minutesToSnooze;

@end

@implementation CDReminderTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.placeholder = YES;
	self.title = self.topic.title;
	self.minutesToSnooze = 0;
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44;
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	self.managedContext = appDelegate.managedObjectContext;
	
	appDelegate.delegate = self;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Could not perform a fetch for Reminder entity, an error occured: %@", error);
	}
	
}

/* This code, was meant to be executed in prepare for unwind, for some reason
   prepare for unwind doesn't trigger, or am i wrong?" */
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	if (self.reminderToEdit.taskDate) {
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", self.reminderToEdit, error);
		}
		
		[self scheduleNotification];
	}
	
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
	if ([segue.identifier isEqualToString:@"editToReminderUnwind"]) {
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", self.reminderToEdit, error);
		}
		
		[self scheduleNotification];
	}
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"CDReminderCellDetailButtonToEditScreen"]) {
		CDEditReminderTableViewController *editController = segue.destinationViewController ;
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
	
	[UIView setAnimationsEnabled:NO];
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
	[UIView setAnimationsEnabled:YES];
	
}

#pragma mark - CDAddReminderCellDelegate + CDReminderCellDelegate

- (void)reminderCell:(CDReminderCell *)reminderCell wantsToSaveReminder:(CDReminder *)reminder {
	
	NSError *error;
	if (![self.managedContext save:&error]) {
		NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", reminder, error);
	}
	
}

- (void)reminderCell:(CDReminderCell *)reminderCell wantsToResizeTextView:(UITextView *)textView {
	
	[UIView setAnimationsEnabled:NO];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	[UIView setAnimationsEnabled:YES];
	
}

- (void)reminderCell:(CDReminderCell *)cell wantsToEditReminder:(CDReminder *)reminder {
	
	self.reminderToEdit = reminder;
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	if (self.detailButton && textView.text.length != 0) {
		self.detailButton.hidden = NO;
	} else if (textView.text.length == 0) {
		self.detailButton.hidden = YES;
	}
	
	[UIView setAnimationsEnabled:NO];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	[UIView setAnimationsEnabled:YES];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		
		if (!self.placeholder) {
			[self footerTextView:textView wantsToAddReminderWithText:textView.text detailButtonWasPressed:NO];
			self.placeholder = YES;
			textView.text = @"Title";
			textView.textColor = [UIColor lightGrayColor];
		}
		
		return NO;
	}
	
	return YES;

}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	self.placeholder = NO;
	textView.text = @"";
	textView.textColor = [UIColor blackColor];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	
	/* Case: when user did begin editing but has not entered anything and attemtps to save - do nothing */
	if ([textView.text isEqualToString:@""]) {
		textView.text = @"Title";
		textView.textColor = [UIColor lightGrayColor];
		self.placeholder = YES;
	}
	self.detailButton.hidden = YES;

}

#pragma mark - Helper Methods for footer - textView logic + button action

- (void)footerTextView:(UITextView *)footerView wantsToAddReminderWithText:(NSString *)reminderText
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
	
}

- (void)detailButtonActionWithTextView {

	[self.textView resignFirstResponder];
	
	/* We do not attempt to save a reminder when in the addReminderCell text is the placeholder */
	if (!self.placeholder) {
		[self footerTextView:self.textView wantsToAddReminderWithText:self.textView.text detailButtonWasPressed:YES];
		self.placeholder = YES;
		self.textView.text = @"Title";
		self.textView.textColor = [UIColor lightGrayColor];
	}
	
}

- (void)applySettingsOnTextView:(UITextView *)textView {
	
	textView.layer.cornerRadius = 8;
	textView.scrollEnabled = NO;
	textView.text = @"Title";
	textView.textColor = [UIColor lightGrayColor];
	textView.delegate = self;
	
}

- (void)applyShadowOnView:(UIView *)view {
	
	view.layer.masksToBounds = NO;
	view.layer.cornerRadius = 3;
	view.layer.shadowOffset = CGSizeMake(0.0, -2.0);
	view.layer.shadowOpacity = 0.0;
	view.layer.shadowRadius = 5;
	view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
	view.backgroundColor = [UIColor whiteColor];

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	CGFloat scrollViewHeight = scrollView.frame.size.height;
	CGFloat contentYoffset = scrollView.contentOffset.y;
	CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
	
	/* Last visible cell is covered by the footer so we compare with visibleCells - 1 
	   This additional if, is for when we insert rows, this method is called in that case aswell */
	if (self.tableView.visibleCells.count - 1 < self.fetchedResultsController.fetchedObjects.count) {
		if (distanceFromBottom > scrollViewHeight) {
			self.footerView.layer.shadowOpacity = 0.2;
		} else {
			self.footerView.layer.shadowOpacity = 0.0;
		}
	} else {
		self.footerView.layer.shadowOpacity = 0.0;
	}
	
}

#pragma mark - CDAppDelegateNotificationHandlerDelegate

- (void)appDelegate:(AppDelegate *)appDelegate wantsToHandleNotificationActionWithIdentifier:(NSString *)identifier {
	
	if ([identifier isEqualToString:@"sv.ReminderApp-OBJC.deleteAction"]) {
		NSLog(@"Delete notification has been handled.");
		[self.managedContext deleteObject:self.reminderToEdit];
		
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"Could not delete a Reminder object:%@. \n An error occured: %@", self.reminderToEdit, error);
		}
	} else if([identifier isEqualToString:@"sv.ReminderApp-OBJC.snoozeAction"]) {
		NSLog(@"Snooze notification has been handled.");
		self.minutesToSnooze += 1;
		self.minutesToSnooze %= 60;
		
		[self scheduleNotification];
	}
	
}

#pragma mark - Local notification

- (void)scheduleNotification {
	
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	localNotification.fireDate = [self fixedNotificationDate];
	localNotification.alertBody = @"Hey, you have a reminder scheduled, remember?";
	localNotification.alertAction = @"Open reminder app";
	localNotification.category = @"reminderCategory";
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	
}

- (NSDate *)fixedNotificationDate {
	
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
																				NSCalendarUnitMonth |
																			    NSCalendarUnitYear |
																				NSCalendarUnitHour |
																				NSCalendarUnitMinute
																	   fromDate:self.reminderToEdit.taskDate];
	
	dateComponents.second = 0;
	dateComponents.minute += self.minutesToSnooze;
	
	NSDate *fixedDate = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
	
	return fixedDate;
	
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 44.0)];
	[self applyShadowOnView:self.footerView];
	
	UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(19.0, 8.0, 27.0, 27.0)];
	[plusButton setImage:[UIImage imageNamed:@"Pluse-128"] forState:UIControlStateNormal];
	[self.footerView addSubview:plusButton];
	
	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(61.0, 7.0, self.tableView.bounds.size.width - 100, 30.0) textContainer:nil];
	[self applySettingsOnTextView:self.textView];
	[self.footerView addSubview:self.textView];

	self.detailButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
	[self.detailButton setFrame:CGRectMake(self.textView.bounds.size.width + 69.0, 11.0, 22.0, 22.0)];
	[self.detailButton addTarget:self
					 action:@selector(detailButtonActionWithTextView)
		   forControlEvents:UIControlEventTouchUpInside];
	self.detailButton.hidden = YES;
	[self.footerView addSubview:self.detailButton];
	
	return self.footerView;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

	return 44.0;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return self.fetchedResultsController.sections.count;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	 
	return self.fetchedResultsController.sections[section].numberOfObjects;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CDReminderCell *reminderCell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];

	reminderCell.delegate = self;
	CDReminder *reminder = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[reminderCell updateWithReminder:reminder];
	
	return reminderCell;
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		CDReminder *reminderToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.managedContext deleteObject:reminderToDelete];
		
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"Could not delete a Reminder object:%@. \n An error occured: %@", reminderToDelete, error);
		}
	}

}

@end
