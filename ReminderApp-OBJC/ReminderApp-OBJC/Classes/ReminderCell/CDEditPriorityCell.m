//
//  CDEditPriorityCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDEditPriorityCell.h"

@interface CDEditPriorityCell ()

@property (nonatomic, strong) CDReminder *reminder;

@end

@implementation CDEditPriorityCell

- (void)setupCellWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	self.prioritySegmentedControl.selectedSegmentIndex = self.reminder.priority.integerValue;
	
}

- (IBAction)prioritySegmentedControllAction:(id)sender {
	
	switch (self.prioritySegmentedControl.selectedSegmentIndex) {
		case CDPriorityLow:
			self.reminder.priority = @(CDPriorityLow);
			break;
		case CDPriorityMedium:
			self.reminder.priority = @(CDPriorityMedium);
			break;
		case CDPriorityHigh:
			self.reminder.priority = @(CDPriorityHigh);
			break;
		case CDPriorityCritical:
			self.reminder.priority = @(CDPriorityCritical);
			break;
		default:
			break;
	}
	
}

@end
