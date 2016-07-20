//
//  CDEditNotesTextCell.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDReminder.h"

@class CDEditNotesTextCell;

@protocol CDEditNotesTextCellDelegate

- (void)editNotesTextCell:(CDEditNotesTextCell *)cell wantsToResizeTextView:(UITextView *)textView;

@end


@interface CDEditNotesTextCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextView *noteTextView;
@property (nonatomic, weak) id <CDEditNotesTextCellDelegate> delegate;

- (void)setupReminderWithReminder:(CDReminder *)reminder;

@end
