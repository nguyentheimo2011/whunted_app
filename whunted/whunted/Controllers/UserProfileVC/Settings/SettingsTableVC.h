//
//  SettingsTableVC.h
//  whunted
//
//  Created by thomas nguyen on 28/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditProfileViewController.h"

@class SettingsTableVC;

//------------------------------------------------------------------------------------------------------------------------------
@protocol SettingsTableViewDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

- (void) didUpdateProfileInfo;

@end


//------------------------------------------------------------------------------------------------------------------------------
@interface SettingsTableVC : UITableViewController <EditProfileDelegate>
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)   id<SettingsTableViewDelegate>   delegate;

@end
