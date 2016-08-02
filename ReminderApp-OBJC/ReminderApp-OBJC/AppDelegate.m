//
//  AppDelegate.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 01/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	UIUserNotificationSettings *notificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
	
	if (notificationSettings.types == UIUserNotificationTypeNone) {
		UIUserNotificationType notificationType = UIUserNotificationTypeAlert |
		UIUserNotificationTypeBadge |
		UIUserNotificationTypeSound;
		
		UIMutableUserNotificationAction *informAction = [[UIMutableUserNotificationAction alloc] init];
		informAction.identifier = @"sv.ReminderApp-OBJC.informAction";
		informAction.title = @"OK";
		informAction.activationMode = UIUserNotificationActivationModeBackground;
		informAction.destructive = NO;
		informAction.authenticationRequired = NO;
		
		UIMutableUserNotificationAction *snoozeAction = [[UIMutableUserNotificationAction alloc] init];
		snoozeAction.identifier = @"sv.ReminderApp-OBJC.snoozeAction";
		snoozeAction.title = @"Snooze";
		snoozeAction.activationMode = UIUserNotificationActivationModeBackground;
		snoozeAction.destructive = NO;
		snoozeAction.authenticationRequired = NO;
		
		UIMutableUserNotificationAction *deleteAction = [[UIMutableUserNotificationAction alloc] init];
		deleteAction.identifier = @"sv.ReminderApp-OBJC.deleteAction";
		deleteAction.title = @"Delete reminder";
		deleteAction.activationMode = UIUserNotificationActivationModeBackground;
		deleteAction.destructive = YES;
		deleteAction.authenticationRequired = YES;
		
		NSArray *actions = @[informAction, snoozeAction, deleteAction];
		NSArray *actionsMinimal = @[informAction, snoozeAction];
		
		UIMutableUserNotificationCategory *reminderCategory = [[UIMutableUserNotificationCategory alloc] init];
		reminderCategory.identifier = @"reminderCategory";
		[reminderCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
		[reminderCategory setActions:actionsMinimal forContext:UIUserNotificationActionContextMinimal];
		
		NSSet *categoriesForSettings = [[NSSet alloc] initWithObjects:reminderCategory, nil];
		
		UIUserNotificationSettings *newNotificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType
																								categories:categoriesForSettings];
		[[UIApplication sharedApplication] registerUserNotificationSettings:newNotificationSettings];
	}
	
	return YES;
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

	[self saveContext];
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	[self saveContext];

}

#pragma mark - Notification Delegate

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
	
	NSLog(@"Did Register User Notification");
	
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	
	NSLog(@"Received Local Notification");
	NSLog(@"%@", notification.alertBody);
	
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
	
	[self.delegate appDelegate:self wantsToHandleNotificationActionWithIdentifier:identifier];
	completionHandler();
	
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "sv.ReminderApp_OBJC" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ReminderApp_OBJC" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ReminderApp_OBJC.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
