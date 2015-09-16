//
//  WantDetailsViewController.h
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryTableViewController.h"
#import "ItemInfoTableViewController.h"
#import "ImageGetterViewController.h"
#import "ImageRetrieverViewController.h"
#import "WantData.h"
#import "CityViewController.h"

#import <CLImageEditor.h>
#import <RSKImageCropper.h>
#import <APNumberPad.h>

@class UploadingWantDetailsViewController;

//-------------------------------------------------------------------------------------------------------------------------------
@protocol UploadingWantDetailsViewControllerDelegate <NSObject>
//-------------------------------------------------------------------------------------------------------------------------------

- (void) uploadingWantDetailsViewController: (UploadingWantDetailsViewController *) controller didCompleteSubmittingWantData: (WantData *) wantData;

@end


//-------------------------------------------------------------------------------------------------------------------------------
@interface UploadingWantDetailsViewController : UITableViewController
//-------------------------------------------------------------------------------------------------------------------------------
                                                <CategoryTableViewControllerDelegate,
                                                 CityViewDelegate,
                                                 ItemInfoTableViewControllerDelegate,
                                                 UITextFieldDelegate,
                                                 UIAlertViewDelegate,
                                                 APNumberPadDelegate,
                                                 ImageGetterViewControllerDelegate,
                                                 UINavigationControllerDelegate,
                                                 UIImagePickerControllerDelegate,
                                                 ImageRetrieverDelegate,
                                                 CLImageEditorDelegate,
                                                 RSKImageCropViewControllerDelegate,
                                                 RSKImageCropViewControllerDataSource>


@property (nonatomic, weak) id<UploadingWantDetailsViewControllerDelegate> delegate;

@property (nonatomic, strong)   WantData                *wantData;


- (void) setImage: (UIImage *) image forButton: (NSUInteger) buttonIndex;

- (void) customizeBarButtons;

- (id) initWithWantData: (WantData *) wantData;


@end
