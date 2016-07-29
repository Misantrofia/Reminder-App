//
//  CDLoginViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 29/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDLoginViewController.h"
#import "KeychainWrapper.h"

@interface CDLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) KeychainWrapper *myKeyChainWrapper;
@property (nonatomic, assign) NSInteger createLoginButtonTag;
@property (nonatomic, assign) NSInteger loginButtonTag;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation CDLoginViewController

- (void)viewDidLoad {

	[super viewDidLoad];
	
	self.createLoginButtonTag = 0;
	self.loginButtonTag = 1;
	self.myKeyChainWrapper = [[KeychainWrapper alloc] init];
	
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
	
	if ([sender tag] == self.createLoginButtonTag) {
		BOOL hasLoginKey = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLoginKey"];
		
		if (!hasLoginKey) {
			[[NSUserDefaults standardUserDefaults]setValue:self.usernameTextField.text
													forKey:@"username"];
		}

		[self.myKeyChainWrapper mySetObject:self.passwordTextField.text
									 forKey:@"kSecValueData"];
		
		[self.myKeyChainWrapper writeToKeychain];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES
												forKey:@"hasLoginKey"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		self.loginButton.tag = self.loginButtonTag;
		
		[self performSegueWithIdentifier:@"loginToTopicController" sender:self];
	} else if ([sender tag] == self.loginButtonTag) {
		if ([self checkLogin:self.usernameTextField.text password:self.passwordTextField.text]) {
			[self performSegueWithIdentifier:@"loginToTopicController" sender:self];
		} else {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Problem"
																		   message:@"Wrong username or password."
																	preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Foiled again!"
															 style:UIAlertActionStyleDefault
														   handler:nil];
			[alert addAction:okAction];
			
			[self presentViewController:alert animated:YES completion:nil];
		}
	}
	
	
}

- (BOOL)checkLogin:(NSString *)username password:(NSString *)password {
	
	if ([password isEqualToString:[self.myKeyChainWrapper myObjectForKey:@"v_Data"]] &&
		[username isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]) {
		
		return YES;
	}
	
	return NO;
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	
}


@end
