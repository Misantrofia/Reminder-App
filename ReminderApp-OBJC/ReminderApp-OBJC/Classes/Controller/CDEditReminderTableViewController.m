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

@interface CDEditReminderTableViewController ()

@property (nonatomic, assign) BOOL switchState;
@property (nonatomic, strong) NSIndexPath *indexPathForAlarm;
@property (nonatomic, strong) NSIndexPath *indexPathForRepeat;

@end

@implementation CDEditReminderTableViewController

-(void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 70;
	self.switchState = NO;
	self.indexPathForAlarm = [NSIndexPath indexPathForRow:1 inSection:1];
	self.indexPathForRepeat = [NSIndexPath indexPathForRow:2 inSection:1];
	
}

#pragma mark - Action button methods

- (IBAction)switchRemindOnDayButton:(id)sender {
	
	self.switchState = !self.switchState;
	
	if (self.switchState) {
		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:@[self.indexPathForAlarm] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView insertRowsAtIndexPaths:@[self.indexPathForRepeat] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView endUpdates];
	} else {
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:@[self.indexPathForAlarm] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView deleteRowsAtIndexPaths:@[self.indexPathForRepeat] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView endUpdates];
	}
	
}

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

#pragma mark - TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0 && indexPath.section == 0 ) {
		CDEditReminderTextCell *reminderTextCell = [tableView dequeueReusableCellWithIdentifier:@"reminderTextCell"];
		reminderTextCell.textView.text = self.reminder.taskName;
		return reminderTextCell;
	} else if (indexPath.row == 0 && indexPath.section == 1) {
		CDEditRemindOnDayCell *remindOnDayCell = [tableView dequeueReusableCellWithIdentifier:@"remindOnDayCell"];
		return remindOnDayCell;
	} else if (indexPath.row == 1 && indexPath.section == 1 && self.switchState == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		return alertAndReminderCell;
	} else if (indexPath.row == 2 && indexPath.section == 1 && self.switchState == YES) {
		UITableViewCell *alertAndReminderCell = [tableView dequeueReusableCellWithIdentifier:@"alarmAndRepeatCell"];
		return alertAndReminderCell;
	} else if (indexPath.row == 0 && indexPath.section == 2) {
		CDEditPriorityCell *priorityCell = [tableView dequeueReusableCellWithIdentifier:@"priorityCell"];
		return  priorityCell;
	} else if (indexPath.row == 1 && indexPath.section == 2) {
		CDEditNotesTextCell *notesCell = [tableView dequeueReusableCellWithIdentifier:@"notesCell"];
		return notesCell;
	}

	return nil;

}

@end
