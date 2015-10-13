//
//  MainViewController.h
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageGetterViewController.h"
#import "ImageRetrieverViewController.h"
#import "UploadingWantDetailsViewController.h"
#import "MarketplaceViewController.h"
#import "InboxAllViewController.h"

#import <CLImageEditor.h>
#import <RSKImageCropper.h>

@interface MainViewController : UITabBarController <UITabBarControllerDelegate,
                                                    UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate,
                                                    ImageGetterViewControllerDelegate,
                                                    ImageRetrieverDelegate,
                                                    CLImageEditorDelegate,
                                                    UploadingWantDetailsViewControllerDelegate,
                                                    RSKImageCropViewControllerDataSource,
                                                    RSKImageCropViewControllerDelegate,
                                                    InboxAllViewDelegate>

@end
