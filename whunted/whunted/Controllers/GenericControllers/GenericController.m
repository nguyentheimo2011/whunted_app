//
//  CommonNavController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "KLCPopup.h"

#import "GenericController.h"

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
        [self addBarItems];
    }
    return self;
}

- (void) addBarItems
{
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *chatImage = [UIImage imageNamed:@"chat.png"];
    UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithImage:chatImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *profile = [UIImage imageNamed:@"profile.png"];
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:profile style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *camera = [UIImage imageNamed:@"camera.png"];
    UIBarButtonItem *wantButton = [[UIBarButtonItem alloc] initWithImage:camera style:UIBarButtonItemStylePlain target:self action:@selector(showImageGettingOptionPopup)];
    
    
    NSArray *actionButtonItems = @[wantButton, profileButton, chatButton, searchButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    UIImage *appIcon = [UIImage imageNamed:@"app_icon.png"];
    UIBarButtonItem *appIconButton = [[UIBarButtonItem alloc] initWithImage:appIcon style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = appIconButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void) showImageGettingOptionPopup
{
    ImageGetterViewController *imageGetterVC = [[ImageGetterViewController alloc] init];
    imageGetterVC.delegate = self;
    
    popup = [KLCPopup popupWithContentViewController:imageGetterVC];
    [popup show];
}

#pragma mark - Want Details View Controller delegate methods

- (void) wantDetailsViewController:(WantDetailsViewController *)controller didPressButton:(NSUInteger)buttonIndex
{
    currButtonIndex = buttonIndex;
    [self showImageGettingOptionPopup];
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
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (method == Camera) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (method == ImageURL) {
        
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIViewController *topVC = [self.navigationController topViewController];
    if ([topVC isKindOfClass:[WantDetailsViewController class]]) {
        WantDetailsViewController *wantDetailsVC = (WantDetailsViewController *) topVC;
        [wantDetailsVC setImage:chosenImage forButton:currButtonIndex];
    } else {
        WantDetailsViewController *wantDetailsVC = [[WantDetailsViewController alloc] init];
        wantDetailsVC.delegate = self;
        currButtonIndex = 0;
        [wantDetailsVC setImage:chosenImage forButton:currButtonIndex];
        [self.navigationController pushViewController:wantDetailsVC animated:YES];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
