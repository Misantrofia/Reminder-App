//
//  CDReminderCell.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 12/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDReminder.h"

@class CDReminderCell;

@protocol CDReminderCellDelegate

- (void)reminderCell:(CDReminderCell *)cell wantsToSaveReminder:(CDReminder *)reminder;
- (void)reminderCell:(CDReminderCell *)cell wantsToResizeTextView:(UITextView *)textView;
	
@end

@interface CDReminderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <CDReminderCellDelegate> delegate;

- (void)updateWithReminder:(CDReminder *)reminder;

@end
