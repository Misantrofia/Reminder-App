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

- (void)addReminderCell:(CDAddReminderCell *)cell wantsToAddReminder:(CDReminder *)reminder;

@end

@interface CDAddReminderCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <CDAddReminderCellDelegate> delegate;

@end
