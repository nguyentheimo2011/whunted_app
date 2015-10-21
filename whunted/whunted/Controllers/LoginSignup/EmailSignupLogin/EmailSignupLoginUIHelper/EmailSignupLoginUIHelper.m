//
//  EmailSignupLoginUIHelper.m
//  whunted
//
//  Created by thomas nguyen on 21/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EmailSignupLoginUIHelper.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <JTImageButton.h>

@implementation EmailSignupLoginUIHelper

//-----------------------------------------------------------------------------------------------------------------------------
+ (UISegmentedControl *) addSegmentedControlToViewController:(UIViewController<EmailSignupLoginEventHandler> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kControlWidth     =   WINSIZE.width * 0.6f;
    CGFloat const kControlHeight    =   30.0f;
    CGFloat const kControlOriginX   =   (WINSIZE.width - kControlWidth)/2;
    CGFloat const kControlOriginY   =   20.0f + [Utilities getHeightOfNavigationAndStatusBars:viewController];
    
    NSArray *categories = @[NSLocalizedString(@"Sign up", nil), NSLocalizedString(@"Log in", nil)];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    segmentedControl.frame = CGRectMake(kControlOriginX, kControlOriginY, kControlWidth, kControlHeight);
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]} forState:UIControlStateNormal];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:viewController action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    [viewController.view addSubview:segmentedControl];
    
    return segmentedControl;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (UILabel *) addSignupDisclaimerLabel1ToView:(UIView *)container
//-----------------------------------------------------------------------------------------------------------------------------
{
    UILabel *signupDisclaimerLabel1 = [[UILabel alloc] init];
    signupDisclaimerLabel1.text = NSLocalizedString(@"By proceeding, you agree to Whunted's", nil);
    signupDisclaimerLabel1.textColor = TEXT_COLOR_GRAY;
    signupDisclaimerLabel1.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
    [signupDisclaimerLabel1 sizeToFit];
    
    CGFloat const kLabelOriginX = (WINSIZE.width - signupDisclaimerLabel1.frame.size.width) / 2;
    CGFloat const kLabelOriginY = 3 * kTableViewCellHeight + 15.0f;
    signupDisclaimerLabel1.frame = CGRectMake(kLabelOriginX, kLabelOriginY, signupDisclaimerLabel1.frame.size.width, signupDisclaimerLabel1.frame.size.height);
    [container addSubview:signupDisclaimerLabel1];
    
    return signupDisclaimerLabel1;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) addSignupDisclaimerLabel2BehindLable1:(UILabel *)label1 toView:(UIView *)container inViewController:(UIViewController<EmailSignupLoginEventHandler> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *termOfServiceButton = [[JTImageButton alloc] init];
    [termOfServiceButton createTitle:NSLocalizedString(@"Terms of Service", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:13] iconOffsetY:0];
    termOfServiceButton.titleColor = LIGHTER_RED_COLOR;
    termOfServiceButton.borderWidth = 0;
    [termOfServiceButton addTarget:viewController action:@selector(termsOfServiceButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [termOfServiceButton sizeToFit];
    
    UILabel *disclaimerLabel = [[UILabel alloc] init];
    disclaimerLabel.text = [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"and", nil)];
    disclaimerLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
    disclaimerLabel.textColor = TEXT_COLOR_GRAY;
    [disclaimerLabel sizeToFit];
    
    JTImageButton *privacyPoliciesButton = [[JTImageButton alloc] init];
    [privacyPoliciesButton createTitle:NSLocalizedString(@"Privacy Policy", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:13] iconOffsetY:0];
    privacyPoliciesButton.titleColor = LIGHTER_RED_COLOR;
    privacyPoliciesButton.borderWidth = 0;
    [privacyPoliciesButton addTarget:viewController action:@selector(privacyPoliciesButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [privacyPoliciesButton sizeToFit];
    
    CGFloat totalWidth =  termOfServiceButton.frame.size.width + disclaimerLabel.frame.size.width + privacyPoliciesButton.frame.size.width;
    CGFloat kLabelOriginX   =   (WINSIZE.width - totalWidth) / 2;
    CGFloat kLabelOriginY   =   label1.frame.origin.y + label1.frame.size.height + 2.0f;
    
    CGFloat kButtonOriginY  =   kLabelOriginY - 6.0f;
    termOfServiceButton.frame = CGRectMake(kLabelOriginX, kButtonOriginY, termOfServiceButton.frame.size.width, termOfServiceButton.frame.size.height);
    [container addSubview:termOfServiceButton];
    
    CGFloat kDisclaimerLabelOriginX   =   kLabelOriginX + termOfServiceButton.frame.size.width;
    disclaimerLabel.frame = CGRectMake(kDisclaimerLabelOriginX, kLabelOriginY, disclaimerLabel.frame.size.width, disclaimerLabel.frame.size.height);
    [container addSubview:disclaimerLabel];
    
    CGFloat kButtonOriginX  =   disclaimerLabel.frame.origin.x + disclaimerLabel.frame.size.width;
    privacyPoliciesButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, privacyPoliciesButton.frame.size.width, privacyPoliciesButton.frame.size.height);
    [container addSubview:privacyPoliciesButton];
}

@end
