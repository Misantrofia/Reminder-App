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
@property (nonatomic, strong) NSIndexPath *indexPathForAlarmCell;
@property (nonatomic, strong) NSIndexPath *indexPathForRepeatCell;

@end

@implementation CDEditReminderTableViewController

-(void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 70;
	self.switchState = NO;
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
		[self.tableView endUpdates];
	} else {
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:@[self.indexPathForAlarmCell] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView deleteRowsAtIndexPaths:@[self.indexPathForRepeatCell] withRowAnimation:UITableViewRowAnimationBottom];
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
	
	if (section == 1 && self.switchState == YES) {
		return 3;
	}
	
	if (section == 2) {
		return 2;
	}
	
	return 1;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0 && indexPath.section == 0 ) {
		CDEditReminderTextCell *reminderTextCell = [tableView dequeueReusableCellWithIdentifier:@"reminderTextCell"];
		
		if (reminderTextCell) {
			reminderTextCell.textView.text = self.reminder.taskName;
			reminderTextCell.delegate = self;
			[reminderTextCell setupReminderWithReminder:self.reminder];
			return reminderTextCell;
		}
	} else if (indexPath.row == 0 && indexPath.section == 1) {
		CDEditRemindOnDayCell *remindOnDayCell = [tableView dequeueReusableCellWithIdentifier:@"remindOnDayCell"];
		
		if (remindOnDayCell) {
			return remindOnDayCell;
		}
	} else if (indexPath.row == 1 && indexPath.section == 1 && self.switchState == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		
		if (alertAndReminderCell) {
			alertAndReminderCell.textLabel.text = @"Alarm";
			return alertAndReminderCell;
		}
	} else if (indexPath.row == 2 && indexPath.section == 1 && self.switchState == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		
		if (alertAndReminderCell) {
			alertAndReminderCell.textLabel.text = @"Repeat";
			return alertAndReminderCell;
		}
	} else if (indexPath.row == 0 && indexPath.section == 2) {
		CDEditPriorityCell *priorityCell = [tableView dequeueReusableCellWithIdentifier:@"priorityCell"];
		
		if (priorityCell) {
			priorityCell.prioritySegmentedControl.selectedSegmentIndex = self.reminder.priority.integerValue;
			[priorityCell setupReminderWithReminder:self.reminder];
			return  priorityCell;
		}
	} else if (indexPath.row == 1 && indexPath.section == 2) {
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
