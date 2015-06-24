//
//  UserProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AppConstant.h"

#import <Parse/Parse.h>

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:LIGHTEST_GRAY_COLOR];
    [self addLogoutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addLogoutButton
{
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width/2 - 210.0/2, WINSIZE.height/2 - 60.0/2, 210, 60)];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClickedHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}

#pragma mark - Event Handlers
- (void) logoutButtonClickedHandler
{
    [delegate userProfileViewController:self didPressLogout:YES];
}

@end
