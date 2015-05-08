//
//  AppDelegate.m
//  whunted
//
//  Created by thomas nguyen on 5/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsFeedViewController.h"
#import "BrowseViewController.h"
#import "BuySellViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface AppDelegate ()

- (void) setViewController;
- (void) customizeNavigationBar;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [self setViewController];
    [self customizeNavigationBar];
    
    return YES;
}

- (void) setViewController {
    UINavigationController *navController = [[UINavigationController alloc] init];
    NewsFeedViewController *newsFeedVC = [[NewsFeedViewController alloc] init];
    [navController setViewControllers:[NSArray arrayWithObject:newsFeedVC]];
    [navController setTitle:@"News Feed"];
    [navController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
    
    BrowseViewController *browseController = [[BrowseViewController alloc] init];
    [browseController setTitle:@"Browse"];
    [browseController.tabBarItem setImage:[UIImage imageNamed:@"shopping_cart.png"]];
    
    BuySellViewController *bsController = [[BuySellViewController alloc] init];
    [bsController setTitle:@"Buy&Sell"];
    [bsController.tabBarItem setImage:[UIImage imageNamed:@"gun_target.png"]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *controllers = [NSArray arrayWithObjects:navController, browseController, bsController, nil];
    [tabBarController setViewControllers:controllers];
    
    [self.window setRootViewController:tabBarController];
}

- (void) customizeNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

@end
