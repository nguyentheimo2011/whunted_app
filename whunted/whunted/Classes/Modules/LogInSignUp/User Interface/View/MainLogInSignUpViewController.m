//
//  LoginSignupViewController.m
//  whunted
//
//  Created by thomas nguyen on 26/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>
#import <MRProgress.h>
#import <JTImageButton.h>

#import "MainLogInSignUpViewController.h"
#import "MainViewController.h"
#import "EmailSignupLoginVC.h"
#import "AppConstant.h"
#import "Utilities.h"


@implementation MainLogInSignUpViewController
{
    JTImageButton                   *_FBLoginButton;
    JTImageButton                   *_emailLoginButton;
    
    UINavigationController          *_termOfServiceNavController;
}

@synthesize eventHandler    =   _eventHandler;


//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self setUpUIForView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setUpUIForView
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addBackgroundForView];
    [self addFacebookLoginButton];
    [self addEmailLoginOrSignupButton];
    [self addUserAgreementLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBackgroundForView
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *originalBackground = [UIImage imageNamed:@"background_image.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    backgroundImageView.image = originalBackground;
    [self.view addSubview:backgroundImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addFacebookLoginButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonOriginX    =   WINSIZE.width * 0.1 - 10.0f;
    CGFloat const kButtonOriginY    =   WINSIZE.height - 160.0f;
    CGFloat const kButtonHeight     =   50.0f;
    CGFloat const kButtonWidth      =   WINSIZE.width * 0.8 + 20.0f;
    
    _FBLoginButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_FBLoginButton createTitle:NSLocalizedString(@"Sign up or Log in with Facebook", nil) withIcon:[UIImage imageNamed:@"facebook_icon.png"] font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:-15.0f];
    _FBLoginButton.titleColor = [UIColor whiteColor];
    _FBLoginButton.bgColor = [UIColor colorWithRed:45.0/255 green:68.0/255 blue:134.0/255 alpha:1.0];
    _FBLoginButton.borderWidth = 0;
    _FBLoginButton.cornerRadius = 5;
    [_FBLoginButton addTarget:self action:@selector(logInOrSignUpWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_FBLoginButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addEmailLoginOrSignupButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonOriginX    =   WINSIZE.width * 0.1 - 10.0f;
    CGFloat const kButtonOriginY    =   _FBLoginButton.frame.origin.y + 60.0f;
    CGFloat const kButtonHeight     =   50.0f;
    CGFloat const kButtonWidth      =   WINSIZE.width * 0.8 + 20.0f;
    
    _emailLoginButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_emailLoginButton createTitle:NSLocalizedString(@"Sign up or Log in with Email", nil) withIcon:[UIImage imageNamed:@"mail_icon.png"] font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:-15.0f];
    _emailLoginButton.titleColor = TEXT_COLOR_DARK_GRAY;
    _emailLoginButton.bgColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    _emailLoginButton.borderWidth = 0;
    _emailLoginButton.cornerRadius = 5;
    [_emailLoginButton addTarget:self action:@selector(emailLoginButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_emailLoginButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addUserAgreementLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *userAgreementLabel = [[UILabel alloc] init];
    userAgreementLabel.text = NSLocalizedString(@"By signing up, you agree to our ", nil);
    userAgreementLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:13];
    userAgreementLabel.textColor = [UIColor whiteColor];
    [userAgreementLabel sizeToFit];
    
    JTImageButton *termOfServiceButton = [[JTImageButton alloc] init];
    [termOfServiceButton createTitle:NSLocalizedString(@"Terms of Service", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:13] iconOffsetY:0];
    termOfServiceButton.titleColor = RED_COLOR_WITH_DARK_2;
    termOfServiceButton.borderWidth = 0;
    [termOfServiceButton addTarget:self action:@selector(disclaimerButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [termOfServiceButton sizeToFit];
    
    CGFloat totalWidth = userAgreementLabel.frame.size.width + termOfServiceButton.frame.size.width;
    CGFloat kLabelOriginX   =   (WINSIZE.width - totalWidth) / 2;
    CGFloat kLabelOriginY   =   _emailLoginButton.frame.origin.y + _emailLoginButton.frame.size.height + 10.0f;
    
    userAgreementLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, userAgreementLabel.frame.size.width, userAgreementLabel.frame.size.height);
    [self.view addSubview:userAgreementLabel];
    
    CGFloat kButtonOriginX  =   kLabelOriginX + userAgreementLabel.frame.size.width;
    CGFloat kButtonOriginY  =   kLabelOriginY - 5.5f;
    
    termOfServiceButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, termOfServiceButton.frame.size.width, termOfServiceButton.frame.size.height);
    [self.view addSubview:termOfServiceButton];
}


#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) emailLoginButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    EmailSignupLoginVC *emailVC = [[EmailSignupLoginVC alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:emailVC];
    [self presentViewController:navController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) logInOrSignUpWithFacebook
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
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
                [self retrieveUserInfoAndSaveToParse];
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


#pragma mark - Backend functions

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveUserInfoAndSaveToParse
//------------------------------------------------------------------------------------------------------------------------------
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             // result is a dictionary with the user's Facebook data
             NSDictionary *userData = (NSDictionary *)result;
             [self retrieveGeneralUserInfoFromFacebook:userData];
             [self retrieveUserProfileImageFromFacebook:userData];
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
- (void) retrieveGeneralUserInfoFromFacebook: (NSDictionary *) userData
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user = [PFUser currentUser];
    
    NSString *email = userData[@"email"];
    if (email)
    {
        user[@"email"] = email ;
        user[@"username"] = [Utilities getUsernameFromEmail:user[@"email"]];
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
        user[@"city"] = [Utilities getCityFromAddress:location];
        user[@"country"] = [Utilities getCountryFromAddress:location];
    }
    
    NSString *dob = userData[@"birthday"];
    if (dob)
    {
        user[@"dob"] = [Utilities dateFromUSStyledString:dob];
    }
    
    user[PF_USER_FACEBOOK_VERIFIED] = @YES;
    
    [user saveInBackground];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_PROFILE_UPDATED_EVENT object:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveUserProfileImageFromFacebook: (NSDictionary *) userData
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user = [PFUser currentUser];
    NSString *facebookID = userData[@"id"];
    
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


@end
