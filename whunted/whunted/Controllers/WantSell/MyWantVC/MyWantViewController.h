//
//  MyWantViewController.h
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericController.h"
#import "WantTableViewCell.h"
#import "SellerListViewController.h"

@interface MyWantViewController : GenericController <UITableViewDataSource, UITableViewDelegate, WantTableViewCellDelegate, SellerListViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *wantDataList;

- (void) retrieveLatestWantData;

@end
