//
//  MarketplaceHelper.m
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceHelper.h"
#import "AppConstant.h"

@implementation MarketplaceHelper

#pragma mark - UI Functions

//-----------------------------------------------------------------------------------------------------------------------------
+ (UISearchBar *) addSearchBoxToViewController:(UIViewController<UISearchBarDelegate> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, WINSIZE.width, 28.0)];
    searchBar.placeholder = NSLocalizedString(@"Search for whunts", nil);
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = viewController;
    searchBar.tintColor = LIGHT_GRAY_COLOR;
    searchBar.barTintColor = [UIColor colorWithRed:77.0/255 green:124.0/255 blue:194.0/255 alpha:0.5f];
    viewController.navigationItem.titleView = searchBar;
    
    UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = MAIN_BLUE_COLOR;
    txfSearchField.textColor = [UIColor whiteColor];
    
    if ([txfSearchField respondsToSelector:@selector(setAttributedPlaceholder:)])
    {
        txfSearchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search for whunts", nil) attributes:@{NSForegroundColorAttributeName: LIGHT_GRAY_COLOR}];
    }
    
    return searchBar;
}

@end
