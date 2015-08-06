//
//  UploadingViewController.m
//  whunted
//
//  Created by thomas nguyen on 5/8/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UploadingViewController.h"

@interface UploadingViewController ()

@end

@implementation UploadingViewController
{
    
    NSUInteger      currButtonIndex;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
//    [self showImageGettingOptionPopup];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//--------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor whiteColor];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) uploadingWantDetailsViewController:(UploadingWantDetailsViewController *)controller didPressItemImageButton:(NSUInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
    currButtonIndex = buttonIndex;
//    [self showImageGettingOptionPopup];
}

#pragma mark - Image Getter View Controller delegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageGetterViewController:(ImageGetterViewController *)controller didChooseAMethod:(ImageGettingMethod)method
//-------------------------------------------------------------------------------------------------------------------------------
{
//    if (popup != nil) {
//        [popup dismiss:YES];
//    }
    
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

#pragma mark - CLImageEditorDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
//-------------------------------------------------------------------------------------------------------------------------------
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

@end
