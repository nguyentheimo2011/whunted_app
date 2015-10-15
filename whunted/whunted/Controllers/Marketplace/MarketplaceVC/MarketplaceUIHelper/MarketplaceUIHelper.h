//
//  MarketplaceHelper.h
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CityViewController.h"
#import "CategoryTableViewController.h"
#import "SortAndFilterTableVC.h"

@interface MarketplaceUIHelper : NSObject

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Search Bar
//-----------------------------------------------------------------------------------------------------------------------------

+ (UISearchBar *) addSearchBoxToViewController: (UIViewController<UISearchBarDelegate> *) viewController;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - SortAndFilter Bar
//-----------------------------------------------------------------------------------------------------------------------------

+ (UIView *)    addSortAndFilterBarWithHeight: (CGFloat) height toViewController: (UIViewController *) viewController;

+ (void)        addHorizontalLineToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UILabel *)   addBuyerLocationFilterToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UILabel *)   addCategoryFilterToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UILabel *)   addSortAndFilterOptionToSortAndFilterBar: (UIView *) sortAndFilterBar;

+ (UIView *)    addContainerWithTag:(NSInteger)tag toSortAndFilterBar:(UIView *)sortAndFilterBar;

+ (void)        addIconImageViewToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (void)        addTitleLabelToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (UILabel *)   addCurCriterionLabelToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (void)        addDownIconArrowToContainer: (UIView *) container withTag: (NSInteger) tag;

+ (void)        addVerticalLineToContainer: (UIView *) container;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - SortAndFilter Bar Event Handler
//-----------------------------------------------------------------------------------------------------------------------------

+ (void) presentLocationSelectorInViewController: (UIViewController<CityViewDelegate> *) controller currLocation: (NSString *) location;

+ (void) presentCategorySelectorInViewController: (UIViewController<CategoryTableViewControllerDelegate> *) controller currCategory: (NSString *) category;

+ (void) presentSortAndFilterSelectorInViewController: (UIViewController<SortAndFilterTableViewDelegate> *) controller currSortingChoice: (NSString *) sortingChoice currProductOrigin: (NSString *) productOrigin;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View
//-----------------------------------------------------------------------------------------------------------------------------

+ (UICollectionView *) addCollectionViewToViewController: (UIViewController<UICollectionViewDelegate, UICollectionViewDataSource> *) viewController;

+ (UIRefreshControl *) addTopRefreshControlToCollectionView: (UICollectionView *) collectionView;


@end
