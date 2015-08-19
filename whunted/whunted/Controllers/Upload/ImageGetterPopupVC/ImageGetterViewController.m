//
//  UploadMethodViewController.m
//  whunted
//
//  Created by thomas nguyen on 12/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ImageGetterViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation ImageGetterViewController

@synthesize takingPhotoButton       =   _takingPhotoButton;
@synthesize choosingPhotoButton     =   _choosingPhotoButton;
@synthesize postingImageLinkButton  =   _postingImageLinkButton;

//--------------------------------------------------------------------------------------------------------------------------------
- (id) init
//--------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        [Utilities addBorderAndShadow:self.view];
        [Utilities setTopRoundedCorner:self.titleView];
        [Utilities setBottomRoundedCorner:self.postingImageLinkButton];
    }
    
    return self;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    CGFloat width = WINSIZE.width * 0.875;
    self.view.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    [self.view layoutSubviews];
    
    [self customizeUI];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//--------------------------------------------------------------------------------------------------------------------------------
{
    [self.titleView setBackgroundColor:MAIN_BLUE_COLOR];
    [self.firstTitleLabel setText:NSLocalizedString(@"Tell people what you want to buy", nil)];
    [self.firstTitleLabel setTextColor:[UIColor whiteColor]];
    [self.secondTitleLabel setText:NSLocalizedString(@"Choose a way to upload your photo", nil)];
    [self.secondTitleLabel setTextColor:[UIColor whiteColor]];
    
    [_takingPhotoButton createTitle:NSLocalizedString(@"Take a photo", nil) withIcon:[UIImage imageNamed:@"camera_upload_icon.png"] font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:-8];
    _takingPhotoButton.cornerRadius = 0;
    _takingPhotoButton.bgColor = LIGHTEST_GRAY_COLOR;
    _takingPhotoButton.borderColor = LIGHTEST_GRAY_COLOR;
    _takingPhotoButton.titleColor = MAIN_BLUE_COLOR;
    
    [_choosingPhotoButton createTitle:NSLocalizedString(@"Choose from gallery", nil) withIcon:[UIImage imageNamed:@"gallery_upload_icon.png"] font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:-8];
    _choosingPhotoButton.cornerRadius = 0;
    _choosingPhotoButton.bgColor = BACKGROUND_GRAY_COLOR;
    _choosingPhotoButton.borderColor = BACKGROUND_GRAY_COLOR;
    _choosingPhotoButton.titleColor = MAIN_BLUE_COLOR;
    
    [_postingImageLinkButton createTitle:NSLocalizedString(@"Paste image URL", nil) withIcon:[UIImage imageNamed:@"image_link_upload_icon.png"] font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:-8];
    _postingImageLinkButton.cornerRadius = 0;
    _postingImageLinkButton.bgColor = LIGHTEST_GRAY_COLOR;
    _postingImageLinkButton.borderColor = LIGHTEST_GRAY_COLOR;
    _postingImageLinkButton.titleColor = MAIN_BLUE_COLOR;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (IBAction)selectPhoto:(UIButton *)sender
//--------------------------------------------------------------------------------------------------------------------------------
{
    [self.delegate imageGetterViewController:self didChooseAMethod:PhotoLibrary];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (IBAction)takePhoto:(UIButton *)sender
//--------------------------------------------------------------------------------------------------------------------------------s
{
    [self.delegate imageGetterViewController:self didChooseAMethod:Camera];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (IBAction)imageLinkOptionChosen:(UIButton *)sender
//--------------------------------------------------------------------------------------------------------------------------------
{
    [self.delegate imageGetterViewController:self didChooseAMethod:ImageURL];
}

@end
