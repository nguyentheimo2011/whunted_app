//
//  LoginSignupViewController.m
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LoginSignupViewController.h"
#import "MainViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>

@interface LoginSignupViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityLogin;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackgroundImage];
    [self addFacebookLoginButton];
    [self addActivityIndicatorView];
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
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setBackgroundImage: loginImage forState:UIControlStateNormal];
    self.loginButton.frame = CGRectMake(winSize.width/2 - loginImage.size.width/2, winSize.height/2 - loginImage.size.height/2, loginImage.size.width, loginImage.size.height);
    [self.loginButton addTarget:self action:@selector(loginButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}

- (void) addActivityIndicatorView
{
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    self.activityLogin = [[UIActivityIndicatorView alloc] init];
    self.activityLogin.frame = CGRectMake(windowSize.width/2 - 25, windowSize.height/2 - 25, 50, 50);
    [self.view addSubview:self.activityLogin];
}

#pragma mark - Event Handling

- (void) loginButtonTouchHandler
{
    [self.loginButton setEnabled:YES];
    [self.activityLogin startAnimating];
    [self loginOrSignUpWithFacebook];
}

- (void) loginOrSignUpWithFacebook
{
    NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email", @"user_about_me", @"user_birthday", @"user_location"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }
            
            [self userDidTryToLogin];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Login error"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
            
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            }
            else {
                NSLog(@"User logged in through Facebook!");
            }
            
            [self userDidTryToLogin];
            [self presentMainViewController];
        }
        
        
    }];
}

- (void) userDidTryToLogin
{
    [self.loginButton setEnabled:YES];
    [self.activityLogin stopAnimating];
}

- (void) presentMainViewController
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self presentViewController:mainVC animated:YES completion:^{
        
    }];
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
