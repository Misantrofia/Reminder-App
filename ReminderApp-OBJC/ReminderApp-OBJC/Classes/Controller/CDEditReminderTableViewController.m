//
//  CDEditReminderTableViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDEditReminderTableViewController.h"
#import "CDEditReminderTextCell.h"
#import "CDEditRemindOnDayCell.h"
#import "CDEditPriorityCell.h"
#import "CDEditNotesTextCell.h"
#import "CDEditDatePickerCell.h"
#import "CDReminder.h"
#import "CDTopic.h"
#import "CDChangeTopicForReminder.h"

@interface CDEditReminderTableViewController () <CDEditReminderTextCellDelegate, CDEditNotesTextCellDelegate>

@property (nonatomic, assign) BOOL switchState;
@property (nonatomic, assign) BOOL alarmCellDropDown;
@property (nonatomic, strong) NSIndexPath *indexPathForAlarmCell;
@property (nonatomic, strong) NSIndexPath *indexPathForRepeatCell;
@property (nonatomic, strong) CDChangeTopicForReminder *changeTopicController;

@end

@implementation CDEditReminderTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.title = @"Details";
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 70;
	self.switchState = NO;
	self.alarmCellDropDown = NO;
	self.indexPathForAlarmCell = [NSIndexPath indexPathForRow:1 inSection:1];
	self.indexPathForRepeatCell = [NSIndexPath indexPathForRow:2 inSection:1];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"editScreenListCellTappedToChangeTopicForReminderScreen"]) {
		__weak CDEditReminderTableViewController *weakSelf = self;
		weakSelf.changeTopicController = segue.destinationViewController;
		weakSelf.changeTopicController.topic = self.reminder.topic;
		weakSelf.changeTopicController.changedTopic = ^(CDTopic *receivedTopic) {
			CDEditReminderTableViewController *strongSelf = weakSelf;
			strongSelf.reminder.topic = receivedTopic;
		};
	}
	
}

#pragma mark - Action button methods

- (IBAction)switchRemindOnDayButton:(id)sender {
	
	self.switchState = !self.switchState;

	if (self.switchState) {
		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:@[self.indexPathForAlarmCell] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView insertRowsAtIndexPaths:@[self.indexPathForRepeatCell] withRowAnimation:UITableViewRowAnimationBottom];
		if (!self.reminder.taskDate) {
			self.reminder.taskDate = [NSDate date];
		}
		[self.tableView endUpdates];
	} else {
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:@[self.indexPathForAlarmCell] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView deleteRowsAtIndexPaths:@[self.indexPathForRepeatCell] withRowAnimation:UITableViewRowAnimationBottom];
		if (self.alarmCellDropDown == YES) {
			self.alarmCellDropDown = !self.alarmCellDropDown;
			[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
		}
		self.reminder.taskDate = nil;
		[self.tableView endUpdates];
	}

}

#pragma mark CDEditReminderTextCellDelegate

-(void)editReminderTextCell:(CDEditReminderTextCell *)cell wantsToResizeTextView:(UITextView *)textView {
	
	[UIView setAnimationsEnabled:NO];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	[UIView setAnimationsEnabled:YES];
	
}

#pragma mark CDEditNotesTextCellDelegate

- (void)editNotesTextCell:(CDEditNotesTextCell *)cell wantsToResizeTextView:(UITextView *)textView {
	
	[UIView setAnimationsEnabled:NO];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	[UIView setAnimationsEnabled:YES];

}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 3;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 1 && self.switchState == YES && self.alarmCellDropDown == YES) {
		return 4;
	} else if (section == 1 && self.switchState == YES) {
		return 3;
	} else if (section == 2) {
		return 3;
	}
	
	return 1;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 1 && indexPath.row == 1) {
		self.alarmCellDropDown = !self.alarmCellDropDown;
		NSIndexPath *indexForDatePickerToInsert = [NSIndexPath indexPathForRow:2 inSection:1];
		
			if (self.alarmCellDropDown) {
				[self.tableView beginUpdates];
				[self.tableView insertRowsAtIndexPaths:@[indexForDatePickerToInsert] withRowAnimation:UITableViewRowAnimationFade];
				[self.tableView endUpdates];
				UITableViewCell *alarmCell = [tableView cellForRowAtIndexPath:indexPath];
				alarmCell.detailTextLabel.text = @"";
				
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				dateFormatter.dateStyle = kCFDateFormatterFullStyle;
				alarmCell.textLabel.text = [dateFormatter stringFromDate:self.reminder.taskDate];
				alarmCell.textLabel.textColor = [UIColor colorWithRed:0.25 green:0.50 blue:0.25 alpha:1.0];
			} else {
				[self.tableView beginUpdates];
				[self.tableView deleteRowsAtIndexPaths:@[indexForDatePickerToInsert] withRowAnimation:UITableViewRowAnimationFade];
				[self.tableView endUpdates];
				UITableViewCell *alarmCell = [tableView cellForRowAtIndexPath:indexPath];
				alarmCell.textLabel.text = @"Alarm";
				alarmCell.textLabel.textColor = [UIColor blackColor];
				
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				dateFormatter.dateStyle = NSDateFormatterMediumStyle;
				dateFormatter.dateFormat = @"EE dd/MM/yy hh:mm";
				alarmCell.detailTextLabel.text = [dateFormatter stringFromDate:self.reminder.taskDate];
			}
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 && indexPath.row == 0 ) {
		CDEditReminderTextCell *reminderTextCell = [tableView dequeueReusableCellWithIdentifier:@"reminderTextCell"
																				   forIndexPath:indexPath];
		[reminderTextCell setupCellWithReminder:self.reminder];
		reminderTextCell.delegate = self;
		return reminderTextCell;
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		CDEditRemindOnDayCell *remindOnDayCell = [tableView dequeueReusableCellWithIdentifier:@"remindOnDayCell"
																				 forIndexPath:indexPath];
		return remindOnDayCell;
	} else if (indexPath.section == 1 && indexPath.row == 1 &&
			   self.switchState == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"
																				forIndexPath:indexPath];
		[self updateContentForCell:alertAndReminderCell isAlert:YES];
		return alertAndReminderCell;
	} else if (indexPath.section == 1 && indexPath.row == 2 &&
			   self.switchState == YES && self.alarmCellDropDown == NO) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"
																				forIndexPath:indexPath];
		[self updateContentForCell:alertAndReminderCell isAlert:NO];
		return alertAndReminderCell;
	}  else if (indexPath.section == 1 && indexPath.row == 2 &&
				self.switchState == YES && self.alarmCellDropDown == YES) {
		CDEditDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell"
																			   forIndexPath:indexPath];
		
		[datePickerCell setupReminderWithReminder:self.reminder];
		return datePickerCell;
	} else if (indexPath.section == 1 && indexPath.row == 3 &&
			   self.switchState == YES && self.alarmCellDropDown == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"
																				forIndexPath:indexPath];
		
		[self updateContentForCell:alertAndReminderCell isAlert:NO];
		return alertAndReminderCell;
	} else if (indexPath.section == 2 && indexPath.row == 0) {
		CDEditPriorityCell *priorityCell = [tableView dequeueReusableCellWithIdentifier:@"priorityCell"
																		   forIndexPath:indexPath];
		[priorityCell setupCellWithReminder:self.reminder];
		return  priorityCell;
	} else if (indexPath.section == 2 && indexPath.row == 1) {
		UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"topicListCell"
																	forIndexPath:indexPath];
		listCell.detailTextLabel.text = self.reminder.topic.title;
		return listCell;
	} else if (indexPath.section == 2 && indexPath.row == 2) {
		CDEditNotesTextCell *notesCell = [tableView dequeueReusableCellWithIdentifier:@"notesCell"
																		 forIndexPath:indexPath];
		notesCell.delegate = self;
		[notesCell setupCellWithReminder:self.reminder];
		return notesCell;
	}

	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];

}

#pragma mark - Helper Method for Alert and Repeat Cells - Update Content

- (void)updateContentForCell:(UITableViewCell *)cell isAlert:(BOOL)alert {
	
	if (alert) {
		cell.textLabel.text = @"Alarm";
		cell.textLabel.textColor = [UIColor blackColor];
	
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		dateFormatter.dateFormat = @"EE dd/MM/yy hh:mm";
		cell.detailTextLabel.text = [dateFormatter stringFromDate:self.reminder.taskDate];
	} else {
		cell.textLabel.text = @"Repeat";
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.text = @"Never";
	}
	
}

@end
