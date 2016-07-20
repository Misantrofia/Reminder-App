//
//  CDEditNotesTextCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDEditNotesTextCell.h"

@interface CDEditNotesTextCell () <UITextViewDelegate>

@property (nonatomic, strong) CDReminder *reminder;

@end

@implementation CDEditNotesTextCell

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.noteTextView.delegate = self;
	self.noteTextView.textContainerInset = UIEdgeInsetsZero;
	self.noteTextView.textContainer.lineFragmentPadding = 0;

}

- (void)setupReminderWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.delegate editNotesTextCell:self wantsToResizeTextView:self.noteTextView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		self.reminder.note = self.noteTextView.text;
		return NO;
	}
	
	return YES;
	
}

@end
