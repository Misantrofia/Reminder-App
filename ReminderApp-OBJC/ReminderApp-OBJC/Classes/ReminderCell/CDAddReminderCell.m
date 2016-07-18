//
//  AddReminderCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDAddReminderCell.h"

@interface CDAddReminderCell () <UITextViewDelegate>

@end

@implementation CDAddReminderCell

- (void)awakeFromNib {
	
	[super awakeFromNib];
	self.textView.delegate = self;
	
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.delegate addReminderCell:self wantsToResizeTextView:textView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		
		[self.delegate addReminderCell:self wantsToAddReminderWithText:self.textView.text];
		self.textView.text = @"";
		
		return NO;
	}
	
	return YES;


}

@end
