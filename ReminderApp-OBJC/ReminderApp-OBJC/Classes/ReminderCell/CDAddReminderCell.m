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
	self.textView.text = @"Title";
	self.textView.textColor = [UIColor lightGrayColor];
	
}

#pragma mark - Action Button Methods

- (IBAction)detailButtonTapped:(id)sender {
	
	[self.textView resignFirstResponder];
	
	[self.delegate addReminderCell:self wantsToAddReminderWithText:self.textView.text viaDetailButton:YES];
	self.textView.text = @"";
	
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
	
	self.textView.text = @"";
	self.textView.textColor = [UIColor blackColor];
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.delegate addReminderCell:self wantsToResizeTextView:textView];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		
		[self.delegate addReminderCell:self wantsToAddReminderWithText:self.textView.text viaDetailButton:NO];
		self.textView.text = @"";
		
		return NO;
	}
	
	return YES;


}

@end
