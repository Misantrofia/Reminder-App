//
//  CDChangeTopicForReminder.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 25/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDChangeTopicForReminder.h"
#import "AppDelegate.h"

@interface CDChangeTopicForReminder ()

@property (nonatomic, strong) NSArray *topicList;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CDChangeTopicForReminder

- (void)viewDidLoad {
	
	[super viewDidLoad];

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	self.managedContext = appDelegate.managedObjectContext;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Could not perform a fetch for Topic entity, an error occured: %@", error);
	}
	
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (_fetchedResultsController == nil) {
		NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Topic"];
		NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title"
															   ascending:YES];
		
		fetch.sortDescriptors = @[sort];
		_fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch
																	   managedObjectContext:self.managedContext
																		 sectionNameKeyPath:nil
																				  cacheName:nil];
		
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"user MATCHES %@", self.topic.user];
		fetch.predicate = pred;
	}
	
	return _fetchedResultsController;
	
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.fetchedResultsController.sections[section].numberOfObjects;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *topicCell = [tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
	
	if ([self.fetchedResultsController objectAtIndexPath:indexPath] == self.topic) {
		topicCell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	CDTopic *topic = [self.fetchedResultsController objectAtIndexPath:indexPath];
	topicCell.textLabel.text = topic.title;
	
    return topicCell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.changedTopic([self.fetchedResultsController objectAtIndexPath:indexPath]);
	[self.navigationController popViewControllerAnimated:YES];
	
}

@end
