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
#import "GenericController.h"

@interface MainViewController ()

- (void) customizeNavigationBar;

@end

@implementation MainViewController

- (id) init
{
    self = [super init];
    if (self != nil) {
        UINavigationController *nfNavController = [[UINavigationController alloc] init];
        NewsFeedViewController *newsFeedVC = [[NewsFeedViewController alloc] init];
        [nfNavController setViewControllers:[NSArray arrayWithObject:newsFeedVC]];
        [nfNavController setTitle:@"News Feed"];
        [nfNavController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
        
        UINavigationController *bsNavController = [[UINavigationController alloc] init];
        BuySellViewController *bsController = [[BuySellViewController alloc] init];
        [bsNavController setViewControllers:[NSArray arrayWithObject:bsController]];
        [bsNavController setTitle:@"Buy&Sell"];
        [bsNavController.tabBarItem setImage:[UIImage imageNamed:@"gun_target.png"]];
        
        UINavigationController *brNavController = [[UINavigationController alloc] init];
        BrowseViewController *brController = [[BrowseViewController alloc] init];
        [brNavController setViewControllers:[NSArray arrayWithObject:brController]];
        [brNavController setTitle:@"Browse"];
        [brNavController.tabBarItem setImage:[UIImage imageNamed:@"shopping_cart.png"]];
        
        NSArray *controllers = [NSArray arrayWithObjects:nfNavController, bsNavController, brNavController, nil];
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
