//
//  CDEditReminderTextCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDEditReminderTextCell.h"

@interface CDEditReminderTextCell () <UITextViewDelegate>

@property (nonatomic, strong) CDReminder *reminder;

@end

@implementation CDEditReminderTextCell

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.textView.delegate = self;
	self.textView.textContainerInset = UIEdgeInsetsZero;
	self.textView.textContainer.lineFragmentPadding = 0;

}

- (void)setupReminderWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.delegate editReminderTextCell:self wantsToResizeTextView:self.textView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		self.reminder.taskName = self.textView.text;
		return NO;
	}
	
	return YES;
	
}

@end