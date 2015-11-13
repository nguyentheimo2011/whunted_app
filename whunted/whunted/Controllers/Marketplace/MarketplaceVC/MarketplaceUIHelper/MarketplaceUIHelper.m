//
//  MarketplaceHelper.m
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceUIHelper.h"
#import "MarketplaceLogicHelper.h"
#import "MarketplaceCollectionViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"


@implementation MarketplaceUIHelper

#pragma mark - Search bar

//-----------------------------------------------------------------------------------------------------------------------------
+ (UISearchBar *) addSearchBoxToViewController:(UIViewController<UISearchBarDelegate> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, WINSIZE.width, SEARCH_BAR_HEIGHT)];
    searchBar.placeholder = NSLocalizedString(@"Search for wants", nil);
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = viewController;
    searchBar.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_4;
    [searchBar setImage:[UIImage imageNamed:@"magnifying_glass_icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"cross_icon.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    viewController.navigationItem.titleView = searchBar;
    
    UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = MAIN_BLUE_COLOR;
    txfSearchField.textColor = [UIColor whiteColor];
    
    if ([txfSearchField respondsToSelector:@selector(setAttributedPlaceholder:)])
    {
        txfSearchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search for wants", nil) attributes:@{NSForegroundColorAttributeName: GRAY_COLOR_WITH_WHITE_COLOR_4, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE]}];
    }
    
    return searchBar;
}


#pragma mark - SortAndFilter bar

//-----------------------------------------------------------------------------------------------------------------------------
+ (UIView *) addSortAndFilterBarWithHeight: (CGFloat) height toViewController: (UIViewController *) viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *sortAndFilterBar = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_AND_NAV_BAR_HEIGHT, WINSIZE.width, height)];
    sortAndFilterBar.backgroundColor = [UIColor whiteColor];
    [viewController.view addSubview:sortAndFilterBar];
    
    [MarketplaceUIHelper addHorizontalLineToSortAndFilterBar:sortAndFilterBar];
    
    return sortAndFilterBar;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) addHorizontalLineToSortAndFilterBar: (UIView *) sortAndFilterBar
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, sortAndFilterBar.frame.size.height - 0.5f, WINSIZE.width, 0.5f)];
    horizontalLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    [sortAndFilterBar addSubview:horizontalLine];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (UILabel *) addBuyerLocationFilterToSortAndFilterBar:(UIView *)sortAndFilterBar
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [MarketplaceUIHelper addContainerWithTag:0 toSortAndFilterBar:sortAndFilterBar];
    
    [MarketplaceUIHelper addIconImageViewToContainer:container withTag:0];
    [MarketplaceUIHelper addTitleLabelToContainer:container withTag:0];
    UILabel *label = [MarketplaceUIHelper addCurCriterionLabelToContainer:container withTag:0];
    [MarketplaceUIHelper addDownIconArrowToContainer:container withTag:0];
    [MarketplaceUIHelper addVerticalLineToContainer:container];
    
    return label;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (UILabel *) addCategoryFilterToSortAndFilterBar:(UIView *)sortAndFilterBar
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [MarketplaceUIHelper addContainerWithTag:1 toSortAndFilterBar:sortAndFilterBar];
    
    [MarketplaceUIHelper addIconImageViewToContainer:container withTag:1];
    [MarketplaceUIHelper addTitleLabelToContainer:container withTag:1];
    UILabel *label = [MarketplaceUIHelper addCurCriterionLabelToContainer:container withTag:1];
    [MarketplaceUIHelper addDownIconArrowToContainer:container withTag:1];
    [MarketplaceUIHelper addVerticalLineToContainer:container];
    
    return label;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (UILabel *) addSortAndFilterOptionToSortAndFilterBar:(UIView *)sortAndFilterBar
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [MarketplaceUIHelper addContainerWithTag:2 toSortAndFilterBar:sortAndFilterBar];
    
    [MarketplaceUIHelper addIconImageViewToContainer:container withTag:2];
    [MarketplaceUIHelper addTitleLabelToContainer:container withTag:2];
    UILabel *label = [MarketplaceUIHelper addCurCriterionLabelToContainer:container withTag:2];
    [MarketplaceUIHelper addDownIconArrowToContainer:container withTag:2];
    [MarketplaceUIHelper addVerticalLineToContainer:container];
    
    return label;
}

/*
 * Add three container views to sortAndFilter bar. First container view is to display information of buyer's location filtering.
 * Second container view is to display information of category filtering. 
 * Last container view is to display information of sorting scheme currently applying for marketplace.
 */

//-----------------------------------------------------------------------------------------------------------------------------
+ (UIView *) addContainerWithTag:(NSInteger)tag toSortAndFilterBar:(UIView *)sortAndFilterBar
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(tag * WINSIZE.width/3.0f, 0, WINSIZE.width/3.0f, sortAndFilterBar.frame.size.height - 0.5f)];
    [sortAndFilterBar addSubview:container];
    
    if (tag == 0)
        container.tag = BUYER_LOCATION_CONTAINER_TAG;
    else if (tag == 1)
        container.tag = CATEGORY_CONTAINER_TAG;
    else if (tag == 2)
        container.tag = SORT_FILTER_CONTAINER_TAG;
    
    return container;
}

/*
 * Add icons for buyer's location, item's category and sorting
 */

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addIconImageViewToContainer: (UIView *) container withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    
    if (tag == 0)
    {
        iconImageView.frame = CGRectMake(8.0f, 8.0f, 15.0f, 15.0f);
        [iconImageView setImage:[UIImage imageNamed:@"buyer_location_icon.png"]];
    }
    else if (tag == 1)
    {
        iconImageView.frame = CGRectMake(8.0f, 8.0f, 15.0f, 15.0f);
        [iconImageView setImage:[UIImage imageNamed:@"category_small_icon.png"]];
    }
    else if (tag == 2)
    {
        iconImageView.frame = CGRectMake(6.0f, 6.0f, 20.0f, 20.0f);
        [iconImageView setImage:[UIImage imageNamed:@"sort_filter_icon.png"]];
    }
    
    [container addSubview:iconImageView];
}

/*
 * Add titles like LOCATION, CATEGORY and SORT/FILTER
 */

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addTitleLabelToContainer: (UIView *) container withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TEXT_COLOR_DARK_GRAY;
    
    if ([Utilities isCurrLanguageTraditionalChinese])
        titleLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:13];
    else
        titleLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:11];
    
    if (tag == 0)
    {
        titleLabel.text = NSLocalizedString(@"LOCATION", nil);
        titleLabel.frame = CGRectMake(26.0f, 7.0f, WINSIZE.width/3.0 - 30.0f, 20.0f);
    }
    else if (tag == 1)
    {
        titleLabel.text = NSLocalizedString(@"CATEGORY", nil);
        titleLabel.frame = CGRectMake(30.0f, 7.0f, WINSIZE.width/3.0 - 36.0f, 20.0f);
    }
    else if (tag == 2)
    {
        titleLabel.text = NSLocalizedString(@"SORT/FILTER", nil);
        titleLabel.frame = CGRectMake(30.0f, 7.0f, WINSIZE.width/3.0 - 38.0f, 20.0f);
    }
    
    [container addSubview:titleLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (UILabel *) addCurCriterionLabelToContainer: (UIView *) container withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *curLabel = [[UILabel alloc] init];
    curLabel.textColor = TEXT_COLOR_DARK_GRAY;
    curLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:13];
    [container addSubview:curLabel];
    
    if (tag == 0)
    {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 35.0f, 20.0f);
        curLabel.text = @"";
    }
    else if (tag == 1)
    {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 20.0f, 20.0f);
        curLabel.text = @"";
    }
    else if (tag == 2)
    {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 26.0f, 20.0f);
        curLabel.text = @"";
    }
    
    return curLabel;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addDownIconArrowToContainer: (UIView *) container withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImageView *downArrowImageView = [[UIImageView alloc] init];
    [downArrowImageView setImage:[UIImage imageNamed:@"down_arrow_icon.png"]];
    
    if (tag == 0)
    {
        downArrowImageView.frame = CGRectMake(WINSIZE.width/3.0 - 16.0f, 32.0f, 8.0f, 8.0f);
    }
    else if (tag == 1)
    {
        downArrowImageView.frame = CGRectMake(WINSIZE.width/3.0 - 16.0f, 32.0f, 8.0f, 8.0f);
    }
    else if (tag == 2)
    {
        downArrowImageView.frame = CGRectMake(WINSIZE.width/3.0 - 16.0f, 32.0f, 8.0f, 8.0f);
    }
    
    [container addSubview:downArrowImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addVerticalLineToContainer: (UIView *) container
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/3.0 - 1.0f, 8.0f, 1.0f, container.frame.size.height - 2 * 8.0f)];
    verticalLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_4;
    [container addSubview:verticalLine];
}


#pragma mark - SortAndFilter Bar Event Handler

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) presentLocationSelectorInViewController:(UIViewController<CityViewDelegate> *)controller currLocation: (NSString *) location
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"FilterByBuyerLocationEvent" label:@"SortAndFilterBar" value:nil];
    
    CityViewController *cityViewController = [[CityViewController alloc] init];
    cityViewController.labelText = NSLocalizedString(@"Filter by buyer's location:", nil);
    cityViewController.viewTitle = NSLocalizedString(@"Location", nil);
    cityViewController.viewControllerIsPresented = YES;
    cityViewController.currentLocation = location;
    cityViewController.usedForFiltering = YES;
    cityViewController.delegate = controller;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    
    [controller.navigationController presentViewController:navController animated:YES completion:nil];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) presentCategorySelectorInViewController:(UIViewController<CategoryTableViewControllerDelegate> *)controller currCategory:(NSString *)category
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"FilterByCategoryEvent" label:@"SortAndFilterBar" value:nil];
    
    CategoryTableViewController *categoryTableView = [[CategoryTableViewController alloc] initWithCategory:category usedForFiltering:YES];
    categoryTableView.delegte = controller;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:categoryTableView];
    
    [controller.navigationController presentViewController:navController animated:YES completion:nil];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) presentSortAndFilterSelectorInViewController:(UIViewController<SortAndFilterTableViewDelegate> *)controller currSortingChoice:(NSString *)sortingChoice currProductOrigin:(NSString *)productOrigin
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"Sort" label:@"SortAndFilterBar" value:nil];
    
    SortAndFilterTableVC *sortAndFilterTableVC = [[SortAndFilterTableVC alloc] init];
    sortAndFilterTableVC.sortingCriterion = sortingChoice;
    sortAndFilterTableVC.productOriginFilter = productOrigin;
    sortAndFilterTableVC.delegate = controller;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sortAndFilterTableVC];
    
    [controller.navigationController presentViewController:navController animated:YES completion:nil];
}


#pragma mark - Collection View

//-----------------------------------------------------------------------------------------------------------------------------
+ (UICollectionView *) addCollectionViewToViewController:(UIViewController<UICollectionViewDelegate, UICollectionViewDataSource> *)viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCollectionViewYPos   =   STATUS_BAR_AND_NAV_BAR_HEIGHT + SORT_FILTER_BAR_HEIGHT;
    CGFloat const kCollectionViewHeight =   WINSIZE.height - kCollectionViewYPos;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *wantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kCollectionViewYPos, WINSIZE.width, kCollectionViewHeight) collectionViewLayout:layout];
    wantCollectionView.dataSource = viewController;
    wantCollectionView.delegate = viewController;
    wantCollectionView.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    wantCollectionView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_TAB_BAR_HEIGHT, 0);
    
    [wantCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    [viewController.view addSubview:wantCollectionView];
    
    return wantCollectionView;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (UIRefreshControl *) addTopRefreshControlToCollectionView:(UICollectionView *)collectionView
//-----------------------------------------------------------------------------------------------------------------------------
{
    UIRefreshControl *topRefreshControl = [UIRefreshControl new];
    topRefreshControl.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    [collectionView addSubview:topRefreshControl];
    
    return topRefreshControl;
}


@end
