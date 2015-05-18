//
//  UploadMethodViewController.m
//  whunted
//
//  Created by thomas nguyen on 12/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ImageGetterViewController.h"
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
    }
    return self;
}

- (void) viewDidLoad {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width * 0.875;
    self.view.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    [self.view layoutSubviews];
    [super viewDidLoad];
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
    
}

@end
