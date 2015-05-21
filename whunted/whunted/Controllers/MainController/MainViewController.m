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
#import "GenericController.h"
#import "MySellViewController.h"
#import "MyWantViewController.h"

@interface MainViewController ()

- (void) customizeNavigationBar;

@end

@implementation MainViewController

- (id) init
{
    self = [super init];
    if (self != nil) {
        UINavigationController *browserNavController = [[UINavigationController alloc] init];
        BrowseViewController *brController = [[BrowseViewController alloc] init];
        [browserNavController setViewControllers:[NSArray arrayWithObject:brController]];
        [browserNavController setTitle:@"Browse"];
        [browserNavController.tabBarItem setImage:[UIImage imageNamed:@"shopping_cart.png"]];
        
        UINavigationController *newsFeedfNavController = [[UINavigationController alloc] init];
        NewsFeedViewController *newsFeedVC = [[NewsFeedViewController alloc] init];
        [newsFeedfNavController setViewControllers:[NSArray arrayWithObject:newsFeedVC]];
        [newsFeedfNavController setTitle:@"News Feed"];
        [newsFeedfNavController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
        
        UINavigationController *myWantNavController = [[UINavigationController alloc] init];
        MyWantViewController *myWantVC = [[MyWantViewController alloc] init];
        [myWantNavController setViewControllers: [NSArray arrayWithObject:myWantVC]];
        [myWantNavController setTitle:@"Want"];
        [myWantNavController.tabBarItem setImage:[UIImage imageNamed:@"want_icon.png"]];
        
        UINavigationController *mySellNavController = [[UINavigationController alloc] init];
        MySellViewController *mySellVC = [[MySellViewController alloc] init];
        [mySellNavController setViewControllers: [NSArray arrayWithObject:mySellVC]];
        [mySellNavController setTitle:@"Sell"];
        [mySellNavController.tabBarItem setImage:[UIImage imageNamed:@"sell_icon.png"]];
        
        NSArray *controllers = [NSArray arrayWithObjects:browserNavController, newsFeedfNavController, myWantNavController, mySellNavController, nil];
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
