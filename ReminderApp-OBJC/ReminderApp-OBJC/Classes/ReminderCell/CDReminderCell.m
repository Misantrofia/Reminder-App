//
//  CDReminderCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 12/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderCell.h"
#import "CDAddReminderCell.h"

@implementation CDReminderCell

#pragma mark - UITextViewDelegate

//- (void)textViewDidChange:(UITextView *)textView {
//	
//	NSLog(@"DidChange \n");
//}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//	
//	NSIndexPath *lastIndexPathFromFirstSection = [NSIndexPath indexPathForRow:self.fetchedResultsController.sections[0].numberOfObjects inSection:0];
//	CDAddReminderCell *createReminderCell = [self.tableView cellForRowAtIndexPath:lastIndexPathFromFirstSection];
//	
//	if ([text isEqualToString:@"\n"]) {
//		[textView resignFirstResponder];
//		
//		/* If we add a new reminder by using the last cell's textview, we create a new Reminder Instance
//		 Afterwards we set the cell's text back to empty.
//		 */
//		if (createReminderCell.textView == textView){
//			CDReminder *reminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedContext];
//			reminder.taskName = textView.text;
//			reminder.topic = self.topic;
//			
//			textView.text = @"";
//			
//			NSError *error;
//			if (![self.managedContext save:&error]) {
//				NSLog(@"Could not save a Reminder object:%@. \n An error occured: %@", reminder, error);
//			}
//		}else {
//			
//			/*
//			 Case for Update cell
//			 We acces the cell in which the textView is in by accesing it's superview.superview
//			 Then we iterate through tableView's rows until we find the cell by computing indexPath with different row
//			 Once we find its match, we break the loop and update its content
//			 
//			 OR: Can we pass somehow the event from the textView, to it's superview, way up to the cell. And then
//			 we can get use of indexPathForSelectedRow? (like in the WWDC video with the gesture events)
//			 */
//			
//			CDAddReminderCell *cellFromTextView = (CDAddReminderCell *)textView.superview.superview;
//			
//			for (int row = 0; row < ((int)self.fetchedResultsController.sections[0].numberOfObjects); row += 1) {
//				NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//				if ([self.tableView cellForRowAtIndexPath:indexPath] == cellFromTextView) {
//					CDReminder *reminderToUpdate = [self.fetchedResultsController objectAtIndexPath:indexPath];
//					reminderToUpdate.taskName = textView.text;
//					
//					NSError *error;
//					if (![self.managedContext save:&error]) {
//						NSLog(@"Could not update a Reminder obj:%@ \n An error occured: %@", reminderToUpdate, error);
//					}
//					
//					break;
//				}
//			}
//		}
//		return NO;
//	}
//	
//	return YES;
//	
//}

@end
