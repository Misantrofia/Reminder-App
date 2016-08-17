//
//  CDTopic+CoreDataProperties.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 02/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDTopic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDTopic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *numberOfItems;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *user;
@property (nullable, nonatomic, retain) NSSet<CDReminder *> *reminders;

@end

@interface CDTopic (CoreDataGeneratedAccessors)

- (void)addRemindersObject:(CDReminder *)value;
- (void)removeRemindersObject:(CDReminder *)value;
- (void)addReminders:(NSSet<CDReminder *> *)values;
- (void)removeReminders:(NSSet<CDReminder *> *)values;

@end

NS_ASSUME_NONNULL_END
