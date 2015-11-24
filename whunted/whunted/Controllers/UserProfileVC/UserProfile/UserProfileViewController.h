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

//-------------------------------------------------------------------------------------------------------------------------------
@interface UserProfileViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
//-------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)   PFUser      *profileOwner;

- (void) retrieveLatestWantData;
- (void) retrieveLatestSellData;

- (id)   initWithProfileOwner: (PFUser *) profileOwner;

@end
