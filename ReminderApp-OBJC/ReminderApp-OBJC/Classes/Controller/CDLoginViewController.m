//
//  CDLoginViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 29/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "AppDelegate.h"
#import "CDLoginViewController.h"
#import "CDSignUpViewController.h"
#import "CDTopicTableViewController.h"
#import "SAMKeychain.h"

@interface CDLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, assign) NSInteger createLoginButtonTag;
@property (nonatomic, assign) NSInteger loginButtonTag;
@property (nonatomic, strong) NSString *userLoggedIn;
@property (nonatomic, strong) SAMKeychainQuery *queryToDelete;
@property (nonatomic, strong) SAMKeychainQuery *queryToDeleteLastLogin;

@end

@implementation CDLoginViewController

- (void)viewDidLoad {

	[super viewDidLoad];
	
	self.usernameTextField.delegate = self;
	self.passwordTextField.delegate = self;
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	BOOL hasLogout = NO;
	
	if ([SAMKeychain allAccounts]){
		SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
		query.service =	kSAMKeychainLastModifiedKey;
		NSArray *array = [SAMKeychain accountsForService:kSAMKeychainLastModifiedKey];
		if (array) {
			for (NSDictionary *dictionary in array) {
				query.account = dictionary[@"acct"];
				query.password = [SAMKeychain passwordForService:kSAMKeychainLastModifiedKey account:query.account];
				
				NSError *error;
				if ([query fetch:&error]) {
					self.userLoggedIn = query.account;
					if ([query.account isEqualToString:@""] || !query.account) {
						hasLogout = YES;
						self.queryToDelete = query;
						return;
					}
				}
			}
		}
		if (!hasLogout) {
			self.queryToDeleteLastLogin = [[SAMKeychainQuery alloc] init];
			self.queryToDeleteLastLogin.service =	@"lastLogin";
			NSArray *array = [SAMKeychain accountsForService:@"lastLogin"];
			if (array) {
				NSDictionary *dict = array[0];
				self.queryToDeleteLastLogin.account = dict[@"acct"];
				self.queryToDeleteLastLogin.password = [SAMKeychain passwordForService:@"lastLogin" account:query.account];
				NSError *error;
				if ([query fetch:&error]) {
					self.userLoggedIn = query.account;
				}
			}
			[self performSegueWithIdentifier:@"loginToTopicController" sender:self];
		}
	}
	
}

- (IBAction)signUpTapped:(id)sender {
	
	[self performSegueWithIdentifier:@"loginToSignupScreen" sender:self];
	
}

- (IBAction)loginTapped:(id)sender {
	
	if ([self.usernameTextField.text isEqualToString:@""] ||
		[self.passwordTextField.text isEqualToString:@""]) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Problem"
																		message:@"Wrong username or password"
																 preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Failed again"
														   style:UIAlertActionStyleDefault
														 handler:nil];
		
		[alert addAction:okAction];
		
		[self presentViewController:alert animated:YES completion:nil];
		
		return;
	}
	
	[self.usernameTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	
	if ([self checkLogin:self.usernameTextField.text password:self.passwordTextField.text]) {
		self.userLoggedIn = self.usernameTextField.text;
		[self performSegueWithIdentifier:@"loginToTopicController" sender:self];
		[SAMKeychain setPassword:self.passwordTextField.text
					  forService:kSAMKeychainLastModifiedKey
						 account:self.usernameTextField.text];
		
		[SAMKeychain setPassword:self.passwordTextField.text
					  forService:@"lastLogin"
						 account:self.usernameTextField.text];

	} else {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Problem"
																	   message:@"Wrong username or password."
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Failed again"
														 style:UIAlertActionStyleDefault
													   handler:nil];
		[alert addAction:okAction];
		
		[self presentViewController:alert animated:YES completion:nil];
	}
	
}

- (BOOL)checkLogin:(NSString *)username password:(NSString *)password {
	
	if ([password isEqualToString:[SAMKeychain passwordForService:username
														  account:username]]) {
		return YES;
	}

	return NO;
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"loginToTopicController"]) {
		UINavigationController *navController = segue.destinationViewController;
		CDTopicTableViewController *topicController = navController.viewControllers.firstObject;
		topicController.username = self.userLoggedIn;
		
		NSError *error;
		if (self.queryToDelete) {
			[self.queryToDelete deleteItem:&error];
		}
		if (self.queryToDeleteLastLogin) {
			[self.queryToDeleteLastLogin deleteItem:&error];
		}
	}
	
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	
	return NO;
	
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
	
}

@end
