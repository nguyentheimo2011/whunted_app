//
//  PasswordResetVC.m
//  whunted
//
//  Created by thomas nguyen on 21/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "PasswordResetVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>
#import <AFNetworking.h>

#define     kLeftMargin     15.0f

@implementation PasswordResetVC
{
    UIView          *_viewContainer;
    UILabel         *_askingForEmailLabel;
    UILabel         *_successMessageLabel;
    UIView          *_successMessageContainer;
    UITextField     *_emailTextField;
    JTImageButton   *_sendButton;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    [self customizeUI];
    [self addViewContainer];
    [self addAskingForEmailLabel];
    [self addSuccessMessageLabel];
    [self addTextFieldForEmail];
    [self addButtonForSendingPasswordResetLink];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Password Reset", nil) forViewController:self];
    
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closePasswordResetView)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addViewContainer
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kOriginY = [Utilities getHeightOfNavigationAndStatusBars:self] + 30.0f;
    
    _viewContainer = [[UIView alloc] initWithFrame:CGRectMake(kLeftMargin, kOriginY, WINSIZE.width - 2 * kLeftMargin, 0)];
    _viewContainer.backgroundColor = [UIColor whiteColor];
    _viewContainer.layer.cornerRadius = 10.0f;
    [Utilities addShadowToView:_viewContainer];
    [self.view addSubview:_viewContainer];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addAskingForEmailLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _askingForEmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f, WINSIZE.width - 2 * kLeftMargin - 20.0f, 0)];
    _askingForEmailLabel.text = NSLocalizedString(@"Please enter the email address of your account.", nil);
    _askingForEmailLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _askingForEmailLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _askingForEmailLabel.numberOfLines = 2;
    _askingForEmailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_askingForEmailLabel sizeToFit];
    _askingForEmailLabel.frame = CGRectMake(_askingForEmailLabel.frame.origin.x, _askingForEmailLabel.frame.origin.y, WINSIZE.width - 2 * kLeftMargin - 20.0f, _askingForEmailLabel.frame.size.height);
    [_viewContainer addSubview:_askingForEmailLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSuccessMessageLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kOriginY = _askingForEmailLabel.frame.origin.y + _askingForEmailLabel.frame.size.height + 10.0f;
    
    _successMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 15.0f, WINSIZE.width - 2 * kLeftMargin - 80.0f, 0)];
    _successMessageLabel.text = NSLocalizedString(@"Instructions on how to reset password has been sent to your email address.", nil);
    _successMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE];;
    _successMessageLabel.textColor = TEXT_GREEN_COLOR;
    _successMessageLabel.numberOfLines = 2;
    _successMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_successMessageLabel sizeToFit];
    
    _successMessageContainer = [[UIView alloc] initWithFrame:CGRectMake(20.0f, kOriginY, WINSIZE.width - 2 * kLeftMargin - 40.0f, _successMessageLabel.frame.size.height + 30.0f)];
    _successMessageContainer.backgroundColor = BACKGROUND_GREEN_COLOR;
    _successMessageContainer.layer.cornerRadius = 5.0f;
    _successMessageContainer.clipsToBounds = YES;
    [_successMessageContainer addSubview:_successMessageLabel];
    [_viewContainer addSubview:_successMessageContainer];
    
    _successMessageContainer.hidden = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTextFieldForEmail
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kOriginY = _askingForEmailLabel.frame.origin.y + _askingForEmailLabel.frame.size.height + 10.0f;
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, kOriginY, _askingForEmailLabel.frame.size.width, 50.0f)];
    _emailTextField.textColor = TEXT_COLOR_DARK_GRAY;
    _emailTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Enter your email address", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _emailTextField.textAlignment = NSTextAlignmentLeft;
    _emailTextField.layer.borderColor = [PLACEHOLDER_TEXT_COLOR CGColor];
    _emailTextField.layer.borderWidth = 0.5f;
    _emailTextField.layer.cornerRadius = 5.0f;
    _emailTextField.returnKeyType = UIReturnKeyDone;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailTextField.delegate = self;
    [Utilities addLeftPaddingToTextField:_emailTextField];
    [_viewContainer addSubview:_emailTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addButtonForSendingPasswordResetLink
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kOriginY = _emailTextField.frame.origin.y + _emailTextField.frame.size.height + 15.0f;
    
    _sendButton = [[JTImageButton alloc] initWithFrame:CGRectMake(10.0f, kOriginY, _askingForEmailLabel.frame.size.width, 50.0f)];
    [_sendButton createTitle:NSLocalizedString(@"Send me a password reset link.", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
    _sendButton.titleColor = [UIColor whiteColor];
    _sendButton.borderWidth = 0;
    _sendButton.cornerRadius = 5.0f;
    _sendButton.bgColor = MAIN_BLUE_COLOR;
    [_sendButton addTarget:self action:@selector(sendingButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_viewContainer addSubview:_sendButton];
    
    _viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x, _viewContainer.frame.origin.y, _viewContainer.frame.size.width, _sendButton.frame.origin.y + _sendButton.frame.size.height + 15.0f);
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) makeSuccessMessageLabelVisible
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_successMessageContainer.hidden)
    {
        _successMessageContainer.hidden = NO;
        
        CGFloat const kTextFieldOriginY = _successMessageContainer.frame.origin.y + _successMessageContainer.frame.size.height + 15.0f;
        _emailTextField.frame = CGRectMake(_emailTextField.frame.origin.x, kTextFieldOriginY, _emailTextField.frame.size.width, _emailTextField.frame.size.height);
        
        CGFloat const kButtonOriginY = _emailTextField.frame.origin.y + _emailTextField.frame.size.height + 15.0f;
        _sendButton.frame = CGRectMake(_sendButton.frame.origin.x, kButtonOriginY, _sendButton.frame.size.width, _sendButton.frame.size.height);
        
        _viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x, _viewContainer.frame.origin.y, _viewContainer.frame.size.width, _sendButton.frame.origin.y + _sendButton.frame.size.height + 15.0f);
    }
}


#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) closePasswordResetView
//------------------------------------------------------------------------------------------------------------------------------
{
    [_emailTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) sendingButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_emailTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Email cannot be blank", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        if ([Utilities isEmailValid:_emailTextField.text])
        {
            [self sendResettingPasswordRequest];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Invalid email!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertView show];
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) sendResettingPasswordRequest
//------------------------------------------------------------------------------------------------------------------------------
{
    [_emailTextField resignFirstResponder];
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [BASE_URL stringByAppendingString:@"/forgotPassword"];
    [manager POST:url parameters:@{@"email": _emailTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        
        NSDictionary *resultDict = responseObject;
        NSString *resultCode = resultDict[RESPONSE_RESULT_CODE];
        if ([resultCode isEqualToString:@"400"])
        {
            [Utilities displayErrorAlertViewWithMessage:NSLocalizedString(@"It seems that you did not use this email to register with us.", nil)];
        }
        else if ([resultCode isEqualToString:@"500"])
        {
            [Utilities displayErrorAlertView];
        }
        else
        {
            _emailTextField.text = nil;
            [self makeSuccessMessageLabelVisible];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - UITextFieldDelegate functions

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
