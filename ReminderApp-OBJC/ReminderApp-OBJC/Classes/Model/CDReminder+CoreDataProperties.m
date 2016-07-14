//
//  CDReminder+CoreDataProperties.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 14/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDReminder+CoreDataProperties.h"

@implementation CDReminder (CoreDataProperties)

@dynamic note;
@dynamic priority;
@dynamic taskDate;
@dynamic taskName;
@dynamic creationDate;
@dynamic topic;

-(void)awakeFromInsert {
	[super awakeFromInsert];
	[self setValue:[NSDate date] forKey:@"creationDate"];
}

@end
