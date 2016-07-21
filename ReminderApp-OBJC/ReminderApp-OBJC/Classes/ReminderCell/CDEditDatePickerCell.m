//
//  CDEditDatePickerCell.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDEditDatePickerCell.h"

@interface CDEditDatePickerCell ()

@property (nonatomic, strong) CDReminder *reminder;

@end

@implementation CDEditDatePickerCell

- (void)setupReminderWithReminder:(CDReminder *)reminder {
	
	self.reminder = reminder;
	
}

- (IBAction)datePickerHasChanged:(id)sender {
	
	self.reminder.taskDate = self.datePicker.date;
	
}

@end
