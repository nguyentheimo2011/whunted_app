//
//  SellerListViewController.h
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"
#import "SellerListCell.h"

@class SellerListViewController;

@protocol SellerListViewControllerDelegate <NSObject>

- (void) sellerListViewController: (SellerListViewController *) controller didAcceptOfferFromSeller: (WantData *) wantData;

@end

@interface SellerListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SellerListCellDelegate>

@property (nonatomic, strong) id<SellerListViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView *sellerTableView;
@property (nonatomic, strong) WantData *wantData;

@end
