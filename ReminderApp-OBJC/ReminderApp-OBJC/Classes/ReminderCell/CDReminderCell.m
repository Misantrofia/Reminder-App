//
//  CDReminderCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 12/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderCell.h"
#import "CDAddReminderCell.h"

@interface CDReminderCell () <UITextViewDelegate>

@property (nonatomic, strong) CDReminder *reminder;

@end

@implementation CDReminderCell

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.textView.delegate = self;
	self.textView.textContainerInset = UIEdgeInsetsZero;
	self.textView.textContainer.lineFragmentPadding = 0;
	[self setConstraintPriorityForSimpleCell];
	
}

- (void)updateWithReminder:(CDReminder *)reminder {

	self.reminder = reminder;
	self.textView.text = self.reminder.taskName;
	self.noteLabel.text = self.reminder.note;
	self.priorityLabel.text = CDPriorityStringRepresentationForPriority(self.reminder.priority.integerValue);
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
	self.dateLabel.text = [dateFormatter stringFromDate:self.reminder.taskDate];
	
	[self changePrioritiesForReminder:self.reminder];
	
}

#pragma mark Change Outlet Priorities Methods

- (void)changePrioritiesForReminder:(CDReminder *)reminder {
	
	if (!reminder.taskDate && !reminder.note &&
		reminder.priority.integerValue == CDPriorityLow) {
		[self setConstraintPriorityForSimpleCell];
	}
 
	if (reminder.priority.integerValue != CDPriorityLow) {
		[self setConstraintPriorityForPriorityAttribute];
	} else {
		self.textView.textContainerInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
		self.priorityLabel.alpha = 0;
	}

	if (reminder.taskDate && (!reminder.note || [reminder.note isEqualToString:@""])) {
		[self setConstraintPriorityForSimpleCellPlusDate];
	} else if (reminder.taskDate && reminder.note) {
		[self setConstraintPriorityForSimpleCellPlusDateAndNote];
	} else if (!reminder.taskDate && reminder.note) {
		[self setConstraintPriorityForSimpleCellPlusNote];
	}
	
}

#pragma mark - Helper Methods for changing priorities

- (void)setConstraintPriorityForSimpleCell {
	
	self.textViewToCellBottom.priority = 999;
	self.textViewToCellBottom.constant = 2;
	
	self.textViewToNoteBottomConstraint.priority = 800;
	self.textViewToDateBottomConstraint.priority = 800;
	self.dateToNote.priority = 800;
	self.dateToCellBottom.priority = 800;
	self.noteToBottomCell.priority = 800;
	
	self.dateLabel.alpha = 0;
	self.noteLabel.alpha = 0;
	
	[self.contentView layoutIfNeeded];

}

- (void)setConstraintPriorityForSimpleCellPlusDate {
	
	self.textViewToDateBottomConstraint.priority = 999;
	self.dateToCellBottom.priority = 999;
	self.dateToCellBottom.constant = 2;
	self.dateLabel.alpha = 100;
	self.noteLabel.alpha = 0;
	
	self.textViewToNoteBottomConstraint.priority = 800;
	self.textViewToCellBottom.priority = 800;
	self.dateToNote.priority = 800;
	self.noteToBottomCell.priority = 800;
	
	[self.contentView layoutIfNeeded];
	
}

- (void)setConstraintPriorityForSimpleCellPlusNote {

	self.textViewToNoteBottomConstraint.priority = 999;
	self.textViewToNoteBottomConstraint.constant = 2;
	self.noteToBottomCell.priority = 999;
	self.noteToBottomCell.constant = 2;
	self.noteLabel.alpha = 100;
	self.dateLabel.alpha = 0;
	
	self.textViewToDateBottomConstraint.priority = 800;
	self.dateToNote.priority = 800;
	self.dateToCellBottom.priority = 800;
	self.textViewToCellBottom.priority = 800;
	
	[self.contentView layoutIfNeeded];

}

- (void)setConstraintPriorityForSimpleCellPlusDateAndNote {
	
	self.textViewToDateBottomConstraint.priority = 999;
	self.dateToNote.priority = 999;
	self.noteToBottomCell.priority = 999;
	self.noteToBottomCell.constant = 2;
	
	self.noteLabel.alpha = 100;
	self.dateLabel.alpha = 100;
	
	self.textViewToNoteBottomConstraint.priority = 800;
	self.textViewToCellBottom.priority = 800;
	self.dateToCellBottom.priority = 800;
	
	[self.contentView layoutIfNeeded];
	
}

- (void)setConstraintPriorityForPriorityAttribute {
	
	self.textView.textContainerInset = UIEdgeInsetsMake(self.priorityLabel.bounds.size.height, 0.0, 0.0, 0.0);
	self.priorityLabel.alpha = 100;
	
	[self.contentView layoutIfNeeded];
	
}

#pragma mark - external String for converting Priority attribute into string

NSString *CDPriorityStringRepresentationForPriority(CDPriority priority) {
	
	switch (priority) {
		case CDPriorityLow:
			return @"";
			break;
		case CDPriorityMedium:
			return @"!";
			break;
		case CDPriorityHigh:
			return @"!!";
			break;
		case CDPriorityCritical:
			return @"!!!";
			break;
		default:
			break;
	}
	return @"";
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.delegate reminderCell:self wantsToResizeTextView:textView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		self.reminder.taskName = self.textView.text;
		/*
		 Here we will have the other attributes to be saved to self.reminder (date, note, priority) - comming from the edit screen
		 */
		[self.delegate reminderCell:self wantsToSaveReminder:self.reminder];
		
		return NO;
	}
	
	return YES;
	
}

@end
