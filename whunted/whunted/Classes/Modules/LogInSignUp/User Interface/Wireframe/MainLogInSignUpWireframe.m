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
#import "Utilities.h"

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
- (void) presentTermsOfServiceFromMainLogInSignUpInterface
//---------------------------------------------------------------------------------------------------------------------------
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://whunted.com/Termsofservice.html"]];
    [webView loadRequest:request];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [Utilities customizeTitleLabel:NSLocalizedString(@"Terms of Service", nil) forViewController:viewController];
    viewController.view = webView;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -11.0f;
    
    viewController.navigationItem.leftBarButtonItems = @[spacer, [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissTermOfServiceView)]];
    
    UINavigationController *termOfServiceNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [_mainLogInSignUpVC presentViewController:termOfServiceNavController animated:YES completion:nil];
}

@end
