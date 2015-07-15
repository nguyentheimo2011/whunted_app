//
//  ProductOriginTableViewController.h
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountryTableViewController;

@protocol CountryTableViewDelegate <NSObject>

- (void) countryTableView: (CountryTableViewController *) controller didCompleteChoosingCountries: (NSArray *) countries;

@end

@interface CountryTableViewController : UITableViewController

@property (nonatomic, weak) id<CountryTableViewDelegate> delegate;

@property (nonatomic, strong) NSArray *selectedCountries;

- (id) initWithSelectedCountries: (NSArray *) countries;

@end
