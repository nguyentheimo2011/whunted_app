//
//  LoginSignupViewController.m
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LoginSignupViewController.h"
#import "MainViewController.h"
#import "EmailSignupLoginVC.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>
#import <MRProgress.h>
#import <JTImageButton.h>


@implementation LoginSignupViewController
{
    UIButton                *_FBLoginButton;
    UIButton                *_emailLoginButton;
    
    UINavigationController  *_termOfServiceNavController;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self addBackgroundImage];
    [self addFacebookLoginOrSignupButton];
    [self addEmailLoginOrSignupButton];
    [self addDisclaimerLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"LoginScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBackgroundImage
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *originalBackground = [UIImage imageNamed:@"background_image.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    backgroundImageView.image = originalBackground;
    [self.view addSubview:backgroundImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addFacebookLoginOrSignupButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonOriginY    =   WINSIZE.height - 140.0f;
    
    _FBLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, kButtonOriginY, WINSIZE.width * 0.8, 50.0f)];
    [_FBLoginButton setBackgroundColor:[UIColor colorWithRed:45.0/255 green:68.0/255 blue:134.0/255 alpha:1.0]];
    [_FBLoginButton setTitle:NSLocalizedString(@"Sign up or Log in with Facebook", nil) forState:UIControlStateNormal];
    [_FBLoginButton.titleLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_FBLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_FBLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _FBLoginButton.layer.cornerRadius = 5;
    [_FBLoginButton addTarget:self action:@selector(facebookLoginButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_FBLoginButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addEmailLoginOrSignupButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _emailLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, _FBLoginButton.frame.origin.y + 58.0f, WINSIZE.width * 0.8, 50.0f)];
    [_emailLoginButton setBackgroundColor:[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]];
    [_emailLoginButton setTitle:NSLocalizedString(@"Sign up or Log in with Email", nil) forState:UIControlStateNormal];
    [_emailLoginButton.titleLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_emailLoginButton setTitleColor:[UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0] forState:UIControlStateNormal];
    [_emailLoginButton setTitleColor:[UIColor colorWithRed:1.0 green:100.0/255 blue:100.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    _emailLoginButton.layer.cornerRadius = 5;
    [_emailLoginButton addTarget:self action:@selector(emailLoginButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_emailLoginButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDisclaimerLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *disclaimerLabel = [[UILabel alloc] init];
    disclaimerLabel.text = NSLocalizedString(@"By signing up, you agree to our ", nil);
    disclaimerLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
    disclaimerLabel.textColor = [UIColor whiteColor];
    [disclaimerLabel sizeToFit];
    
    JTImageButton *termOfServiceButton = [[JTImageButton alloc] init];
    [termOfServiceButton createTitle:NSLocalizedString(@"Terms of Service", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:13] iconOffsetY:0];
    termOfServiceButton.titleColor = LIGHTER_GRAY_COLOR;
    termOfServiceButton.borderWidth = 0;
    [termOfServiceButton addTarget:self action:@selector(disclaimerButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [termOfServiceButton sizeToFit];
    
    CGFloat totalWidth = disclaimerLabel.frame.size.width + termOfServiceButton.frame.size.width;
    CGFloat kLabelOriginX   =   (WINSIZE.width - totalWidth) / 2;
    CGFloat kLabelOriginY   =   _emailLoginButton.frame.origin.y + _emailLoginButton.frame.size.height + 5.0f;
    
    disclaimerLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, disclaimerLabel.frame.size.width, disclaimerLabel.frame.size.height);
    [self.view addSubview:disclaimerLabel];
    
    CGFloat kButtonOriginX  =   kLabelOriginX + disclaimerLabel.frame.size.width;
    CGFloat kButtonOriginY  =   kLabelOriginY - 5.0f;
    
    termOfServiceButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, termOfServiceButton.frame.size.width, termOfServiceButton.frame.size.height);
    [self.view addSubview:termOfServiceButton];
}



#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) facebookLoginButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    [self loginOrSignUpWithFacebook];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) emailLoginButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    EmailSignupLoginVC *emailVC = [[EmailSignupLoginVC alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:emailVC];
    [self presentViewController:navController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) loginOrSignUpWithFacebook
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email", @"user_about_me", @"user_birthday", @"user_location"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error)
    {
        if (!user)
        {
            if (!error)
            {
                [Utilities logOutMessage:@"The user cancelled the Facebook login."];
            }
            else
            {
                [Utilities handleError:error];
            }
            
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            [Utilities displayErrorAlertView];
        }
        else
        {
            if (user.isNew)
            {
                [self addDataToUser];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_SIGNED_UP object:nil];
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            [self presentMainViewController];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) presentMainViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:mainVC animated:NO completion:^{}];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDataToUser
//------------------------------------------------------------------------------------------------------------------------------
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            PFUser *user = [PFUser currentUser];
            
            NSString *facebookID = userData[@"id"];
            
            NSString *email = userData[@"email"];
            if (email)
            {
                user[@"email"] =email ;
                user[@"username"] = [self extractUsernameFromEmail:user[@"email"]];
            }
            
            NSString *firstName = userData[@"first_name"];
            if (firstName)
            {
                user[@"firstName"] = firstName;
                
                if (!email)
                {
                    user[@"username"] = [firstName stringByAppendingString:userData[@"last_name"]];
                }
            }
            
            NSString *lastName = userData[@"last_name"];
            if (lastName)
            {
                user[@"lastName"] = lastName;
            }
            
            NSString *gender = userData[@"gender"];
            if (gender)
            {
                user[@"gender"] = gender;
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location)
            {
                NSArray *addresses = [Utilities extractCountry:location];
                if (addresses[0])
                {
                    user[@"city"] = addresses[0];
                }
                
                if (addresses[1])
                {
                    user[@"country"] = addresses[1];
                    
                    if (!addresses[0] || ((NSString *)addresses[0]).length == 0)
                    {
                        user[@"city"] = addresses[1];
                    }
                }
            }
            
            NSString *dob = userData[@"birthday"];
            if (dob)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                user[@"dob"] = [dateFormatter dateFromString:dob];
            }
            
            user[PF_USER_FACEBOOK_VERIFIED] = @YES;
            
            [user saveInBackground];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_PROFILE_UPDATED_EVENT object:nil];
            
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
                     if (profilePictureFile)
                     {
                         user[PF_USER_PICTURE] = profilePictureFile;
                         [user saveInBackground];
                         [user pinInBackground];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_PROFILE_UPDATED_EVENT object:nil];
                     }
                }
             }];
        }
        else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"])
        {
            // Since the request failed, we can check if it was due to an invalid session
            [Utilities logOutMessage:@"The facebook session was invalidated"];
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) disclaimerButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://whunted.com/Termsofservice.html"]];
    [webView loadRequest:request];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [Utilities customizeTitleLabel:NSLocalizedString(@"Terms of Service", nil) forViewController:viewController];
    viewController.view = webView;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -11.0f;
    
    viewController.navigationItem.leftBarButtonItems = @[spacer, [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissTermOfServiceView)]];
    
    _termOfServiceNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:_termOfServiceNavController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) dismissTermOfServiceView
//------------------------------------------------------------------------------------------------------------------------------
{
    [_termOfServiceNavController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Supporting functions

//------------------------------------------------------------------------------------------------------------------------------
- (NSString *) extractUsernameFromEmail: (NSString *) email
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange atCharRange = [email rangeOfString:@"@"];
    NSString *username = [email substringToIndex:atCharRange.location];
    return username;
}


#pragma mark - Next version




@end
