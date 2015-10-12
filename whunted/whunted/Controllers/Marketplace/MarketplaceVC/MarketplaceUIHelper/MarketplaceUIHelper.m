//
//  MarketplaceHelper.m
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceUIHelper.h"
#import "MarketplaceLogicHelper.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation MarketplaceUIHelper

#pragma mark - Search bar

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


#pragma mark - SortAndFilter bar

//-----------------------------------------------------------------------------------------------------------------------------
+ (UIView *) addSortAndFilterBarWithHeight: (CGFloat) height toViewController: (UIViewController *) viewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBarYPos      =   [Utilities getHeightOfNavigationAndStatusBars:viewController];
    
    UIView *sortAndFilterBar = [[UIView alloc] initWithFrame:CGRectMake(0, kBarYPos, WINSIZE.width, height)];
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
    horizontalLine.backgroundColor = GRAY_COLOR_LIGHT;
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
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/3.0 - 0.5f, 8.0f, 0.5f, container.frame.size.height - 2 * 8.0f)];
    verticalLine.backgroundColor = GRAY_COLOR_LIGHTER;
    [container addSubview:verticalLine];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addTapGestureRecognizerToView: (UIView *) container withTag: (NSInteger) tag inViewController: (UIViewController *) viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    UITapGestureRecognizer *tapGesture;
    
    if (tag == 0)
    {
        
    }
    else if (tag == 1)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:viewController action:@selector(categoryViewTouchEventHandler)];
    }
    else if (tag == 2)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:viewController action:@selector(sortAndFilterViewTouchEventHandler)];
    }
    
    [container addGestureRecognizer:tapGesture];
}


@end
