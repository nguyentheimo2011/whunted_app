//
//  MarketplaceHelper.m
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceUIHelper.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation MarketplaceUIHelper

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

//-----------------------------------------------------------------------------------------------------------------------------
+ (UIView *) addSortAndFilterBarWithHeight: (CGFloat) height toViewController: (UIViewController *) viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBarYPos      =   [Utilities getHeightOfNavigationAndStatusBars:viewController];
    
    UIView *sortAndFilterBar = [[UIView alloc] initWithFrame:CGRectMake(0, kBarYPos, WINSIZE.width, height)];
    sortAndFilterBar.backgroundColor = [UIColor whiteColor];
    [viewController.view addSubview:sortAndFilterBar];
    
    [self addHorizontalLineToSortAndFilterBar:sortAndFilterBar];
    
    return sortAndFilterBar;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) addHorizontalLineToSortAndFilterBar: (UIView *) sortAndFilterBar
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, sortAndFilterBar.frame.size.height - 0.5f, WINSIZE.width, 0.5f)];
    horizontalLine.backgroundColor = GRAY_COLOR_LIGHT;
    [sortAndFilterBar addSubview:horizontalLine];
}

@end
