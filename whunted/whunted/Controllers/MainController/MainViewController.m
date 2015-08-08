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
    
    UINavigationController      *_uploadingNavController;
    
    KLCPopup                    *_popup;
    NSUInteger                  _currButtonIndex;
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


#pragma mark - UITabBarControllerDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    if ([viewController.title isEqualToString:TAB_BAR_UPLOAD_PAGE_TITLE]) {
        _uploadingNavController = [[UINavigationController alloc] init];
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


#pragma mark - ImageGetterPopup delegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageGetterViewController:(ImageGetterViewController *)controller didChooseAMethod:(ImageGettingMethod)method
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (_popup != nil) {
        [_popup dismiss:YES];
    }
    
    if (method == PhotoLibrary) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else if (method == Camera) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else if (method == ImageURL) {
        ImageRetrieverViewController *retrieverVC = [[ImageRetrieverViewController alloc] init];
        retrieverVC.delegate = self;
        
        [_uploadingNavController setViewControllers:@[retrieverVC]];
        [self presentViewController:_uploadingNavController animated:YES completion:nil];
    }
}


#pragma mark - ImagePickerControllerDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self sendImageToUploadingWantDetailsVC:chosenImage withNavigationControllerNeeded:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//-------------------------------------------------------------------------------------------------------------------------------
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - ImageRetrieverDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageRetrieverViewController:(ImageRetrieverViewController *)controller didRetrieveImage:(UIImage *)image
//-------------------------------------------------------------------------------------------------------------------------------
{
//    [_uploadingNavController dismissViewControllerAnimated:YES completion:nil];
    
    [self sendImageToUploadingWantDetailsVC:image withNavigationControllerNeeded:NO];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) sendImageToUploadingWantDetailsVC: (UIImage *) image withNavigationControllerNeeded: (BOOL) needed
//-------------------------------------------------------------------------------------------------------------------------------
{
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    editor.hidesBottomBarWhenPushed = YES;
    
    editor.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [_uploadingNavController pushViewController:editor animated:YES];
}


#pragma mark - CLImageEditorDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:NO];
    UIViewController *topVC = [self.navigationController topViewController];
    if ([topVC isKindOfClass:[UploadingWantDetailsViewController class]]) {
        UploadingWantDetailsViewController *wantDetailsVC = (UploadingWantDetailsViewController *) topVC;
        [wantDetailsVC setImage:image forButton:_currButtonIndex];
    } else {
        UploadingWantDetailsViewController *wantDetailsVC = [[UploadingWantDetailsViewController alloc] init];
        wantDetailsVC.delegate = self;
        _currButtonIndex = 0;
        [wantDetailsVC setImage:image forButton:_currButtonIndex];
        
        [editor dismissViewControllerAnimated:YES completion:nil];
        [_uploadingNavController setViewControllers:@[wantDetailsVC]];
        [self presentViewController:_uploadingNavController animated:YES completion:nil];
    }
}


#pragma mark - UploadWantDetailsDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) uploadingWantDetailsViewController:(UploadingWantDetailsViewController *)controller didCompleteSubmittingWantData:(WantData *)wantData
//-------------------------------------------------------------------------------------------------------------------------------
{
//    [self.delegate genericController:self shouldUpdateDataAt:0];
//    [self.delegate genericController:self shouldUpdateDataAt:2];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) uploadingWantDetailsViewController:(UploadingWantDetailsViewController *)controller didPressItemImageButton:(NSUInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
    _currButtonIndex = buttonIndex;
        [self showImageGettingOptionPopup];
}


@end
