//
//  MyWantTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 22/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"

@interface MyWantTableViewCell : UITableViewCell <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) WantData *wantData;

@end
