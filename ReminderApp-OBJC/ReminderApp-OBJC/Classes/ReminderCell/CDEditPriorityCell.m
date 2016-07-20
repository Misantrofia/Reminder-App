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

- (void)setupReminderWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	
}

- (IBAction)prioritySegmentedControllAction:(id)sender {
	
	switch (self.prioritySegmentedControl.selectedSegmentIndex) {
		case CDPriorityLow:
			self.reminder.priority = [NSNumber numberWithInteger:CDPriorityLow];
			break;
		case CDPriorityMedium:
			self.reminder.priority = [NSNumber numberWithInteger:CDPriorityMedium];
			break;
		case CDPriorityHigh:
			self.reminder.priority = [NSNumber numberWithInteger:CDPriorityHigh];
			break;
		case CDPriorityCritical:
			self.reminder.priority = [NSNumber numberWithInteger:CDPriorityCritical];
			break;
		default:
			break;
	}
	
}

@end
