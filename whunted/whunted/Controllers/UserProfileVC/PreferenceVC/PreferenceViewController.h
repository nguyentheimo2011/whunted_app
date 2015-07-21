//
//  PreferenceViewController.h
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CountryTableViewController.h"
#import "IGLDropDownMenu.h"

@interface PreferenceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CountryTableViewDelegate, IGLDropDownMenuDelegate>

@end
