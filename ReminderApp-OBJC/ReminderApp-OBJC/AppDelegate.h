//
//  AppDelegate.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 01/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

/*
 - alexs :  Nu uita sa prefixezi clasele. De acum inainte cand faci proiecte noi le prefixezi asa cum am facut si la teme si proiect.
 - structura de foldere o faci si pe disk, nu doar in xcode. Cum arata in navigator sa fie si pe disk.
 
 */

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class AppDelegate;

@protocol CDAppDelegateNotificationHandlerDelegate <NSObject>

- (void)appDelegate:(AppDelegate *)appDelegate wantsToHandleNotificationActionWithIdentifier:(NSString *)identifier;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, weak) id<CDAppDelegateNotificationHandlerDelegate> delegate;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

