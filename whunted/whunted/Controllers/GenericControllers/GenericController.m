//
//  CommonNavController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "AppConstant.h"
#import "GenericController.h"
#import "InboxAllViewController.h"

@interface GenericController ()

@end

@implementation GenericController
{
    
}

//-------------------------------------------------------------------------------------------------------------------------------
- (id) init
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addBarItems];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addBarItems
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:nil];
    
//    UIImage *profile = [UIImage imageNamed:@"profile.png"];
//    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:profile style:UIBarButtonItemStylePlain target:self action:@selector(userProfileButtonClickedEvent)];
    
    NSArray *actionButtonItems = @[searchButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 100)];
    UIImage *appIcon = [UIImage imageNamed:@"app_icon.png"];
    UIImageView *appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 30, 29)];
    appIconView.layer.cornerRadius = 5;
    appIconView.clipsToBounds = YES;
    [appIconView setImage:appIcon];
    [titleView addSubview:appIconView];
    self.navigationItem.titleView = titleView;
}

#pragma mark - Event Handlers

////-------------------------------------------------------------------------------------------------------------------------------
//- (void) userProfileButtonClickedEvent
////-------------------------------------------------------------------------------------------------------------------------------
//{
//    UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] init];
//    userProfileVC.delegate = self;
//    [self.navigationController pushViewController:userProfileVC animated:YES];
//}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) openInbox
//-------------------------------------------------------------------------------------------------------------------------------
{
    InboxAllViewController *inboxVC = [[InboxAllViewController alloc] init];
    [self.navigationController pushViewController:inboxVC animated:YES];
}

#pragma mark - Upload Want Details View Controller delegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) uploadingWantDetailsViewController:(UploadingWantDetailsViewController *)controller didCompleteSubmittingWantData:(WantData *)wantData
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.delegate genericController:self shouldUpdateDataAt:0];
    [self.delegate genericController:self shouldUpdateDataAt:2];
}


#pragma mark - Image Picker Controller delegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self sendImageToUploadingWantDetailsVC:chosenImage];
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
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
    [self.navigationController popViewControllerAnimated:NO];
    [self sendImageToUploadingWantDetailsVC:image];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) sendImageToUploadingWantDetailsVC: (UIImage *) image
//-------------------------------------------------------------------------------------------------------------------------------
{
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    editor.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:editor animated:NO];
}

#pragma mark - UserProfileViewController Delegate methods

////-------------------------------------------------------------------------------------------------------------------------------
//- (void) userProfileViewController:(UserProfileViewController *)controller didPressLogout:(BOOL)pressed
////-------------------------------------------------------------------------------------------------------------------------------
//{
//    [PFUser logOut];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Methods for overridding by inherited class

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushViewController: (UIViewController *) controller
//-------------------------------------------------------------------------------------------------------------------------------
{
    
}


@end
