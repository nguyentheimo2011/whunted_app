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

#import <JTImageButton.h>

#define     kLeftMargin             20.0f

@implementation VerificationCodeRequesterVC
{
    UIScrollView        *_scrollView;
    
    UILabel             *_phoneVerificationLabel;
    UILabel             *_verificationsBenefitsLabel;
    UILabel             *_countryNameLabel;
    UILabel             *_countryCodeLabel;
    UILabel             *_disclaimerLabel;
    
    UITableView         *_inputTableView;
    
    UITableViewCell     *_countryNameCell;
    UITableViewCell     *_phoneNumberCell;
    UITableViewCell     *_buttonCell;
    
    UITextField         *_phoneNumberTextField;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
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
    [self addScrollView];
    [self addPhoneVerficationLabel];
    [self addVerificationsBenefitsLabel];
    [self addInputTableView];
    [self initCountryNameCell];
    [self initPhoneNumberCell];
    [self initButtonCell];
    [self addDisclaimerLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//-----------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(WINSIZE.width, WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self]);
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
    [_scrollView addSubview:_verificationsBenefitsLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addInputTableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kTableOriginY   =   _verificationsBenefitsLabel.frame.origin.y + _verificationsBenefitsLabel.frame.size.height + 20.0f;
    CGFloat kTableWidth     =   WINSIZE.width - 2 * kLeftMargin;
    CGFloat kTableHeight    =   165.0f;
    
    _inputTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftMargin, kTableOriginY, kTableWidth, kTableHeight)];
    _inputTableView.delegate = self;
    _inputTableView.dataSource = self;
    _inputTableView.scrollEnabled = NO;
    [_scrollView addSubview:_inputTableView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initCountryNameCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kCellWidth  =   WINSIZE.width - 2 * kLeftMargin;
    CGFloat kCellHeight =   45.0f;
    
    _countryNameCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
    _countryNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _countryNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CGFloat kIconWidth      =   25.0f;
    CGFloat kIconHeight     =   25.0f;
    CGFloat kIconOriginX    =   5.0f;
    CGFloat kIconOriginY    =   (kCellHeight - kIconHeight) / 2;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconOriginX, kIconOriginY, kIconWidth, kIconHeight)];
    iconImageView.image = [UIImage imageNamed:@"country_icon.png"];
    [_countryNameCell addSubview:iconImageView];
    
    CGFloat kLabelOriginX   =   kIconOriginX + kIconWidth + 10.0f;
    CGFloat kLabelOriginY   =   kIconOriginY;
    CGFloat kLabelWidth     =   _inputTableView.frame.size.width - kLabelOriginX - 30.0f;
    CGFloat kLabelHeight    =   kIconHeight;
    
    _countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _countryNameLabel.text = NSLocalizedString(@"Taiwan", nil);
    _countryNameLabel.textColor = TEXT_COLOR_LESS_DARK;
    _countryNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    [_countryNameCell addSubview:_countryNameLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initPhoneNumberCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kCellWidth  =   WINSIZE.width - 2 * kLeftMargin;
    CGFloat kCellHeight =   45.0f;
    
    _phoneNumberCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
    _phoneNumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // add a phone icon to the left of the cell
    CGFloat kIconWidth      =   25.0f;
    CGFloat kIconHeight     =   25.0f;
    CGFloat kIconOriginX    =   5.0f;
    CGFloat kIconOriginY    =   (kCellHeight - kIconHeight) / 2;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconOriginX, kIconOriginY, kIconWidth, kIconHeight)];
    iconImageView.image = [UIImage imageNamed:@"phone_icon.png"];
    [_phoneNumberCell addSubview:iconImageView];
    
    // add a label to cell to display country code of phone number
    CGFloat kLabelHeight    =   20.0f;
    CGFloat kLabelOriginX   =   _countryNameLabel.frame.origin.x;
    CGFloat kLabelOriginY   =   (kCellHeight - kLabelHeight) / 2;
    
    _countryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, 0, kLabelHeight)];
    _countryCodeLabel.text = NSLocalizedString(@"+886", nil);
    _countryCodeLabel.textColor = TEXT_COLOR_LESS_DARK;
    _countryCodeLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    [_countryCodeLabel sizeToFit];
    [_phoneNumberCell addSubview:_countryCodeLabel];
    
    // add a text field for user to enter phone number
    CGFloat kTextFieldOriginX   =   _countryCodeLabel.frame.origin.x + _countryCodeLabel.frame.size.width + 5.0f;
    CGFloat kTextFieldOriginY   =   kIconOriginY;
    CGFloat kTextFieldWidth     =   _countryNameLabel.frame.size.width;
    CGFloat kTextFieldHeight    =   kIconHeight;
    
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldOriginX, kTextFieldOriginY, kTextFieldWidth, kTextFieldHeight)];
    _phoneNumberTextField.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    _phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"900111222", nil) attributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE]}];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTextField.delegate = self;
    [_phoneNumberCell addSubview:_phoneNumberTextField];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initButtonCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kCellWidth  =   WINSIZE.width - 2 * kLeftMargin;
    CGFloat kCellHeight =   45.0f;
    
    _buttonCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
    _buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat kButtonOriginX  =   20.0f;
    CGFloat kButtonOriginY  =   25.0f;
    CGFloat kButtonWidth    =   _inputTableView.frame.size.width - 2 * kButtonOriginX;
    CGFloat kButtonHeight   =   50.0f;
    
    JTImageButton *continueButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [continueButton createTitle:NSLocalizedString(@"CONTINUE", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE] iconOffsetY:0];
    continueButton.titleColor = [UIColor whiteColor];
    continueButton.borderWidth = 0;
    continueButton.bgColor = FLAT_FRESH_RED_COLOR;
    continueButton.cornerRadius = 8.0f;
    [_buttonCell addSubview:continueButton];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addDisclaimerLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kLabelOriginX   =   kLeftMargin + 10.0f;
    CGFloat kLabelOriginY   =   _inputTableView.frame.origin.y + _inputTableView.frame.size.height + 10.0f;
    CGFloat kLabelWidth     =   WINSIZE.width - 2 * kLabelOriginX;
    
    _disclaimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, 0)];
    _disclaimerLabel.text = NSLocalizedString(@"Your phone number is only used for verification!", nil);
    _disclaimerLabel.textColor = TEXT_COLOR_LESS_DARK;
    _disclaimerLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    _disclaimerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _disclaimerLabel.numberOfLines = 0;
    [_disclaimerLabel sizeToFit];
    
    _disclaimerLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, _disclaimerLabel.frame.size.height);
    _disclaimerLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_disclaimerLabel];
}

#pragma mark - Event Handler

//-----------------------------------------------------------------------------------------------------------------------------
- (void) backButtonTapEventHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) keyboardDidShowEventHandler: (NSNotification *) notification
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat keyboardHeight = [Utilities getHeightOfKeyboard:notification];
    CGFloat viewContentHeight = _disclaimerLabel.frame.origin.y + _disclaimerLabel.frame.size.height;
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


#pragma mark - UITableViewDatasource method

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 3;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0)
        return _countryNameCell;
    else if (indexPath.row == 1)
        return _phoneNumberCell;
    else
        return _buttonCell;
}


#pragma mark - UITableViewDelegate method

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 0;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 1.0f;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0)
        return 45.0f;
    else if (indexPath.row == 1)
        return 45.0f;
    else
        return 75.0f;
}


#pragma mark - UITextFieldDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(completeEditingPhoneNumber)];
    
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) completeEditingPhoneNumber
//-----------------------------------------------------------------------------------------------------------------------------
{
    [_phoneNumberTextField resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [_scrollView setContentOffset:CGPointMake(0, -[Utilities getHeightOfNavigationAndStatusBars:self]) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self])];
    });
}


@end
