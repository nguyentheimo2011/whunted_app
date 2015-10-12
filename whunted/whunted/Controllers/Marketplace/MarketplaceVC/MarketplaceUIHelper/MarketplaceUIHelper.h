//
//  MarketplaceHelper.h
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MarketplaceUIHelper : NSObject

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI functions
//-----------------------------------------------------------------------------------------------------------------------------

+ (UISearchBar *) addSearchBoxToViewController: (UIViewController<UISearchBarDelegate> *) viewController;

+ (UIView *) addSortAndFilterBarWithHeight: (CGFloat) height toViewController: (UIViewController *) viewController;

@end
