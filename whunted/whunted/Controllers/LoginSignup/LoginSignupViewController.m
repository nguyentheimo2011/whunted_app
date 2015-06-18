//
//  LoginSignupViewController.m
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LoginSignupViewController.h"
#import "MainViewController.h"
#import "AppConstant.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>
#import <MBProgressHUD.h>

@interface LoginSignupViewController ()

@property (nonatomic, strong) UIButton *_FBLoginButton;
@property (nonatomic, strong) UIButton *_emailLoginButton;

@end

@implementation LoginSignupViewController

@synthesize _FBLoginButton;
@synthesize _emailLoginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackgroundImage];
    [self addFacebookLoginOrSignupButton];
    [self addEmailLoginOrSignupButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addBackgroundImage
{
    UIImage *originalBackground = [UIImage imageNamed:@"background_image.jpg"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:originalBackground];
    [self.view addSubview:backgroundImageView];
}

- (void) addFacebookLoginOrSignupButton
{
    _FBLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.05, WINSIZE.height * 0.75, WINSIZE.width * 0.9, WINSIZE.height * 0.1)];
    [_FBLoginButton setBackgroundColor:[UIColor colorWithRed:45.0/255 green:68.0/255 blue:134.0/255 alpha:1.0]];
    [_FBLoginButton setTitle:@"Sign up or Log in with Facebook" forState:UIControlStateNormal];
    [_FBLoginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_FBLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_FBLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _FBLoginButton.layer.cornerRadius = 5;
    [_FBLoginButton addTarget:self action:@selector(loginButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_FBLoginButton];
}

- (void) addEmailLoginOrSignupButton
{
    _emailLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.05, WINSIZE.height * 0.87, WINSIZE.width * 0.9, WINSIZE.height * 0.1)];
    [_emailLoginButton setBackgroundColor:[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0]];
    [_emailLoginButton setTitle:@"Sign up or Log in with Email" forState:UIControlStateNormal];
    [_emailLoginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_emailLoginButton setTitleColor:[UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0] forState:UIControlStateNormal];
    [_emailLoginButton setTitleColor:[UIColor colorWithRed:1.0 green:100.0/255 blue:100.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    _emailLoginButton.layer.cornerRadius = 5;
//    [_emailLoginButton addTarget:self action:@selector(loginButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_emailLoginButton];
}

#pragma mark - Event Handling

- (void) loginButtonTouchHandler
{
    [_FBLoginButton setEnabled:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            [self addDataToUser];
            [self presentMainViewController];
        }
    }];
}

- (void) userDidTryToLogin
{
    [_FBLoginButton setEnabled:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) presentMainViewController
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:mainVC animated:NO completion:^{
    }];
}

- (void) addDataToUser
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            PFUser *user = [PFUser currentUser];
            
            NSString *facebookID = userData[@"id"];
            
            NSString *email = userData[@"email"];
            if (email) {
                user[@"email"] =email ;
                user[@"username"] = [self extractUsernameFromEmail:user[@"email"]];
            }
            
            NSString *firstName = userData[@"first_name"];
            if (firstName) {
                user[@"firstName"] = firstName;
            }
            
            NSString *lastName = userData[@"last_name"];
            if (lastName) {
                user[@"lastName"] = lastName;
            }
            
            NSString *gender = userData[@"gender"];
            if (gender) {
                user[@"gender"] = gender;
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location) {
                NSArray *addresses = [self extractCountry:location];
                if (addresses[0]) {
                    user[@"areaAddress"] = addresses[0];
                }
                if (addresses[1]) {
                    user[@"country"] = addresses[1];
                }
            }
            
            NSString *dob = userData[@"birthday"];
            if (dob) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                user[@"dob"] = [dateFormatter dateFromString:dob];
            }
            
            [user saveInBackground];
            
            // retrieve and save profile picture
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            //Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (connectionError == nil && data != nil) {
                     PFFile *profilePictureFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", facebookID] data:data];
                     if (profilePictureFile) {
                         user[@"profilePicture"] = profilePictureFile;
                         [user saveInBackground];
                         [user pinInBackground];
                     }
                 }
             }];
        }  else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

#pragma mark - Supporting functions

- (NSString *) extractUsernameFromEmail: (NSString *) email
{
    NSRange atCharRange = [email rangeOfString:@"@"];
    NSString *username = [email substringToIndex:atCharRange.location];
    return username;
}

- (NSArray *) extractCountry: (NSString *) location
{
    NSRange commaSignRange = [location rangeOfString:@"," options:NSBackwardsSearch];
    NSString *specificAddress;
    NSString *country;
    
    if (commaSignRange.location >= location.length)
    {
        specificAddress = @"";
        country = location;
    } else {
        specificAddress = [location substringToIndex:commaSignRange.location];
        country = [location substringFromIndex:commaSignRange.location + 1];
    }
    
    return [NSArray arrayWithObjects:specificAddress, country, nil];
}

@end
