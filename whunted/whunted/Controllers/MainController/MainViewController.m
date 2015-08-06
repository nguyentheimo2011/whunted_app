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
#import "UploadingViewController.h"
#import "UserProfileViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>
#import "KLCPopup.h"

@interface MainViewController ()
{
    MarketplaceViewController   *_brController;
    InboxAllViewController      *_inboxVC;
    NewsFeedViewController      *_newsFeedVC;
    UploadingViewController     *_uploadingVC;
    UserProfileViewController   *_userProfileVC;
    
    KLCPopup                    *_popup;
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
        [browserNavController setTitle:NSLocalizedString(TAB_BAR_MARKETPLACE_PAGE_TITLE, nil)];
        [browserNavController.tabBarItem setImage:[UIImage imageNamed:@"marketplace.png"]];
        _brController.delegate = self;
        
        UINavigationController *newsFeedfNavController = [[UINavigationController alloc] init];
        _newsFeedVC = [[NewsFeedViewController alloc] init];
        [newsFeedfNavController setViewControllers:[NSArray arrayWithObject:_newsFeedVC]];
        [newsFeedfNavController setTitle:NSLocalizedString(TAB_BAR_NEWSFEED_PAGE_TITLE, nil)];
        [newsFeedfNavController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
        _newsFeedVC.delegate = self;
        
        UINavigationController *uploadingNavController = [[UINavigationController alloc] init];
        _uploadingVC = [[UploadingViewController alloc] init];
        [uploadingNavController setViewControllers:@[_uploadingVC]];
        [uploadingNavController setTitle:NSLocalizedString(TAB_BAR_UPLOAD_PAGE_TITLE, nil)];
        [uploadingNavController.tabBarItem setImage:[UIImage imageNamed:@"camera_tab_icon.png"]];
        
        UINavigationController *chattingNavController = [[UINavigationController alloc] init];
        _inboxVC = [[InboxAllViewController alloc] init];
        [chattingNavController setViewControllers: [NSArray arrayWithObject:_inboxVC]];
        [chattingNavController setTitle:NSLocalizedString(TAB_BAR_INBOX_PAGE_TITLE, nil)];
        [chattingNavController.tabBarItem setImage:[UIImage imageNamed:@"chat_tab_icon.png"]];
        
        UINavigationController *userProfileNavController = [[UINavigationController alloc] init];
        _userProfileVC = [[UserProfileViewController alloc] init];
        [userProfileNavController setViewControllers: [NSArray arrayWithObject:_userProfileVC]];
        [userProfileNavController setTitle:NSLocalizedString(TAB_BAR_PROFILE_PAGE_TITLE, nil)];
        [userProfileNavController.tabBarItem setImage:[UIImage imageNamed:@"profile_tab_icon.png"]];
        
        NSArray *controllers = [NSArray arrayWithObjects:browserNavController, newsFeedfNavController, uploadingNavController, chattingNavController, userProfileNavController, nil];
        [self setViewControllers:controllers];
        [self setSelectedIndex:0];
        
        self.delegate = self;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Overriding methods

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    if ([viewController.title isEqualToString:TAB_BAR_UPLOAD_PAGE_TITLE]) {
        [self showImageGettingOptionPopup];
        
        return NO;
    } else
        return YES;
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

#pragma mark - Event Handler

//-------------------------------------------------------------------------------------------------------------------------------
- (void) showImageGettingOptionPopup
//-------------------------------------------------------------------------------------------------------------------------------
{
    ImageGetterViewController *imageGetterVC = [[ImageGetterViewController alloc] init];
    imageGetterVC.delegate = self;
    
    _popup = [KLCPopup popupWithContentViewController:imageGetterVC];
    [_popup show];
}


@end
