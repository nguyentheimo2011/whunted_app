//
//  LoginSignupViewController.m
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LoginSignupViewController.h"

@interface LoginSignupViewController ()

@end

@implementation LoginSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackgroundImage];
    [self addFacebookLoginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addBackgroundImage
{
    UIImage *originalBackground = [UIImage imageNamed:@"background_image.jpg"];
    UIImage *blurredBackground = [self blur:originalBackground];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:blurredBackground];
    [self.view addSubview:backgroundImageView];
}

- (void) addFacebookLoginButton
{
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    UIImage *loginImage = [UIImage imageNamed:@"facebook_login_button.png"];
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setBackgroundImage: loginImage forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(winSize.width/2 - loginImage.size.width/2, winSize.height/2 - loginImage.size.height/2, loginImage.size.width, loginImage.size.height);
    [self.view addSubview:loginButton];
}

#pragma mark - Supporting function

- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

@end
