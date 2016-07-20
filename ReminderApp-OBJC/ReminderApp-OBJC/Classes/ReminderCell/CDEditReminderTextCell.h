//
//  CDEditReminderTextCell.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDReminder.h"

@class CDEditReminderTextCell;

@protocol CDEditReminderTextCellDelegate

- (void)editReminderTextCell:(CDEditReminderTextCell *)cell wantsToResizeTextView:(UITextView *)textView;

@end

@interface CDEditReminderTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <CDEditReminderTextCellDelegate> delegate;

- (void)setupReminderWithReminder:(CDReminder *)reminder;

@end
