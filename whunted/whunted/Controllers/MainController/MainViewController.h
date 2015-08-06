//
//  MainViewController.h
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericController.h"
#import "ImageGetterViewController.h"
#import "ImageRetrieverViewController.h"
#import "UploadingWantDetailsViewController.h"

#import <CLImageEditor.h>

@interface MainViewController : UITabBarController<UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GenericControllerDelegate, ImageGetterViewControllerDelegate, ImageRetrieverDelegate, CLImageEditorDelegate, UploadingWantDetailsViewControllerDelegate>

@end
