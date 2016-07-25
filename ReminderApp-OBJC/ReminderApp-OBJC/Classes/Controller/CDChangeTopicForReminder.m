//
//  CDChangeTopicForReminder.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 25/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDChangeTopicForReminder.h"

@interface CDChangeTopicForReminder ()

@property (nonatomic, strong) NSArray *topicList;

@end

@implementation CDChangeTopicForReminder

- (void)viewDidLoad {
	
	[super viewDidLoad];

	CDTopicTableViewController *topicController = ((CDTopicTableViewController *)self.navigationController.viewControllers.firstObject);
	[topicController readyToSendTopicList];
	
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.topicList.count;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *topicCell = [tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
	
	if (self.topicList[indexPath.row] == self.topic) {
		topicCell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	topicCell.textLabel.text = ((CDTopic *)self.topicList[indexPath.row]).title;
	
    return topicCell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.changedTopic((CDTopic *)self.topicList[indexPath.row]);
	[self.navigationController popViewControllerAnimated:YES];
	
}

#pragma mark - CDTopicTableViewControllerDelegate

- (void)topicController:(CDTopicTableViewController *)topicController wantsToSendTopicList:(NSArray *)topicList {
	
	self.topicList = topicList;
	
}

@end
