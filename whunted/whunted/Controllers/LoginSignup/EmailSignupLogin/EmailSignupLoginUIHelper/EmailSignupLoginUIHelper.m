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
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE]} forState:UIControlStateNormal];
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
    signupDisclaimerLabel1.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:13];
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
    [termOfServiceButton createTitle:NSLocalizedString(@"Terms of Service", nil) withIcon:nil font:[UIFont fontWithName:BOLD_FONT_NAME size:13] iconOffsetY:0];
    termOfServiceButton.titleColor = RED_COLOR_WITH_DARK_1;
    termOfServiceButton.borderWidth = 0;
    [termOfServiceButton addTarget:viewController action:@selector(termsOfServiceButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [termOfServiceButton sizeToFit];
    
    UILabel *disclaimerLabel = [[UILabel alloc] init];
    disclaimerLabel.text = [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"and", nil)];
    disclaimerLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:13];
    disclaimerLabel.textColor = TEXT_COLOR_GRAY;
    [disclaimerLabel sizeToFit];
    
    JTImageButton *privacyPoliciesButton = [[JTImageButton alloc] init];
    [privacyPoliciesButton createTitle:NSLocalizedString(@"Privacy Policy", nil) withIcon:nil font:[UIFont fontWithName:BOLD_FONT_NAME size:13] iconOffsetY:0];
    privacyPoliciesButton.titleColor = RED_COLOR_WITH_DARK_1;
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

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) addForgotPasswordButtonToView:(UIView *)container inViewController:(UIViewController<EmailSignupLoginEventHandler> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *forgotPasswordButton = [[JTImageButton alloc] init];
    [forgotPasswordButton createTitle:NSLocalizedString(@"Forgot Password?", nil) withIcon:nil font:[UIFont fontWithName:BOLD_FONT_NAME size:13] iconOffsetY:0];
    forgotPasswordButton.titleColor = RED_COLOR_WITH_DARK_1;
    forgotPasswordButton.borderWidth = 0;
    [forgotPasswordButton addTarget:viewController action:@selector(forgotPasswordButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [forgotPasswordButton sizeToFit];
    
    CGFloat kButtonOriginX = (WINSIZE.width - forgotPasswordButton.frame.size.width) / 2;
    CGFloat kButtonOriginY = 2 * kTableViewCellHeight + 12.0f;
    forgotPasswordButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, forgotPasswordButton.frame.size.width, forgotPasswordButton.frame.size.height);
    [container addSubview:forgotPasswordButton];    
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) initUsernameSignupCellInViewController: (UIViewController<UITextFieldDelegate> *) viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *usernameSignUpCell = [[UITableViewCell alloc] init];
    usernameSignUpCell.textLabel.text = NSLocalizedString(@"Username", nil);
    usernameSignUpCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    usernameSignUpCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 125.0f * WINSIZE.width/320, 30)];
    [textField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Choose a username", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]}];
    textField.delegate = viewController;
    textField.tag = kUsernameSignupTextFieldTag;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 2, 0);
    usernameSignUpCell.accessoryView = textField;
    usernameSignUpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return @[usernameSignUpCell, textField];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) initEmailSignupCellInViewController:(UIViewController<UITextFieldDelegate> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *emailSignUpCell = [[UITableViewCell alloc] init];
    emailSignUpCell.textLabel.text = NSLocalizedString(@"Email", nil);
    emailSignUpCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    emailSignUpCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 125.0f * WINSIZE.width/320, 30)];
    [textField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Your email", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]}];
    textField.delegate = viewController;
    textField.tag = kEmailSignupTextFieldTag;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 2, 0);
    emailSignUpCell.accessoryView = textField;
    emailSignUpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return @[emailSignUpCell, textField];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) initPasswordSignupCellInViewController:(UIViewController<UITextFieldDelegate> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *passwordSignupCell = [[UITableViewCell alloc] init];
    passwordSignupCell.textLabel.text = NSLocalizedString(@"Password", nil);
    passwordSignupCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    passwordSignupCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 125.0f * WINSIZE.width/320, 30)];
    [textField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Choose a password", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]}];
    textField.delegate = viewController;
    textField.tag = kPasswordSignupTextFieldTag;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = YES;
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 2, 0);
    passwordSignupCell.accessoryView = textField;
    passwordSignupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return @[passwordSignupCell, textField];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) initEmailLoginCellInViewController:(UIViewController<UITextFieldDelegate> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *emailLoginCell = [[UITableViewCell alloc] init];
    emailLoginCell.textLabel.text = NSLocalizedString(@"Email", nil);
    emailLoginCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    emailLoginCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 125.0f * WINSIZE.width/320, 30)];
    [textField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Your email", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]}];
    textField.delegate = viewController;
    textField.tag = kEmailLoginTextFieldTag;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 2, 0);
    emailLoginCell.accessoryView = textField;
    emailLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return @[emailLoginCell, textField];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) initPasswordLoginCellInViewController:(UIViewController<UITextFieldDelegate> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *passwordLoginCell = [[UITableViewCell alloc] init];
    passwordLoginCell.textLabel.text = NSLocalizedString(@"Password", nil);
    passwordLoginCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    passwordLoginCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 125.0f * WINSIZE.width/320, 30)];
    [textField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]}];
    textField.delegate = viewController;
    textField.tag = kPasswordSignupTextFieldTag;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = YES;
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 2, 0);
    passwordLoginCell.accessoryView = textField;
    passwordLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return @[passwordLoginCell, textField];
}

@end
