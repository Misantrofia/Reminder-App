//
//  CDReminderTableViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderTableViewController.h"
#import "CDAddReminderCell.h"
#import "CDReminderCell.h"

@interface CDReminderTableViewController () <UITextViewDelegate>

@property (nonatomic, assign) NSInteger count;

@end

@implementation CDReminderTableViewController

- (IBAction)detailAction:(id)sender {

	NSLog(@"Pam");
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.count = 1;
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 100;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
}

#pragma mark - Helper methods

- (CGFloat)textViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITextView *calculationView = ((CDAddReminderCell *)[self.tableView cellForRowAtIndexPath:indexPath]).textView;
	CGFloat textViewWidth = calculationView.frame.size.width;
	
	if(!calculationView.attributedText) {
		calculationView = [[UITextView alloc] init];
		NSString *stringFromTextView = calculationView.text;// get the text from your datasource
		NSDictionary *dict1 = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:14.0]}; //add attributes
		calculationView.attributedText = [[NSAttributedString alloc] initWithString:stringFromTextView attributes:dict1];//insert here
		textViewWidth = 290.0;
	}
	
	CGSize size = [calculationView sizeThatFits:CGSizeMake(textViewWidth, FLT_MAX)];
	
	return size.height;
	
}

- (void)scrollToCursorForTextView:(UITextView *)textView {
	
	CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
	cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
	
	if (![self rectVisible:cursorRect]) {
		cursorRect.size.height += 8;
		[self.tableView scrollRectToVisible:cursorRect animated:YES];
	}
	
}

- (BOOL)rectVisible:(CGRect)rect {
	
	CGRect visibleRect;
	visibleRect.origin = self.tableView.contentOffset;
	visibleRect.origin.y += self.tableView.contentInset.top;
	visibleRect.size = self.tableView.bounds.size;
	visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
	
	return CGRectContainsRect(visibleRect, rect);
	
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
	
	NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
	
	self.tableView.contentInset = contentInsets;
	self.tableView.scrollIndicatorInsets = contentInsets;
	
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
	
	self.tableView.contentInset = contentInsets;
	self.tableView.scrollIndicatorInsets = contentInsets;
	
	[UIView commitAnimations];
	
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	NSLog(@"Begin editing \n");
	[self scrollToCursorForTextView:textView];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	
	NSLog(@"End edititing \n");
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog(@"DidChange \n");
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
	[self scrollToCursorForTextView:textView];
	
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if(self.tableView == scrollView) {
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[[self.tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
	}
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self textViewHeightForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.count;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row % 2 == 0) {
		CDAddReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
		cell.textView.delegate = self;
		return cell;
	}
	
	CDReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
	cell.textView.delegate = self;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.count += 1;
	
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
	
}

@end
