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
#pragma mark - Search bar
//-----------------------------------------------------------------------------------------------------------------------------

+ (UISearchBar *) addSearchBoxToViewController: (UIViewController<UISearchBarDelegate> *) viewController;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - SortAndFilter bar
//-----------------------------------------------------------------------------------------------------------------------------

+ (UIView *) addSortAndFilterBarWithHeight: (CGFloat) height toViewController: (UIViewController *) viewController;

+ (void) addHorizontalLineToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UILabel *) addBuyerLocationFilterToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UILabel *) addCategoryFilterToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UILabel *) addSortAndFilterOptionToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UIView *) addContainerWithTag:(NSInteger)tag toSortAndFilterBar:(UIView *)sortAndFilterBar;

+ (void) addIconImageViewToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (void) addTitleLabelToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (UILabel *) addCurCriterionLabelToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (void) addDownIconArrowToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (void) addVerticalLineToContainer: (UIView *) container;

+ (void) addTapGestureRecognizerToView: (UIView *) container withTag: (NSInteger) tag inViewController: (UIViewController *) viewController;

@end
