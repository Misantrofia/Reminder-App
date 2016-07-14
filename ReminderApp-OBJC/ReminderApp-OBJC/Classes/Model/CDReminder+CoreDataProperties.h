//
//  CDReminder+CoreDataProperties.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 14/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDReminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDReminder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *priority;
@property (nullable, nonatomic, retain) NSDate *taskDate;
@property (nullable, nonatomic, retain) NSString *taskName;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) CDTopic *topic;

@end

NS_ASSUME_NONNULL_END
