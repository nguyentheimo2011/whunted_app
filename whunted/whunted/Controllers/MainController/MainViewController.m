//
//  MainViewController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MainViewController.h"
#import "NewsFeedViewController.h"
#import "BrowseViewController.h"
#import "BuySellViewController.h"

@interface MainViewController ()

- (void) customizeNavigationBar;

@end

@implementation MainViewController

- (id) init
{
    self = [super init];
    if (self != nil) {
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
        
        NSArray *controllers = [NSArray arrayWithObjects:navController, bsController, browseController, nil];
        [self setViewControllers:controllers];
        
        [self customizeNavigationBar];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) customizeNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:6.0/255 green:122.0/255 blue:181.0/255 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}


@end
