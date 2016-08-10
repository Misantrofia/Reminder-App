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
	self.noteTextView.backgroundColor = [UIColor clearColor];

}

- (void)setupCellWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	
	if (!self.reminder.note || [self.reminder.note isEqualToString:@""]) {
		self.noteTextView.text = @"Note";
	} else {
		self.noteTextView.text = self.reminder.note;
	}
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	self.noteTextView.text = @"";
	
}

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
