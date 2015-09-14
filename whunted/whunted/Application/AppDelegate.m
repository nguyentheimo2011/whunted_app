//
//  AppDelegate.m
//  whunted
//
//  Created by thomas nguyen on 5/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginSignupViewController.h"
#import "Utilities.h"
#import "AppConstant.h"

@interface AppDelegate ()

- (void) setViewController;

@end

@implementation AppDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//------------------------------------------------------------------------------------------------------------------------------
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"QfLWfiKXjtNWiXuy6AmuvYmXwUvXhlZoWcoqtJJA" clientKey:@"OZJAI2MX0K2HGtBL7r6FM3FMqTRsOYnjYv99TXVD"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [self customizeUI];
    [self setViewController];
    
    // register push notification
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
//------------------------------------------------------------------------------------------------------------------------------
{
    [FBSDKAppEvents activateApp];
}


//------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
//------------------------------------------------------------------------------------------------------------------------------
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//------------------------------------------------------------------------------------------------------------------------------
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//------------------------------------------------------------------------------------------------------------------------------
{
    [PFPush handlePush:userInfo];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    if (![PFUser currentUser] || // Check if user is cached
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        
        LoginSignupViewController *loginVC = [[LoginSignupViewController alloc] init];
        [self.window setRootViewController:loginVC];
    }
    else
    {
        MainViewController *mainVC = [[MainViewController alloc] init];
        [self.window setRootViewController:mainVC];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE]
       }
     forState:UIControlStateNormal];
    
    [Utilities customizeHeaderFooterLabels];
    [Utilities customizeTabBar];
    [Utilities customizeNavigationBar];
}

@end
