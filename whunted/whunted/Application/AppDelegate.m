//
//  AppDelegate.m
//  whunted
//
//  Created by thomas nguyen on 5/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "WantDetailsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>

@interface AppDelegate ()

- (void) setViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [self setViewController];
    
    [Parse setApplicationId:@"QfLWfiKXjtNWiXuy6AmuvYmXwUvXhlZoWcoqtJJA" clientKey:@"OZJAI2MX0K2HGtBL7r6FM3FMqTRsOYnjYv99TXVD"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void) setViewController {
    MainViewController *mainVC = [[MainViewController alloc] init];
//    WantDetailsViewController *vc = [[WantDetailsViewController alloc] init];
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window setRootViewController:mainVC];
}

@end
