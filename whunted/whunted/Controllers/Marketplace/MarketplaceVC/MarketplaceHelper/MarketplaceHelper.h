//
//  MarketplaceHelper.h
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MarketplaceHelper : NSObject

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI functions
//-----------------------------------------------------------------------------------------------------------------------------

+ (UISearchBar *) addSearchBoxToViewController: (UIViewController<UISearchBarDelegate> *) viewController;

@end
