//
//  VerificationCodeRequesterVC.m
//  whunted
//
//  Created by thomas nguyen on 17/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "VerificationCodeRequesterVC.h"
#import "Utilities.h"
#import "AppConstant.h"

@implementation VerificationCodeRequesterVC

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self customizeUI];
}


#pragma mark - UI Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeBackButtonForViewController:self withAction:@selector(backButtonTapEventHandler)];
    [Utilities customizeTitleLabel:NSLocalizedString(@"Phone Verification", nil) forViewController:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Event Handler

//-----------------------------------------------------------------------------------------------------------------------------
- (void) backButtonTapEventHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
