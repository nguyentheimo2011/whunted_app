//
//  ResidingCityTableVC.h
//  whunted
//
//  Created by thomas nguyen on 27/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResidingCityTableVC;

// ------------------------------------------------------------------------------------------------------------------------------
@protocol ResidingCityDelegate <NSObject>
// ------------------------------------------------------------------------------------------------------------------------------

- (void) residingCity: (ResidingCityTableVC *) controller didSelectCity: (NSDictionary *) countryCity;

@end

// ------------------------------------------------------------------------------------------------------------------------------
@interface ResidingCityTableVC : UITableViewController
// ------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong) NSString  *countryName;
@property (nonatomic, strong) NSArray   *cityList;

@property (nonatomic, strong) id<ResidingCityDelegate> delegate;

- (id) initWithCountry: (NSString *) country andCities: (NSArray *) cityList;

@end
