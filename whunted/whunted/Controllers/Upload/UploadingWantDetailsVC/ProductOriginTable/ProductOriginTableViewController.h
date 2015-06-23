//
//  ProductOriginTableViewController.h
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductOriginTableViewController;

@protocol ProductOriginTableViewDelegate <NSObject>

- (void) productOriginTableView: (ProductOriginTableViewController *) controller didCompleteChoosingOrigins: (NSArray *) countries;

@end

@interface ProductOriginTableViewController : UITableViewController

@property (nonatomic, weak) id<ProductOriginTableViewDelegate> delegate;

@property (nonatomic, strong) NSArray *selectedOrigins;

- (id) initWithSelectedOrigins: (NSArray *) origins;

@end
