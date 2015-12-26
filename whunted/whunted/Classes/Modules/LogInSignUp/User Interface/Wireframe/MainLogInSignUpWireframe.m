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

@interface MainLogInSignUpWireframe ()

@property (nonatomic, strong) MainLogInSignUpViewController *mainLogInSignUpVC;

@end


@implementation MainLogInSignUpWireframe

@synthesize mainLogInSignUpEventHandler     =   _mainLogInSignUpEventHandler;
@synthesize mainLogInSignUpVC               =   _mainLogInSignUpVC;

//---------------------------------------------------------------------------------------------------------------------------
- (void) presentMainLogInSignUpInterfaceFromWindow:(UIWindow *)window
//---------------------------------------------------------------------------------------------------------------------------
{
    if (!_mainLogInSignUpEventHandler)
        _mainLogInSignUpEventHandler = [[MainLogInSignUpPresenter alloc] init];
    
    _mainLogInSignUpVC = [[MainLogInSignUpViewController alloc] init];
    _mainLogInSignUpVC.eventHandler = _mainLogInSignUpEventHandler;
    
    if (window.rootViewController)
        [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    [window setRootViewController:_mainLogInSignUpVC];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) presentTermsOfService
//---------------------------------------------------------------------------------------------------------------------------
{
    
}

@end
