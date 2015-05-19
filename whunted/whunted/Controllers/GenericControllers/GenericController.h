//
//  CommonNavController.h
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageGetterViewController.h"
#import "WantDetailsViewController.h"

@interface GenericController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageGetterViewControllerDelegate, WantDetailsViewControllerDelegate>


@end
