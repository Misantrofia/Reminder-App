//
//  ViewController.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 01/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDTopicTableViewController;

@protocol CDTopicTableViewControllerDelegate

- (void)topicController:(CDTopicTableViewController *)topicController wantsToSendTopicList:(NSArray *)topicList;

@end

@interface CDTopicTableViewController : UITableViewController

@property (nonatomic, strong) id<CDTopicTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *username;

- (void)readyToSendTopicList;

@end

