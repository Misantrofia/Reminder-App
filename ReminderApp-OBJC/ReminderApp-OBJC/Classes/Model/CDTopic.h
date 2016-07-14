//
//  TopicReminder.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 11/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDReminder;

NS_ASSUME_NONNULL_BEGIN

@interface CDTopic : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDTopic+CoreDataProperties.h"
