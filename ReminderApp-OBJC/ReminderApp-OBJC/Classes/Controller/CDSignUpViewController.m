//
//  CDSignUpViewController.m
//  ReminderApp-OBJC
//
//  Created by Catalin David on 29/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import "CDSignUpViewController.h"

@interface CDSignUpViewController ()  <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@end

@implementation CDSignUpViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.usernameTextField.delegate = self;
	self.passwordTextField.delegate = self;
	
}

- (IBAction)saveTapped:(id)sender {
	
	if ([self.usernameTextField.text isEqualToString:@""] ||
		[self.passwordTextField.text isEqualToString:@""]) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Problem"
																	   message:@"Username or password fields cannot be empty"
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
	
	
	BOOL hasLoginKey = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",self.usernameTextField.text]];
	
	if (!hasLoginKey) {
		[[NSUserDefaults standardUserDefaults]setValue:self.usernameTextField.text
												forKey:self.usernameTextField.text];
	
		[self.myKeyChainWrapper mySetObject:self.passwordTextField.text
									 forKey:kSecValueData];
		
		[self.myKeyChainWrapper writeToKeychain];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES
												forKey:@"hasLogin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[self performSegueWithIdentifier:@"signUpToTopicController" sender:self];
	} else {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Problem!"
																	   message:@"Username already exists."
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Creating account has failed."
														   style:UIAlertActionStyleDefault
														 handler:nil];
		
		[alert addAction:okAction];
		
		[self presentViewController:alert animated:YES completion:nil];
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
