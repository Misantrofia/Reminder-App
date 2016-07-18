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

- (void)updateWithReminder:(CDReminder *)reminder {

	self.reminder = reminder;
	self.textView.delegate = self;
	self.textView.text = self.reminder.taskName;

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
