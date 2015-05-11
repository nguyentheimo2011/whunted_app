//
//  AppDelegate.m
//  whunted
//
//  Created by thomas nguyen on 5/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

- (void) setViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [self setViewController];
    
    return YES;
}

- (void) setViewController {
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self.window setRootViewController:mainVC];
}

@end
