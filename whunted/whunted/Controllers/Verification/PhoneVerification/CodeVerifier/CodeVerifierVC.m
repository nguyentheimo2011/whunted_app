//
//  CodeVerifierVC.m
//  whunted
//
//  Created by thomas nguyen on 19/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "CodeVerifierVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>

#define     kLeftMargin     20.0f

@implementation CodeVerifierVC
{
    UIScrollView                *_scrollView;
    
    UILabel                     *_phoneVerificationLabel;
    UILabel                     *_instructionLabel;
    
    UITextField                 *_codeTextField;
    
    JTImageButton               *_verificationButton;
}

@synthesize usersPhoneNumber    =   _usersPhoneNumber;

//---------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//---------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self registerNotificationListeners];
    
    [self customizeUI];
    [self loadUI];
}


#pragma mark - Setup

//-----------------------------------------------------------------------------------------------------------------------------
- (void) registerNotificationListeners
//-----------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowEventHandler:) name:UIKeyboardDidShowNotification object:nil];
}


#pragma mark - UI Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//---------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Phone Verification", nil) forViewController:self];
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topLeftBackButtonEventHandler)];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) loadUI
//---------------------------------------------------------------------------------------------------------------------------
{
    [self addScrollView];
    [self addPhoneVerficationLabel];
    [self addVerificationInstructionLabel];
    [self addCodeTextField];
    [self addVerificationButton];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//---------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addPhoneVerficationLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    _phoneVerificationLabel = [[UILabel alloc] init];
    _phoneVerificationLabel.text = NSLocalizedString(@"PHONE VERIFICATION", nil);
    _phoneVerificationLabel.textColor = TEXT_COLOR_LESS_DARK;
    _phoneVerificationLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    [_phoneVerificationLabel sizeToFit];
    
    CGFloat kLabelOriginX   =   (WINSIZE.width - _phoneVerificationLabel.frame.size.width) / 2;
    CGFloat kLabelOriginY   =   20.0f;
    _phoneVerificationLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, _phoneVerificationLabel.frame.size.width, _phoneVerificationLabel.frame.size.height);
    [_scrollView addSubview:_phoneVerificationLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addVerificationInstructionLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kLabelOriginX   =   kLeftMargin;
    CGFloat kLabelOriginY   =   _phoneVerificationLabel.frame.origin.y + _phoneVerificationLabel.frame.size.height + 20.0f;
    CGFloat kLabelWidth     =   WINSIZE.width - 2 * kLabelOriginX;
    NSString *instruction = [NSString stringWithFormat:@"%@%@. %@", NSLocalizedString(@"An SMS message has been sent to", nil), _usersPhoneNumber, NSLocalizedString(@"Please enter the 6-digit confirmation code:", nil)];
    
    _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, 0)];
    _instructionLabel.text = instruction;
    _instructionLabel.textColor = TEXT_COLOR_LESS_DARK;
    _instructionLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    _instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _instructionLabel.numberOfLines = 0;
    [_instructionLabel sizeToFit];
    _instructionLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, _instructionLabel.frame.size.height);
    _instructionLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_instructionLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addCodeTextField
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kTextFieldOriginX       =       30.0f;
    CGFloat kTextFieldOriginY       =       _instructionLabel.frame.origin.y + _instructionLabel.frame.size.height + 15.0f;
    CGFloat kTextFieldWidth         =       WINSIZE.width - 2 * kTextFieldOriginX;
    CGFloat kTextFieldHeight        =       40.0f;
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldOriginX, kTextFieldOriginY, kTextFieldWidth, kTextFieldHeight)];
    _codeTextField.textColor = TEXT_COLOR_LESS_DARK;
    _codeTextField.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    _codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"123456", nil) attributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE]}];
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.delegate = self;
    _codeTextField.layer.borderWidth = 1.0f;
    _codeTextField.layer.borderColor = [TEXT_COLOR_GRAY CGColor];
    _codeTextField.layer.cornerRadius = 8.0f;
    [Utilities addLeftPaddingToTextField:_codeTextField];
    [_scrollView addSubview:_codeTextField];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addVerificationButton
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kButtonOriginX      =       30.0f;
    CGFloat kButtonOriginY      =       _codeTextField.frame.origin.y + _codeTextField.frame.size.height + 25.0f;
    CGFloat KButtonWidth        =       WINSIZE.width - 2 * kButtonOriginX;
    CGFloat kButtonHeight       =       45.0f;
    
    _verificationButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, KButtonWidth, kButtonHeight)];
    [_verificationButton createTitle:NSLocalizedString(@"VERIFY", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE] iconOffsetY:0];
    _verificationButton.titleColor = [UIColor whiteColor];
    _verificationButton.bgColor = FLAT_FRESH_RED_COLOR;
    _verificationButton.borderWidth = 0;
    _verificationButton.cornerRadius = 8.0f;
    [_verificationButton addTarget:self action:@selector(verificationButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_verificationButton];
}


#pragma mark - Event Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) topLeftBackButtonEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) keyboardDidShowEventHandler: (NSNotification *) notification
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat keyboardHeight = [Utilities getHeightOfKeyboard:notification];
    CGFloat viewContentHeight = _verificationButton.frame.origin.y + _verificationButton.frame.size.height;
    CGFloat newContentHeight = keyboardHeight + viewContentHeight + 20.0f;
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, newContentHeight)];
    
    // before keyboard appears, content offset is (0,-64).
    // after keyboard appears, content offset is adjusted accordingly to make important content visible
    CGFloat offsetY = newContentHeight - WINSIZE.height;
    
    // if after keyboard is shown, it covers any content, then make the _scrollView scroll up.
    if (offsetY > -[Utilities getHeightOfNavigationAndStatusBars:self])
    {
        [_scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) verificationButtonTapEventHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [_codeTextField resignFirstResponder];
    
    if (_codeTextField.text.length != 6)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Your code you entered is incorrect.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
        
        [PFCloud callFunctionInBackground:@"verifyPhoneNumber" withParameters:@{@"phoneVerificationCode" : _codeTextField.text} block:^(id  _Nullable object, NSError * _Nullable error)
        {
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            
            if (error)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Your code you entered is incorrect.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Yay!", nil) message:NSLocalizedString(@"Your phone number has been verified.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}


#pragma mark - UITextFieldDelegate methods

//---------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//---------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(completeEditingCodeTextField)];
    
    return YES;
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) completeEditingCodeTextField
//---------------------------------------------------------------------------------------------------------------------------
{
    [_codeTextField resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [_scrollView setContentOffset:CGPointMake(0, -[Utilities getHeightOfNavigationAndStatusBars:self]) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self])];
    });
}


#pragma mark - UIAlertViewDelegate methods

//---------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//---------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 0)
    {
        // Notify User Profile to update its data after phone verification
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_PROFILE_UPDATED_EVENT object:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
