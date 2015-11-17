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
{
    UILabel             *_phoneVerificationLabel;
    UILabel             *_verificationsBenefitsLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self customizeUI];
    [self loadUI];
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

//-----------------------------------------------------------------------------------------------------------------------------
- (void) loadUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self addPhoneVerficationLabel];
    [self addVerificationsBenefitsLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addPhoneVerficationLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    _phoneVerificationLabel = [[UILabel alloc] init];
    _phoneVerificationLabel.text = NSLocalizedString(@"PHONE VERIFICATION", nil);
    _phoneVerificationLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _phoneVerificationLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    [_phoneVerificationLabel sizeToFit];
    
    CGFloat kLabelOriginX   =   (WINSIZE.width - _phoneVerificationLabel.frame.size.width) / 2;
    CGFloat kLabelOriginY   =   [Utilities getHeightOfNavigationAndStatusBars:self] + 20.0f;
    _phoneVerificationLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, _phoneVerificationLabel.frame.size.width, _phoneVerificationLabel.frame.size.height);
    [self.view addSubview:_phoneVerificationLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addVerificationsBenefitsLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kLabelOriginX   =   40.0f;
    CGFloat kLabelOriginY   =   _phoneVerificationLabel.frame.origin.y + _phoneVerificationLabel.frame.size.height + 5.0f;
    CGFloat kLabelWidth     =   WINSIZE.width - 2 * kLabelOriginX;
    
    _verificationsBenefitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, 0)];
    _verificationsBenefitsLabel.text = NSLocalizedString(@"Increase trust between you and other buyers and sellers with phone verification", nil);
    _verificationsBenefitsLabel.textColor = TEXT_COLOR_LESS_DARK;
    _verificationsBenefitsLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    _verificationsBenefitsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _verificationsBenefitsLabel.numberOfLines = 0;
    [_verificationsBenefitsLabel sizeToFit];
    _verificationsBenefitsLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, _verificationsBenefitsLabel.frame.size.height);
    _verificationsBenefitsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_verificationsBenefitsLabel];
    
}


#pragma mark - Event Handler

//-----------------------------------------------------------------------------------------------------------------------------
- (void) backButtonTapEventHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
