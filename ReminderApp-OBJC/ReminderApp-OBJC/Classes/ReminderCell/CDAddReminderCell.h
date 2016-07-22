//
//  AddReminderCell.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDReminder.h"

@class CDAddReminderCell;

@protocol CDAddReminderCellDelegate

- (void)addReminderCell:(CDAddReminderCell *)cell wantsToAddReminderWithText:(NSString *)reminderText detailButtonWasPressed:(BOOL)detailButton;
- (void)addReminderCell:(CDAddReminderCell *)cell wantsToResizeTextView:(UITextView *)textView;

@end

@interface CDAddReminderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <CDAddReminderCellDelegate> delegate;

@end
