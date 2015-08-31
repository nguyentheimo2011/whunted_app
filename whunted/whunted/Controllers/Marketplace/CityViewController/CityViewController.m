//
//  CityViewController.m
//  whunted
//
//  Created by thomas nguyen on 31/8/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CityViewController.h"
#import "AppConstant.h"
#import "Utilities.h"


@implementation CityViewController
{
    UILabel                 *_guidanceLabel;
    UITextField             *_cityTextField;
}

@synthesize labelTitle = _labelTitle;

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self addGuidanceLabel];
    [self addTextField];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"CityViewController didReceiveMemoryWarning");
}


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor whiteColor];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addGuidanceLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelLeftMargin  =   WINSIZE.width/10.0f;
    CGFloat const kLabelTopMargin   =   [Utilities getHeightOfNavigationAndStatusBars:self] + 10.0f;
    CGFloat const kLabelWidth       =   WINSIZE.width - 2 * kLabelLeftMargin;
    CGFloat const kLabelHeight      =   20.0f;
    
    _guidanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelTopMargin, kLabelWidth, kLabelHeight)];
    _guidanceLabel.text = @"Product Origin:";
    _guidanceLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _guidanceLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [self.view addSubview:_guidanceLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addTextField
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextFieldLeftMargin  =   WINSIZE.width/10.0f;
    CGFloat const kTextFieldTopMargin   =   10.0f;
    CGFloat const kTextFieldOriginY     =   _guidanceLabel.frame.origin.y + _guidanceLabel.frame.size.height + kTextFieldTopMargin;
    CGFloat const kTextFieldWidth       =   WINSIZE.width - 2 * kTextFieldLeftMargin;
    CGFloat const kTextFieldHeight      =   30.0f;
    
    _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldOriginY, kTextFieldWidth, kTextFieldHeight)];
    _cityTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _cityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Enter city", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]}];
    _cityTextField.returnKeyType = UIReturnKeyDone;
    _cityTextField.layer.borderWidth = 0.5f;
    _cityTextField.layer.borderColor = [TEXT_COLOR_DARK_GRAY CGColor];
    _cityTextField.layer.cornerRadius = 8.0f;
    _cityTextField.delegate = self;
    [Utilities customizeTextField:_cityTextField];
    [self.view addSubview:_cityTextField];
}


#pragma mark - UITextFieldDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
