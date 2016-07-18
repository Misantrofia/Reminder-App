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

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.textView.delegate = self;
	
}

- (void)updateWithReminder:(CDReminder *)reminder {

	self.reminder = reminder;
	self.textView.text = self.reminder.taskName;
	self.note.text = self.reminder.note;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
	self.date.text = [dateFormatter stringFromDate:self.reminder.taskDate];
	[self changePriorities:reminder];
	
}

-(void)changePriorities:(CDReminder *)reminder {
	
	if (!reminder.taskDate && !reminder.note &&
		[reminder.priority isEqualToNumber:[NSNumber numberWithInteger:0]]) {
		
		self.textViewToNoteBottomConstraint.priority = 800;
		self.textViewToDateBottomConstraint.priority = 800;
		self.dateToNote.priority = 800;
		self.dateToCellBottom.priority = 800;
		self.textViewToCellBottom.priority = 1000;
		self.textViewToCellBottom.constant = 2;

		self.date.alpha = 0;
		self.note.alpha = 0;
		self.priority.alpha = 0;
		[self.contentView layoutIfNeeded];
	}
	
	if (![reminder.priority isEqualToNumber:[NSNumber numberWithInteger:0]]) {
		self.textView.textContainerInset = UIEdgeInsetsMake(0.0, self.priority.bounds.size.width, 0.0, 0.0);
		self.priority.text = @"!!!";
		self.priority.alpha = 100;
		[self.contentView layoutIfNeeded];
	} else {
		self.priority.text = @"";
		self.priority.alpha = 0;
	}
	
	if (reminder.taskDate) {
		self.date.alpha = 100;
		self.textViewToDateBottomConstraint.priority = 1000;
		self.dateToNote.priority = 800;
		self.dateToCellBottom.priority = 1000;
		self.dateToCellBottom.constant = 2;
		self.textViewToNoteBottomConstraint.priority = 800;
		self.textViewToCellBottom.priority = 800;
		[self.contentView layoutIfNeeded];
	} else {
		self.textViewToDateBottomConstraint.priority = 800;
		self.dateToCellBottom.priority = 800;
		self.date.alpha = 0;
	}
	
	if (reminder.note) {
		self.note.alpha = 100;
		if (!reminder.taskDate) {
			self.textViewToNoteBottomConstraint.priority = 1000;
		} else {
			self.dateToNote.priority = 1000;
		}
		self.textViewToCellBottom.priority = 800;
		[self.contentView layoutIfNeeded];
	} else {
		self.textViewToNoteBottomConstraint.priority = 800;
		self.note.alpha = 0;
	}
	
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
		
		[self.delegate reminderCell:self wantsToSaveReminder:self.reminder];
		
		return NO;
	}
	
	return YES;
	
}

@end
