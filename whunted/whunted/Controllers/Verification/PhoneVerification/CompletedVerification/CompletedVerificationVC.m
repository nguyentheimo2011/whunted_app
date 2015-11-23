//
//  CompletedVerificationVC.m
//  whunted
//
//  Created by thomas nguyen on 23/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "CompletedVerificationVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>

@implementation CompletedVerificationVC
{
    UIImageView             *_phoneImageView;
    
    UILabel                 *_phoneLabel;
    
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
    
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) addPhoneNumberChangeButton
//----------------------------------------------------------------------------------------------------------------------------
{
    
}


#pragma mark - Event Handlers

//----------------------------------------------------------------------------------------------------------------------------
- (void) topLeftBackButtonEventHandler
//----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
