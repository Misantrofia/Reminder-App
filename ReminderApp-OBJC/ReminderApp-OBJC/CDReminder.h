//
//  CDReminder.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 14/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTopic;

NS_ASSUME_NONNULL_BEGIN

@interface CDReminder : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDReminder+CoreDataProperties.h"
