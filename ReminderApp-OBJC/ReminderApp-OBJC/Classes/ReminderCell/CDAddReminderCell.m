//
//  AddReminderCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDAddReminderCell.h"

@interface CDAddReminderCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL placeholder;

@end

@implementation CDAddReminderCell

- (void)awakeFromNib {
	
	[super awakeFromNib];
	self.textView.delegate = self;
	self.textView.text = @"Title";
	self.textView.textColor = [UIColor lightGrayColor];
	self.placeholder = YES;
	
}

#pragma mark - Action Button Methods

- (IBAction)detailButtonTapped:(id)sender {
	
	[self.textView resignFirstResponder];
	
	/* We do not attempt to save a reminder when in the addReminderCell text is the placeholder */
	if (!self.placeholder) {
		[self.delegate addReminderCell:self wantsToAddReminderWithText:self.textView.text detailButtonWasPressed:YES];
		self.placeholder = YES;
		self.textView.text = @"Title";
		self.textView.textColor = [UIColor lightGrayColor];
	}
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	self.placeholder = NO;
	self.textView.text = @"";
	self.textView.textColor = [UIColor blackColor];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	
	if ([textView.text isEqualToString:@""]) {
		textView.text = @"Title";
		textView.textColor = [UIColor lightGrayColor];
		self.placeholder = YES;
	}
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.delegate addReminderCell:self wantsToResizeTextView:textView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		
		if (!self.placeholder) {
			[self.delegate addReminderCell:self wantsToAddReminderWithText:self.textView.text detailButtonWasPressed:NO];
			self.placeholder = YES;
			self.textView.text = @"Title";
			self.textView.textColor = [UIColor lightGrayColor];
		}
		
		return NO;
	}
	
	return YES;


}

@end
