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
    
    [self setUpParseAsBackend:launchOptions];
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
    
    [self clearBadgeOfPushNotification];
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
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        {
            [Utilities handleError:error];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) application:(UIApplication *) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities handleError:error];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//------------------------------------------------------------------------------------------------------------------------------
{
    if (application.applicationState == UIApplicationStateActive)
    {
        [self clearBadgeOfPushNotification];
    }
    else
    {
        [PFPush handlePush:userInfo];
        
        if ([[userInfo allKeys] containsObject:FB_GROUP_ID])
        {
            NSString *groupID = [userInfo objectForKey:FB_GROUP_ID];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTER_APP_THROUGH_PUSH_NOTIFICATION_EVENT object:groupID];
        }
    }
}
 

//------------------------------------------------------------------------------------------------------------------------------
- (void) setViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    if (![PFUser currentUser]) // Check if user is cached
//        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
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
- (void) setUpParseAsBackend:(NSDictionary *)launchOptions
//------------------------------------------------------------------------------------------------------------------------------
{
//    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"QfLWfiKXjtNWiXuy6AmuvYmXwUvXhlZoWcoqtJJA" clientKey:@"OZJAI2MX0K2HGtBL7r6FM3FMqTRsOYnjYv99TXVD"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationListeners
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerPushNotifications) name:NOTIFICATION_USER_SIGNED_UP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOfApp) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) logoutOfApp
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.window.rootViewController.view];
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)
    {
        LoginSignupViewController *loginVC = [[LoginSignupViewController alloc] init];
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        [self.window setRootViewController:loginVC];
        
        [Utilities hideIndeterminateProgressIndicatorInView:self.window.rootViewController.view];
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) clearBadgeOfPushNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];

    currentInstallation.badge = 0;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [Utilities handleError:error];
             [currentInstallation saveEventually];
         }
     }];
}

@end
