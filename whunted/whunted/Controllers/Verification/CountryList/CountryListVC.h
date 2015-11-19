//
//  CountryListVC.h
//  whunted
//
//  Created by thomas nguyen on 19/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------
@protocol CountryListDelegate <NSObject>
//-----------------------------------------------------------------------------------------------------------------------------

- (void) didChooseACountry: (NSString *) countryName withCountryCode: (NSString *) countryCode;

@end


//-----------------------------------------------------------------------------------------------------------------------------
@interface CountryListVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
//-----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak)         id<CountryListDelegate>     delegate;

@end
