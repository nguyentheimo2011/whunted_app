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
#import "InboxAllViewController.h"
#import "ActivityViewController.h"
#import "UploadingViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>

@interface MainViewController ()
{
    MarketplaceViewController   *_brController;
    ActivityViewController      *_activityVC;
    InboxAllViewController      *_inboxVC;
    NewsFeedViewController      *_newsFeedVC;
    UploadingViewController     *_uploadingVC;
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
        [browserNavController.tabBarItem setImage:[UIImage imageNamed:@"marketplace_2.png"]];
        _brController.delegate = self;
        
        UINavigationController *newsFeedfNavController = [[UINavigationController alloc] init];
        _newsFeedVC = [[NewsFeedViewController alloc] init];
        [newsFeedfNavController setViewControllers:[NSArray arrayWithObject:_newsFeedVC]];
        [newsFeedfNavController setTitle:NSLocalizedString(@"Newsfeed", nil)];
        [newsFeedfNavController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
        _newsFeedVC.delegate = self;
        
        UINavigationController *uploadingNavController = [[UINavigationController alloc] init];
        _uploadingVC = [[UploadingViewController alloc] init];
        [uploadingNavController setViewControllers:@[_uploadingVC]];
        [uploadingNavController setTitle:NSLocalizedString(@"Upload", nil)];
        [uploadingNavController.tabBarItem setImage:[UIImage imageNamed:@"camera_tab_icon.png"]];
        
        UINavigationController *activityNavController = [[UINavigationController alloc] init];
        _activityVC = [[ActivityViewController alloc] init];
        [activityNavController setViewControllers: [NSArray arrayWithObject:_activityVC]];
        [activityNavController setTitle:NSLocalizedString(@"Activity", nil)];
        [activityNavController.tabBarItem setImage:[UIImage imageNamed:@"activity_tab_icon.png"]];
        
        UINavigationController *chattingNavController = [[UINavigationController alloc] init];
        _inboxVC = [[InboxAllViewController alloc] init];
        [chattingNavController setViewControllers: [NSArray arrayWithObject:_inboxVC]];
        [chattingNavController setTitle:NSLocalizedString(@"Inbox", nil)];
        [chattingNavController.tabBarItem setImage:[UIImage imageNamed:@"chat_tab_icon.png"]];
        
        NSArray *controllers = [NSArray arrayWithObjects:browserNavController, newsFeedfNavController, uploadingNavController,activityNavController, chattingNavController, nil];
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
//    if (controllerIndex == 0) {
//        [_brController retrieveLatestWantData];
//    } else if (controllerIndex == 2) {
//        [_myWantVC retrieveLatestWantData];
//        [self setSelectedIndex:2];
//    } else if (controllerIndex == 3) {
//        [_mySellVC retrieveLatestWantData];
//        [self setSelectedIndex:3];
//    }
}


@end
