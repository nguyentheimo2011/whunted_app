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
#import "AppConstant.h"
#import "Utilities.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>

@interface MainViewController ()
{
    MarketplaceViewController   *_brController;
    MyWantViewController        *_myWantVC;
    MySellViewController        *_mySellVC;
    NewsFeedViewController      *_newsFeedVC;
}

@end

@implementation MainViewController

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        UINavigationController *browserNavController = [[UINavigationController alloc] init];
        _brController = [[MarketplaceViewController alloc] init];
        [browserNavController setViewControllers:[NSArray arrayWithObject:_brController]];
        [browserNavController setTitle:NSLocalizedString(@"Marketplace", nil)];
        [browserNavController.tabBarItem setImage:[[UIImage imageNamed:@"marketplace_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _brController.delegate = self;
        
        UINavigationController *newsFeedfNavController = [[UINavigationController alloc] init];
        _newsFeedVC = [[NewsFeedViewController alloc] init];
        [newsFeedfNavController setViewControllers:[NSArray arrayWithObject:_newsFeedVC]];
        [newsFeedfNavController setTitle:NSLocalizedString(@"Newsfeed", nil)];
        [newsFeedfNavController.tabBarItem setImage:[[UIImage imageNamed:@"newsfeed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _newsFeedVC.delegate = self;
        
        UINavigationController *myWantNavController = [[UINavigationController alloc] init];
        _myWantVC = [[MyWantViewController alloc] init];
        [myWantNavController setViewControllers: [NSArray arrayWithObject:_myWantVC]];
        [myWantNavController setTitle:NSLocalizedString(@"Want", nil)];
        [myWantNavController.tabBarItem setImage:[[UIImage imageNamed:@"want_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _myWantVC.delegate = self;
        
        UINavigationController *mySellNavController = [[UINavigationController alloc] init];
        _mySellVC = [[MySellViewController alloc] init];
        [mySellNavController setViewControllers: [NSArray arrayWithObject:_mySellVC]];
        [mySellNavController setTitle:NSLocalizedString(@"Sell", nil)];
        [mySellNavController.tabBarItem setImage:[[UIImage imageNamed:@"sell_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _mySellVC.delegate = self;
        
        NSArray *controllers = [NSArray arrayWithObjects:browserNavController, newsFeedfNavController, myWantNavController, mySellNavController, nil];
        [self setViewControllers:controllers];
        [self setSelectedIndex:0];
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - GenericController Delegate methods
//-------------------------------------------------------------------------------------------------------------------------------
- (void) genericController:(GenericController *)controller shouldUpdateDataAt:(NSInteger)controllerIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (controllerIndex == 0) {
        [_brController retrieveLatestWantData];
    } else if (controllerIndex == 2) {
        [_myWantVC retrieveLatestWantData];
        [self setSelectedIndex:2];
    } else if (controllerIndex == 3) {
        [_mySellVC retrieveLatestWantData];
        [self setSelectedIndex:3];
    }
}


@end
