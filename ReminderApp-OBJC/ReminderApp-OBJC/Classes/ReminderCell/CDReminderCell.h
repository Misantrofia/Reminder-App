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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewToDateBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewToNoteBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewToCellBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToCellBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteToBottomCell;

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <CDReminderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *priority;

- (void)updateWithReminder:(CDReminder *)reminder;

@end
