//
//  CDReminderTableViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminderTableViewController.h"
#import "CDAddReminderCell.h"

@interface CDReminderTableViewController ()

@end

@implementation CDReminderTableViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
    
   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    CDAddReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
    
    return cell;
	
}



@end
