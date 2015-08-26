//
//  ProductOriginTableViewController.h
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountryTableViewController;

//------------------------------------------------------------------------------------------------------------------------------
@protocol CountryTableViewDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

@optional

- (void) countryTableView: (CountryTableViewController *) controller didCompleteChoosingCountries: (NSArray *) countries;
- (void) countryTableView: (CountryTableViewController *) controller didCompleteChoosingACountry: (NSString *) country;

@end


//------------------------------------------------------------------------------------------------------------------------------
@interface CountryTableViewController : UITableViewController
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak)     id<CountryTableViewDelegate> delegate;

@property (nonatomic, strong)   NSArray     *selectedCountries;
@property (nonatomic)           NSInteger   tag;

@property (nonatomic)           BOOL        usedForFiltering;

- (id) initWithSelectedCountries: (NSArray *) countries usedForFiltering: (BOOL) used;

@end
