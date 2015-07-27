//
//  ResidingCountryTableVC.h
//  whunted
//
//  Created by thomas nguyen on 24/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResidingCityTableVC.h"

@interface ResidingCountryTableVC : UITableViewController

@property (nonatomic) id<ResidingCityDelegate> delegate;

@end
