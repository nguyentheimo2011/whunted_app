//
//  UploadMethodViewController.h
//  whunted
//
//  Created by thomas nguyen on 12/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppConstant.h"

#import <JTImageButton.h>

@class ImageGetterViewController;

//--------------------------------------------------------------------------------------------------------------------------------
@protocol ImageGetterViewControllerDelegate <NSObject>
//--------------------------------------------------------------------------------------------------------------------------------

- (void) imageGetterViewController: (ImageGetterViewController *) controller didChooseAMethod: (ImageGettingMethod) method;

@end

//--------------------------------------------------------------------------------------------------------------------------------
@interface ImageGetterViewController : UIViewController
//--------------------------------------------------------------------------------------------------------------------------------

@property (weak, nonatomic) id<ImageGetterViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView             *titleView;
@property (weak, nonatomic) IBOutlet UILabel            *firstTitleLabel;
@property (weak, nonatomic) IBOutlet JTImageButton      *takingPhotoButton;
@property (weak, nonatomic) IBOutlet JTImageButton      *choosingPhotoButton;
@property (weak, nonatomic) IBOutlet JTImageButton      *postingImageLinkButton;


- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)imageLinkOptionChosen:(UIButton *)sender;


@end
