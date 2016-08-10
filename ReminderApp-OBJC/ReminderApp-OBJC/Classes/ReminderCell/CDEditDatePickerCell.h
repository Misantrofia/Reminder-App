//
//  CDEditDatePickerCell.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDReminder.h"

@interface CDEditDatePickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (void)setupReminderWithReminder:(CDReminder *)reminder;

@end
