//
//  MainViewController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MainViewController.h"
#import "NewsFeedViewController.h"
#import "MarketplaceViewController.h"
#import "GenericController.h"
#import "MySellViewController.h"
#import "MyWantViewController.h"
#import "Utilities.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>

@interface MainViewController ()
{
    MarketplaceViewController *_brController;
    MyWantViewController *_myWantVC;
}

@end

@implementation MainViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        UINavigationController *browserNavController = [[UINavigationController alloc] init];
        _brController = [[MarketplaceViewController alloc] init];
        [browserNavController setViewControllers:[NSArray arrayWithObject:_brController]];
        [browserNavController setTitle:@"Marketplace"];
        [browserNavController.tabBarItem setImage:[UIImage imageNamed:@"marketplace.png"]];
        _brController.delegate = self;
        
        UINavigationController *newsFeedfNavController = [[UINavigationController alloc] init];
        NewsFeedViewController *newsFeedVC = [[NewsFeedViewController alloc] init];
        [newsFeedfNavController setViewControllers:[NSArray arrayWithObject:newsFeedVC]];
        [newsFeedfNavController setTitle:@"News Feed"];
        [newsFeedfNavController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
        
        UINavigationController *myWantNavController = [[UINavigationController alloc] init];
        _myWantVC = [[MyWantViewController alloc] init];
        [myWantNavController setViewControllers: [NSArray arrayWithObject:_myWantVC]];
        [myWantNavController setTitle:@"Want"];
        [myWantNavController.tabBarItem setImage:[UIImage imageNamed:@"want_icon.png"]];
        _myWantVC.delegate = self;
        
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
    [[UINavigationBar appearance] setBarTintColor:APP_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

#pragma mark - GenericController Delegate methods
- (void) genericController:(GenericController *)controller shouldUpdateData:(BOOL)updated
{
    if (updated) {
        [_brController retrieveLatestWantData];
        [_myWantVC retrieveLatestWantData];
    }
}

@end
