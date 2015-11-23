//
//  CompletedVerificationVC.m
//  whunted
//
//  Created by thomas nguyen on 23/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "CompletedVerificationVC.h"
#import "VerificationCodeRequesterVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>

@implementation CompletedVerificationVC
{
    UIImageView             *_phoneImageView;
    
    UILabel                 *_infoLabel;
    
    JTImageButton           *_phoneNumberChangeButton;
}


//----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self loadUI];
}


#pragma mark - UI Handlers

//----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topLeftBackButtonEventHandler)];
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Phone Verification", nil) forViewController:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) loadUI
//----------------------------------------------------------------------------------------------------------------------------
{
    [self addPhoneImage];
    [self addInfoLabel];
    [self addPhoneNumberChangeButton];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) addPhoneImage
//----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kImageViewWidth     =   100.0f;
    CGFloat kImageViewHeight    =   kImageViewWidth;
    CGFloat kImageViewOriginX   =   (WINSIZE.width - kImageViewWidth) / 2;
    CGFloat kImageViewOriginY   =   [Utilities getHeightOfNavigationAndStatusBars:self] + 25.0f;
    
    _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    _phoneImageView.image = [UIImage imageNamed:@"big_verified_phone_icon.png"];
    [self.view addSubview:_phoneImageView];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) addInfoLabel
//----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kLabelOriginX   =   20.0f;
    CGFloat kLabelOriginY   =   _phoneImageView.frame.origin.y + _phoneImageView.frame.size.height + 15.0f;
    CGFloat kLabelWidth     =   WINSIZE.width - 2 * kLabelOriginX;
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, 0)];
    _infoLabel.text = NSLocalizedString(@"Your phone number has already been verified.", nil);
    _infoLabel.textColor = MAIN_BLUE_COLOR_WITH_DARK;
    _infoLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _infoLabel.numberOfLines = 0;
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.layer.cornerRadius = 8.0f;
    _infoLabel.layer.masksToBounds = YES;
    [_infoLabel sizeToFit];
    
    CGFloat kLabelHeight    =   _infoLabel.frame.size.height + 20.0f;
    _infoLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight);
    
    [self.view addSubview:_infoLabel];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) addPhoneNumberChangeButton
//----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kButtonOriginX  =   20.0f;
    CGFloat kButtonOriginY  =   _infoLabel.frame.origin.y + _infoLabel.frame.size.height + 20.0f;
    CGFloat kButtonWidth    =   WINSIZE.width - 2 * kButtonOriginX;
    CGFloat kButtonHeight   =   45.0f;
    
    _phoneNumberChangeButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_phoneNumberChangeButton createTitle:NSLocalizedString(@"Change phone number", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
    _phoneNumberChangeButton.titleColor = [UIColor whiteColor];
    _phoneNumberChangeButton.bgColor = FLAT_FRESH_RED_COLOR;
    _phoneNumberChangeButton.borderWidth = 0;
    _phoneNumberChangeButton.cornerRadius = 8.0;
    [_phoneNumberChangeButton addTarget:self action:@selector(phoneNumberChangeButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phoneNumberChangeButton];
}


#pragma mark - Event Handlers

//----------------------------------------------------------------------------------------------------------------------------
- (void) topLeftBackButtonEventHandler
//----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) phoneNumberChangeButtonTapEventHandler
//----------------------------------------------------------------------------------------------------------------------------
{
    VerificationCodeRequesterVC *codeRequesterVC = [[VerificationCodeRequesterVC alloc] init];
    [self.navigationController pushViewController:codeRequesterVC animated:YES];
}

@end
