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

- (void)setupCellWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	
	if (!self.reminder || [self.reminder.taskName isEqualToString: @""]) {
		self.textView.text = @"Title";
		self.textView.textColor = [UIColor lightGrayColor];
	} else {
		self.textView.textColor = [UIColor blackColor];
		self.textView.text = self.reminder.taskName;
	}
	
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
	
	self.textView.text = @"";
	self.textView.textColor = [UIColor blackColor];
	
}

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