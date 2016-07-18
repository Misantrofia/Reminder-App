//
//  CDReminder.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 14/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDReminder.h"
#import "CDTopic.h"

@implementation CDReminder

- (void)awakeFromInsert {
	
	[super awakeFromInsert];
	[self setValue:[NSDate date] forKey:@"creationDate"];
	
}

@end
