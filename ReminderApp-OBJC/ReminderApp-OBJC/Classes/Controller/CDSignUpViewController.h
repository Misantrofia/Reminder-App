//
//  CDSignUpViewController.h
//  ReminderApp-OBJC
//
//  Created by Catalin David on 29/07/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainWrapper.h"

@interface CDSignUpViewController : UIViewController

@property (nonatomic, strong) KeychainWrapper *myKeyChainWrapper;

@end
