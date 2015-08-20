//
//  MySellViewController.h
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellTableViewCell.h"
#import "SellerListViewController.h"

@interface MySellViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SellTableViewCellDelegate, SellerListViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *wantDataList;

- (void) retrieveLatestWantData;

@end
