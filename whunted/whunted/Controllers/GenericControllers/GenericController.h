//
//  CommonNavController.h
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageGetterViewController.h"
#import "UploadingWantDetailsViewController.h"
#import "UserProfileViewController.h"
#import "ImageRetrieverViewController.h"
#import <CLImageEditor.h>

@class GenericController;

@protocol GenericControllerDelegate <NSObject>

- (void) genericController: (GenericController *) controller shouldUpdateDataAt: (NSInteger) controllerIndex;

@end

@interface GenericController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageGetterViewControllerDelegate, UploadingWantDetailsViewControllerDelegate, UserProfileViewControllerDelegate, ImageRetrieverDelegate, CLImageEditorDelegate>

@property (nonatomic, weak) id<GenericControllerDelegate> delegate;

- (void) pushViewController: (UIViewController *) controller;

@end
