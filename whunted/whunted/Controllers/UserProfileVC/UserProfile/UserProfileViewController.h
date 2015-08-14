//
//  UserProfileViewController.h
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericController.h"
#import "EditProfileViewController.h"

@class UserProfileViewController;

//-------------------------------------------------------------------------------------------------------------------------------
@protocol UserProfileViewControllerDelegate <NSObject>
//-------------------------------------------------------------------------------------------------------------------------------

- (void) userProfileViewController: (UserProfileViewController *) controller didPressLogout: (BOOL) pressed;

@end

//-------------------------------------------------------------------------------------------------------------------------------
@interface UserProfileViewController : GenericController<UICollectionViewDataSource, UICollectionViewDelegate, EditProfileDelegate>
//-------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak) id<UserProfileViewControllerDelegate, GenericControllerDelegate> delegate;

- (void) retrieveLatestWantData;

- (void) retrieveLatestSellData;

@end
