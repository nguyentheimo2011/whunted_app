//
//  LoginSignupViewController.h
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainLogInSignUpInterface.h"

@interface MainLogInSignUpViewController : UIViewController

@property (nonatomic, strong)   id<MainLogInSignUpInterface>    eventHandler;

@end
