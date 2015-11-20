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

#define     kLeftMargin     20.0f

@implementation CodeVerifierVC
{
    UIScrollView                *_scrollView;
    
    UILabel                     *_phoneVerificationLabel;
    UILabel                     *_instructionLabel;
    
    UITableView                 *_inputTableView;
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
    _phoneVerificationLabel.textColor = TEXT_COLOR_DARK_GRAY;
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
    CGFloat kLabelOriginY   =   _phoneVerificationLabel.frame.origin.y + _phoneVerificationLabel.frame.size.height + 25.0f;
    CGFloat kLabelWidth     =   WINSIZE.width - 2 * kLabelOriginX;
    NSString *instruction = [NSString stringWithFormat:@"%@%@.\n@", NSLocalizedString(@"An SMS message has been sent to", nil), _usersPhoneNumber, NSLocalizedString(@"Please enter the 6-digit confirmation code:", nil)];
    
    _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, 0)];
    _instructionLabel.text = instruction;
    _instructionLabel.textColor = TEXT_COLOR_LESS_DARK;
    _instructionLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    _instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _instructionLabel.numberOfLines = 0;
    [_instructionLabel sizeToFit];
    _instructionLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, _instructionLabel.frame.size.height);
    _instructionLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_instructionLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addInputTableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kTableOriginY   =   _instructionLabel.frame.origin.y + _instructionLabel.frame.size.height + 20.0f;
    CGFloat kTableWidth     =   WINSIZE.width - 2 * kLeftMargin;
    CGFloat kTableHeight    =   165.0f;
    
    _inputTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftMargin, kTableOriginY, kTableWidth, kTableHeight)];
    _inputTableView.delegate = self;
    _inputTableView.dataSource = self;
    _inputTableView.scrollEnabled = NO;
    [_scrollView addSubview:_inputTableView];
}


#pragma mark - Event Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) topRightBackButtonEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
