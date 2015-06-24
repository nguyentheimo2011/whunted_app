//
//  CommonNavController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "KLCPopup.h"
#import "AppConstant.h"
#import "GenericController.h"
#import "InboxAllViewController.h"

@interface GenericController ()

@end

@implementation GenericController
{
    KLCPopup* popup;
    NSUInteger currButtonIndex;
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        [self customizeTarBarAppearance];
    }
    return self;
}

- (void) viewDidLoad
{
    [self addBarItems];
}

- (void) addBarItems
{
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:nil];

    UIImage *chatImage = [UIImage imageNamed:@"chat.png"];
    UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithImage:chatImage style:UIBarButtonItemStylePlain target:self action:@selector(openInbox)];
    
    UIImage *profile = [UIImage imageNamed:@"profile.png"];
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:profile style:UIBarButtonItemStylePlain target:self action:@selector(userProfileButtonClickedEvent)];
    
    UIImage *camera = [UIImage imageNamed:@"camera.png"];
    UIBarButtonItem *wantButton = [[UIBarButtonItem alloc] initWithImage:camera style:UIBarButtonItemStylePlain target:self action:@selector(showImageGettingOptionPopup)];
    
    NSArray *actionButtonItems = @[wantButton, profileButton, chatButton, searchButton];
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

- (void) showImageGettingOptionPopup
{
    ImageGetterViewController *imageGetterVC = [[ImageGetterViewController alloc] init];
    imageGetterVC.delegate = self;
    
    popup = [KLCPopup popupWithContentViewController:imageGetterVC];
    [popup show];
}

- (void) userProfileButtonClickedEvent
{
    UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] init];
    userProfileVC.delegate = self;
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

- (void) openInbox
{
    InboxAllViewController *inboxVC = [[InboxAllViewController alloc] init];
    [self.navigationController pushViewController:inboxVC animated:YES];
}

#pragma mark - Upload Want Details View Controller delegate methods

- (void) uploadingWantDetailsViewController:(UploadingWantDetailsViewController *)controller didPressItemImageButton:(NSUInteger)buttonIndex
{
    currButtonIndex = buttonIndex;
    [self showImageGettingOptionPopup];
}

- (void) uploadingWantDetailsViewController:(UploadingWantDetailsViewController *)controller didCompleteSubmittingWantData:(WantData *)wantData
{
    [self.delegate genericController:self shouldUpdateDataAt:0];
    [self.delegate genericController:self shouldUpdateDataAt:2];
}

#pragma mark - Image Getter View Controller delegate methods
- (void) imageGetterViewController:(ImageGetterViewController *)controller didChooseAMethod:(ImageGettingMethod)method
{
    if (popup != nil) {
        [popup dismiss:YES];
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
        [self.navigationController pushViewController:retrieverVC animated:YES];
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self sendImageToUploadingWantDetailsVC:chosenImage];
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) customizeTarBarAppearance
{
    [[UITabBar appearance] setTintColor:DARKER_BLUE_COLOR];
}

#pragma mark - ImageRetrieverDekegate methods
- (void) imageRetrieverViewController:(ImageRetrieverViewController *)controller didRetrieveImage:(UIImage *)image
{
    [self.navigationController popViewControllerAnimated:NO];
    [self sendImageToUploadingWantDetailsVC:image];
}

- (void) sendImageToUploadingWantDetailsVC: (UIImage *) image
{
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    editor.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:editor animated:NO];
}

#pragma mark - CLImageEditorDelegate methods

- (void) imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    [self.navigationController popViewControllerAnimated:NO];
    UIViewController *topVC = [self.navigationController topViewController];
    if ([topVC isKindOfClass:[UploadingWantDetailsViewController class]]) {
        UploadingWantDetailsViewController *wantDetailsVC = (UploadingWantDetailsViewController *) topVC;
        [wantDetailsVC setImage:image forButton:currButtonIndex];
    } else {
        UploadingWantDetailsViewController *wantDetailsVC = [[UploadingWantDetailsViewController alloc] init];
        wantDetailsVC.delegate = self;
        currButtonIndex = 0;
        [wantDetailsVC setImage:image forButton:currButtonIndex];
        [self.navigationController pushViewController:wantDetailsVC animated:NO];
    }
}

#pragma mark - UserProfileViewController Delegate methods
- (void) userProfileViewController:(UserProfileViewController *)controller didPressLogout:(BOOL)pressed
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Methods for overridding by inherited class
- (void) pushViewController: (UIViewController *) controller
{
    
}


@end
