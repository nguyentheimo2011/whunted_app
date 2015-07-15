//
//  WantDetailsViewController.h
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APNumberPad.h>
#import "CategoryTableViewController.h"
#import "LocationTableViewController.h"
#import "ItemInfoTableViewController.h"
#import "CountryTableViewController.h"
#import "WantData.h"

@class UploadingWantDetailsViewController;

@protocol UploadingWantDetailsViewControllerDelegate <NSObject>

- (void) uploadingWantDetailsViewController: (UploadingWantDetailsViewController *) controller didPressItemImageButton: (NSUInteger) buttonIndex;
- (void) uploadingWantDetailsViewController: (UploadingWantDetailsViewController *) controller didCompleteSubmittingWantData: (WantData *) wantData;

@end

@interface UploadingWantDetailsViewController : UITableViewController <CategoryTableViewControllerDelegate, LocationTableViewControllerDelegate, ItemInfoTableViewControllerDelegate, CountryTableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, APNumberPadDelegate>

@property (weak, nonatomic) id<UploadingWantDetailsViewControllerDelegate> delegate;

- (void) setImage: (UIImage *) image forButton: (NSUInteger) buttonIndex;

@end
