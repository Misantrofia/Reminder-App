//
//  CDEditPriorityCell.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 19/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDReminder.h"

@interface CDEditPriorityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;

- (void)setupCellWithReminder:(CDReminder *)reminder;

@end
