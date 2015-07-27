//
//  EditProfileViewController.h
//  whunted
//
//  Created by thomas nguyen on 22/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResidingCountryTableVC.h"

@interface EditProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, ResidingCityDelegate>

@end
