//
//  LoginSignupViewController.m
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LoginSignupViewController.h"

@interface LoginSignupViewController ()

@end

@implementation LoginSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addFacebookLoginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addFacebookLoginButton
{
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setBackgroundImage: [UIImage imageNamed:@"facebook_login_button.png"] forState:UIControlStateNormal];
    NSLog(@"addFacebookLoginButton width: %f, height: %f", loginButton.frame.size.width, loginButton.frame.size.height);
}

@end
