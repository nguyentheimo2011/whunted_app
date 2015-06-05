//
//  SellerListViewController.h
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *sellerTableView;
@property (nonatomic, strong) NSArray *sellersOfferList;

@end
