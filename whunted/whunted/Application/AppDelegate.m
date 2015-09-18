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
#import <Google/Analytics.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginSignupViewController.h"
#import "Utilities.h"
#import "AppConstant.h"


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
    
    [self addNotificationListeners];
    
    [self addGoogleAnalyticsTracker];
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
//------------------------------------------------------------------------------------------------------------------------------
{
    [FBSDKAppEvents activateApp];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                NSLog(@"%@ %@", error, error.userInfo);
            }
        }];
    }
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
    currentInstallation[PF_INSTALLATION_USER] = [PFUser currentUser].objectId;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            
        }
        else
        {
            NSLog(@"Error in didRegisterForRemoteNotificationsWithDeviceToken %@ %@", error, error.userInfo);
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) application:(UIApplication *) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@ %@", error, error.userInfo);
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
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationListeners
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerPushNotifications) name:NOTIFICATION_USER_SIGNED_UP object:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addGoogleAnalyticsTracker
//------------------------------------------------------------------------------------------------------------------------------
{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelNone;  // remove before app release
    gai.dispatchInterval = 20;
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) registerPushNotifications
//------------------------------------------------------------------------------------------------------------------------------
{
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    UIApplication *application = [UIApplication sharedApplication];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

@end
