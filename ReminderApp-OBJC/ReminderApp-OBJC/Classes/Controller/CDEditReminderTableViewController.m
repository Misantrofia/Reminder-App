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

@interface CDEditReminderTableViewController () <CDEditReminderTextCellDelegate, CDEditNotesTextCellDelegate>

@property (nonatomic, assign) BOOL switchState;
@property (nonatomic, assign) BOOL alarmCellDropDown;
@property (nonatomic, strong) NSIndexPath *indexPathForAlarmCell;
@property (nonatomic, strong) NSIndexPath *indexPathForRepeatCell;

@end

@implementation CDEditReminderTableViewController

-(void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 70;
	self.switchState = NO;
	self.alarmCellDropDown = NO;
	self.indexPathForAlarmCell = [NSIndexPath indexPathForRow:1 inSection:1];
	self.indexPathForRepeatCell = [NSIndexPath indexPathForRow:2 inSection:1];
	
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
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
}

#pragma mark CDEditNotesTextCellDelegate

- (void)editNotesTextCell:(CDEditNotesTextCell *)cell wantsToResizeTextView:(UITextView *)textView {
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];

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
		return 2;
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
		CDEditReminderTextCell *reminderTextCell = [tableView dequeueReusableCellWithIdentifier:@"reminderTextCell"];
		
		if (reminderTextCell) {
			reminderTextCell.textView.text = self.reminder.taskName;
			reminderTextCell.delegate = self;
			[reminderTextCell setupReminderWithReminder:self.reminder];
			return reminderTextCell;
		}
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		CDEditRemindOnDayCell *remindOnDayCell = [tableView dequeueReusableCellWithIdentifier:@"remindOnDayCell"];
		
		if (remindOnDayCell) {
			return remindOnDayCell;
		}
	} else if (indexPath.section == 1 && indexPath.row == 1 && self.switchState == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		
		if (alertAndReminderCell) {
			alertAndReminderCell.textLabel.text = @"Alarm";
			alertAndReminderCell.textLabel.textColor = [UIColor blackColor];
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			dateFormatter.dateStyle = NSDateFormatterMediumStyle;
			dateFormatter.dateFormat = @"EE dd/MM/yy hh:mm";
			alertAndReminderCell.detailTextLabel.text = [dateFormatter stringFromDate:self.reminder.taskDate];
			return alertAndReminderCell;
		}
	} else if (indexPath.section == 1 && indexPath.row == 2 &&  self.switchState == YES && self.alarmCellDropDown == NO) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		
		if (alertAndReminderCell) {
			alertAndReminderCell.textLabel.text = @"Repeat";
			alertAndReminderCell.textLabel.textColor = [UIColor blackColor];
			alertAndReminderCell.detailTextLabel.text = @"Never";
			return alertAndReminderCell;
		}
	}  else if (indexPath.section == 1 && indexPath.row == 2 && self.switchState == YES && self.alarmCellDropDown == YES) {
		CDEditDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell"];
		
		if (datePickerCell) {
			[datePickerCell setupReminderWithReminder:self.reminder];
			datePickerCell.datePicker.date = self.reminder.taskDate;
			return datePickerCell;
		}
	} else if (indexPath.section == 1 && indexPath.row == 3 && self.switchState == YES && self.alarmCellDropDown == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		
		if (alertAndReminderCell) {
			alertAndReminderCell.textLabel.text = @"Repeat";
			alertAndReminderCell.textLabel.textColor = [UIColor blackColor];
			alertAndReminderCell.detailTextLabel.text = @"Never";
			return alertAndReminderCell;
		}
	} else if (indexPath.section == 2 && indexPath.row == 0) {
		CDEditPriorityCell *priorityCell = [tableView dequeueReusableCellWithIdentifier:@"priorityCell"];
		
		if (priorityCell) {
			priorityCell.prioritySegmentedControl.selectedSegmentIndex = self.reminder.priority.integerValue;
			[priorityCell setupReminderWithReminder:self.reminder];
			return  priorityCell;
		}
	} else if (indexPath.section == 2 && indexPath.row == 1) {
		CDEditNotesTextCell *notesCell = [tableView dequeueReusableCellWithIdentifier:@"notesCell"];
		
		if (notesCell) {
			notesCell.noteTextView.text = self.reminder.note;
			notesCell.delegate = self;
			[notesCell setupReminderWithReminder:self.reminder];
			return notesCell;
		}
	}

	return nil;

}

@end
