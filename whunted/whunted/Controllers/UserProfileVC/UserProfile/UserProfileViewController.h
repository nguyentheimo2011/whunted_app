//
//  UserProfileViewController.h
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsTableVC.h"

#import <Parse/Parse.h>

@class UserProfileViewController;

//-------------------------------------------------------------------------------------------------------------------------------
@protocol UserProfileViewControllerDelegate <NSObject>
//-------------------------------------------------------------------------------------------------------------------------------

- (void) userProfileViewController: (UserProfileViewController *) controller didPressLogout: (BOOL) pressed;

@end


//-------------------------------------------------------------------------------------------------------------------------------
@interface UserProfileViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
//-------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak)     id<UserProfileViewControllerDelegate>   delegate;

@property (nonatomic, strong)   PFUser      *profileOwner;


- (void) retrieveLatestWantData;
- (void) retrieveLatestSellData;
- (id) initWithProfileOwner: (PFUser *) profileOwner;

@end
