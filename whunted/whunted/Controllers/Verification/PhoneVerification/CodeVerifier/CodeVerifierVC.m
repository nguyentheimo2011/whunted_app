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
    [self customizeUI];
    [self loadUI];
}


#pragma mark - Data Initializer

//---------------------------------------------------------------------------------------------------------------------------
- (void) initData
//---------------------------------------------------------------------------------------------------------------------------
{
    
}


#pragma mark - UI Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//---------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Phone Verification", nil) forViewController:self];
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topRightBackButtonEventHandler)];
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
    _codeTextField.font = [UIFont fontWithName:BOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
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
    [_scrollView addSubview:_verificationButton];
}


#pragma mark - Event Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) topRightBackButtonEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
