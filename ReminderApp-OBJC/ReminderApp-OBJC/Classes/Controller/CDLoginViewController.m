//
//  CDLoginViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 29/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "AppDelegate.h"
#import "CDLoginViewController.h"
#import "KeychainWrapper.h"
#import "CDSignUpViewController.h"
#import "CDTopicTableViewController.h"
#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"

@interface CDLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) KeychainWrapper *myKeyChainWrapper;
@property (nonatomic, assign) NSInteger createLoginButtonTag;
@property (nonatomic, assign) NSInteger loginButtonTag;
@property (nonatomic, strong) SAMKeychain *keychainWrapper;

@end

@implementation CDLoginViewController

- (void)viewDidLoad {

	[super viewDidLoad];
	
	self.myKeyChainWrapper = [[KeychainWrapper alloc] init];
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	self.keychainWrapper = appDelegate.keychain;
	
	self.usernameTextField.delegate = self;
	self.passwordTextField.delegate = self;
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	if (self.myKeyChainWrapper) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
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
		[self performSegueWithIdentifier:@"loginToTopicController" sender:self];
		[[NSUserDefaults standardUserDefaults] setBool:YES
												forKey:@"hasLogin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
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
	
	if ([password isEqualToString:[self.myKeyChainWrapper myObjectForKey:@"v_Data"]] &&
		[username isEqualToString:[self.myKeyChainWrapper myObjectForKey:(NSString *)kSecAttrAccount]]) {
		
		return YES;
	}
	
	return NO;
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"loginToSignupScreen"]) {
		CDSignUpViewController *signUpController = segue.destinationViewController;
		signUpController.myKeyChainWrapper = self.myKeyChainWrapper;
	}
	
	if ([segue.identifier isEqualToString:@"loginToTopicController"]) {
		UINavigationController *navController = segue.destinationViewController;
		CDTopicTableViewController *topicController = navController.viewControllers.firstObject;
		topicController.username = [self.myKeyChainWrapper myObjectForKey:(NSString *)kSecAttrAccount];
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
