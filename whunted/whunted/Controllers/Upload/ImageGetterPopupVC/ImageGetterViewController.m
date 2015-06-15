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

@interface ImageGetterViewController ()

@end

@implementation ImageGetterViewController

- (id) init
{
    self = [super init];
    if (self != nil) {
        [Utilities addBorderAndShadow:self.view];
        [Utilities setTopRoundedCorner:self.titleView];
        [Utilities setBottomRoundedCorner:self.postingImageLinkButton];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = WINSIZE.width * 0.875;
    self.view.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    [self.view layoutSubviews];
    
    [self customizeUI];
}

- (void) customizeUI
{
    [self.titleView setBackgroundColor:APP_COLOR_5];
    [self.firstTitleLabel setTextColor:[UIColor whiteColor]];
    [self.secondTitleLabel setTextColor:[UIColor whiteColor]];
    
    [self.takingPhotoButton setBackgroundColor:APP_COLOR_2];
    [self.choosingPhotoButton setBackgroundColor:APP_COLOR_4];
    [self.postingImageLinkButton setBackgroundColor:APP_COLOR_2];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)selectPhoto:(UIButton *)sender;
{
    [self.delegate imageGetterViewController:self didChooseAMethod:PhotoLibrary];
}

- (IBAction)takePhoto:(UIButton *)sender
{
    [self.delegate imageGetterViewController:self didChooseAMethod:Camera];
}

- (IBAction)imageLinkOptionChosen:(UIButton *)sender
{
    [self.delegate imageGetterViewController:self didChooseAMethod:ImageURL];
}

@end
