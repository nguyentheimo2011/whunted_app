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
    [loginButton addTarget:self action:@selector(loginOrSignUpWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

#pragma mark - Event Handling

- (void) loginOrSignUpWithFacebook
{
    NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email", @"user_about_me", @"user_birthday", @"user_location"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self presentViewController:mainVC animated:YES completion:^{
                [self addDataToUser:user];
            }];
        } else {
            NSLog(@"User logged in through Facebook!");
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self presentViewController:mainVC animated:YES completion:^{
            }];
        }
    }];
}

- (void) addDataToUser: (PFUser*) user
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // result is a dictionary with the user's Facebook data
        NSDictionary *userData = (NSDictionary *)result;
        
        NSString *facebookID = userData[@"id"];
        user[@"email"] = userData[@"email"];
        user[@"username"] = [self extractUsernameFromEmail:user[@"email"]];
        user[@"firstName"] = userData[@"first_name"];
        user[@"lastName"] = userData[@"last_name"];
        user[@"gender"] = userData[@"gender"];
        
        NSArray *addresses = [self extractCountry:userData[@"location"][@"name"]];
        user[@"areaAddress"] = addresses[0];
        user[@"country"] = addresses[1];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        user[@"dob"] = [dateFormatter dateFromString:userData[@"birthday"]];

        [user saveEventually];

        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

         //Run network request asynchronously
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:
         ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
             if (connectionError == nil && data != nil) {
                 PFFile *profilePictureFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", facebookID] data:data];
                 user[@"profilePicture"] = profilePictureFile;
                 [user saveEventually];
             }
         }];
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

- (NSString *) extractUsernameFromEmail: (NSString *) email
{
    NSRange atCharRange = [email rangeOfString:@"@"];
    NSString *username = [email substringToIndex:atCharRange.location];
    return username;
}

- (NSArray *) extractCountry: (NSString *) location
{
    NSRange commaSignRange = [location rangeOfString:@"," options:NSBackwardsSearch];
    NSString *specificAddress = [location substringToIndex:commaSignRange.location];
    NSString *country = [location substringFromIndex:commaSignRange.location + 1];
    
    return [NSArray arrayWithObjects:specificAddress, country, nil];
}

@end
