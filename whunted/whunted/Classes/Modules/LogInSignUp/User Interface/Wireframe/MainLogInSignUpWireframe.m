//
//  MainLogInSignUpWireframe.m
//  whunted
//
//  Created by thomas nguyen on 26/12/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MainLogInSignUpWireframe.h"
#import "MainLogInSignUpViewController.h"
#import "MainLogInSignUpPresenter.h"

@implementation MainLogInSignUpWireframe

@synthesize mainLogInSignUpEventHandler     =   _mainLogInSignUpEventHandler;

//---------------------------------------------------------------------------------------------------------------------------
- (void) presentMainLogInSignUpInterfaceFromWindow:(UIWindow *)window
//---------------------------------------------------------------------------------------------------------------------------
{
    if (!_mainLogInSignUpEventHandler)
        _mainLogInSignUpEventHandler = [[MainLogInSignUpPresenter alloc] init];
    
    MainLogInSignUpViewController *loginVC = [[MainLogInSignUpViewController alloc] init];
    loginVC.eventHandler = _mainLogInSignUpEventHandler;
    
    if (window.rootViewController)
        [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    [window setRootViewController:loginVC];
}

@end
