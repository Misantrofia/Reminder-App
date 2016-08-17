//
//  CDChangeTopicForReminder.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 25/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDTopic.h"
#import "CDTopicTableViewController.h"

typedef void (^ChangedTopicForReminder)(CDTopic *);

@interface CDChangeTopicForReminder : UITableViewController

@property (nonatomic, copy) ChangedTopicForReminder changedTopic;
@property (nonatomic, strong) CDTopic *topic;

@end
