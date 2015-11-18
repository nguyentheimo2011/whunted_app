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
    [self addScrollView];
    [self addPhoneVerficationLabel];
    [self addVerificationsBenefitsLabel];
    [self addInputTableView];
    [self initCountryNameCell];
    [self initPhoneNumberCell];
    [self initButtonCell];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//-----------------------------------------------------------------------------------------------------------------------------
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
    CGFloat kTableHeight    =   170.0f;
    
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
    
    CGFloat kIconWidth      =   25.0f;
    CGFloat kIconHeight     =   25.0f;
    CGFloat kIconOriginX    =   5.0f;
    CGFloat kIconOriginY    =   (kCellHeight - kIconHeight) / 2;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconOriginX, kIconOriginY, kIconWidth, kIconHeight)];
    iconImageView.image = [UIImage imageNamed:@"phone_icon.png"];
    [_phoneNumberCell addSubview:iconImageView];
    
    CGFloat kTextFieldOriginX   =   _countryNameLabel.frame.origin.x;
    CGFloat kTextFieldOriginY   =   kIconOriginY;
    CGFloat kTextFieldWidth     =   _countryNameLabel.frame.size.width;
    CGFloat kTextFieldHeight    =   kIconHeight;
    
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldOriginX, kTextFieldOriginY, kTextFieldWidth, kTextFieldHeight)];
    _phoneNumberTextField.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    _phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"+886 111 111111", nil) attributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE]}];
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
    CGFloat kButtonWidth    =   _inputTableView.frame.size.width - 2 * kButtonOriginX;
    CGFloat kButtonHeight   =   50.0f;
    
    JTImageButton *continueButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, 0, kButtonWidth, kButtonHeight)];
    [continueButton createTitle:NSLocalizedString(@"CONTINUE", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE] iconOffsetY:0];
    continueButton.titleColor = [UIColor whiteColor];
    continueButton.borderWidth = 0;
    continueButton.bgColor = FLAT_FRESH_RED_COLOR;
    continueButton.cornerRadius = 8.0f;
    [_buttonCell addSubview:continueButton];
}


#pragma mark - Event Handler

//-----------------------------------------------------------------------------------------------------------------------------
- (void) backButtonTapEventHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDatasource method

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 2;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return 2;
    else
        return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            return _countryNameCell;
        else
            return _phoneNumberCell;
    }
    else if (indexPath.section == 1)
    {
        return _buttonCell;
    }
    
    return [[UITableViewCell alloc] init];
}


#pragma mark - UITableViewDelegate method

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (section == 1)
        return 30.0f;
    else
        return 0;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    return headerView;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
        return 45.0f;
    else
        return 50.0f;
}

@end
