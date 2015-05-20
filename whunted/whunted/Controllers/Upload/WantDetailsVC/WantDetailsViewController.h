//
//  WantDetailsViewController.h
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"
#import "LocationTableViewController.h"
#import "ItemInfoTableViewController.h"

@class WantDetailsViewController;

@protocol WantDetailsViewControllerDelegate <NSObject>

- (void) wantDetailsViewController: (WantDetailsViewController *) controller didPressItemImageButton: (NSUInteger) buttonIndex;
- (void) wantDetailsViewController: (WantDetailsViewController *) controller didPressSubmittingButton: (NSDictionary *) itemInfoDict;

@end

@interface WantDetailsViewController : UITableViewController <CategoryTableViewControllerDelegate, LocationTableViewControllerDelegate, ItemInfoTableViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) id<WantDetailsViewControllerDelegate> delegate;

- (void) setImage: (UIImage *) image forButton: (NSUInteger) buttonIndex;

@end
