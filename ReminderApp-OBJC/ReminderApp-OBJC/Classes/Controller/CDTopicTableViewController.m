//
//  ViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 01/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDTopicTableViewController.h"
#import "AppDelegate.h"
#import "CDTopic.h"
#import "CDReminderTableViewController.h"

#pragma mark - Class extension

@interface CDTopicTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;

@end

#pragma mark - Class implementation

@implementation CDTopicTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.editButton.title = @"Edit";
	self.title = @"Topics";
	
	self.managedContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Could not perform a fetch for Topic entity, an error occured: %@", error);
	}
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"segueTopicControllerToReminderController"]) {
		CDReminderTableViewController *destinationController = ((CDReminderTableViewController *)segue.destinationViewController);
		destinationController.topic = ((CDTopic *) [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow]);
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self.tableView reloadData];
	
}

#pragma mark - Action methods for buttons

- (IBAction)editTapped:(id)sender {

	if (self.tableView.editing) {
		self.editButton.title = @"Edit";
		self.tableView.editing = NO;
	} else {
		self.editButton.title = @"Back";
		self.tableView.editing = YES;
	}
	
}

- (IBAction)addTapped:(id)sender {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Topic"
																   message:@"Add a new topic'"
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction	*action) {
														   
														   NSString *topicName = alert.textFields.firstObject.text;
														   [self saveTopicWithName:topicName];
													   } ];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
														   style:UIAlertActionStyleDefault
														 handler:nil];
	
	[alert addTextFieldWithConfigurationHandler:nil];
	[alert addAction:saveAction];
	[alert addAction:cancelAction];
	
	[self presentViewController:alert animated:YES completion:nil];
	
}

#pragma mark - Helper func for addTapped

- (void) saveTopicWithName:(NSString *)topicName {
	
	CDTopic *topic = [NSEntityDescription insertNewObjectForEntityForName:@"Topic" inManagedObjectContext:self.managedContext];
	topic.title = topicName;
	
	NSError *error;
	if (![self.managedContext save:&error]) {
		NSLog(@"Could not save the Topic object:%@ An error occured: %@", topic, error);
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
		_fetchedResultsController.delegate = self;
	}
	
	return _fetchedResultsController;
	
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView beginUpdates];
	
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			CDTopic *topicItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
			cell.textLabel.text = topicItem.title;
		}
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
	
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView endUpdates];
	
}

#pragma mark - DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	
	return self.fetchedResultsController.sections.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return self.fetchedResultsController.sections[section].numberOfObjects;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
	
	CDTopic *topic = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.textLabel.text = topic.title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",topic.reminders.count];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	  toIndexPath:(NSIndexPath *)destinationIndexPath {
	
	NSLog(@"MovedRow from row %ld, to row %ld", (long)sourceIndexPath.row, (long)destinationIndexPath.row);
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		CDTopic *topicToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.managedContext deleteObject:topicToDelete];
		
		NSError *error;
		if (![self.managedContext save:&error]) {
			NSLog(@"Could not delete the Topic object:%@ An error occured: %@", topicToDelete, error);
		}
	}
	
}

@end