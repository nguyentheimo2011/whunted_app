//
//  MarketplaceViewController.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceViewController.h"
#import "UserProfileViewController.h"
#import "TransactionData.h"
#import "MarketplaceUIHelper.h"
#import "MarketplaceLogicHelper.h"
#import "MarketplaceBackend.h"
#import "Utilities.h"
#import "BackendUtil.h"
#import "SearchEngine.h"

#import <MRProgress.h>


//-----------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceViewController ()
//-----------------------------------------------------------------------------------------------------------------------------

@property (atomic)      BOOL    isLoadingMoreWhunts;
@property (atomic)      BOOL    isLoadingWhuntsDetails;

@end


//-----------------------------------------------------------------------------------------------------------------------------
@implementation MarketplaceViewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UICollectionView        *_wantCollectionView;
    
    UIView                  *_sortAndFilterBar;
    UILabel                 *_currBuyerLocationLabel;
    UILabel                 *_currCategoryLabel;
    UILabel                 *_currSortFilterLabel;
    UISearchBar             *_searchBar;
    
    UIRefreshControl        *_topRefreshControl;
    
    NSString                *_currProductOrigin;
    NSString                *_currCategory;
    NSString                *_currSortingChoice;
    NSString                *_currBuyerLocation;

    NSMutableArray          *_retrievedWantDataList;
    
    CGFloat                 _lastContentOffset;
}

@synthesize     isLoadingMoreWhunts     =   _isLoadingMoreWhunts;
@synthesize     isLoadingWhuntsDetails  =   _isLoadingWhuntsDetails;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil)
    {
        [self initData];
        [self initUI];
        [self retrieveWhuntsList];
        [self addNotificationListener];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"MarketplaceScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    [Utilities logOutMessage:@"MarketplaceViewController didReceiveMemoryWarning"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationListener
//------------------------------------------------------------------------------------------------------------------------------
{
    // Update whunts list after a whunt is fulfilled.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFulfilledWhuntFromMarketplace:) name:NOTIFICATION_OFFER_ACCEPTED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whuntDetailsEditedEventHandler:) name:NOTIFICATION_WHUNT_DETAILS_EDITED_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameButtonTapEventHandler:) name:NOTIFICATION_USERNAME_BUTTON_MARKETPLACE_TAP_EVENT object:nil];
}


#pragma mark - Data Initialization

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    BOOL languageChanged = [MarketplaceLogicHelper hasPhoneLanguageChangedRecently];
    _currBuyerLocation = [MarketplaceLogicHelper getBuyerLocationFilter:languageChanged];
    _currCategory = [MarketplaceLogicHelper getCategoryFilter:languageChanged];
    _currSortingChoice = [MarketplaceLogicHelper getSortingChoice:languageChanged];
    _currProductOrigin = [MarketplaceLogicHelper getProductOriginFilter:languageChanged];
}


#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self customizeView];
    [self addSearchBar];
    [self addSortAndFilterBar];
    [self addWantCollectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeView
//-------------------------------------------------------------------------------------------------------------------------------
{

}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSearchBar
//-------------------------------------------------------------------------------------------------------------------------------
{
    _searchBar = [MarketplaceUIHelper addSearchBoxToViewController:self];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSortAndFilterBar
//-------------------------------------------------------------------------------------------------------------------------------
{
    _sortAndFilterBar = [MarketplaceUIHelper addSortAndFilterBarWithHeight:SORT_FILTER_BAR_HEIGHT toViewController:self];
    
    [self addBuyerLocationFilterToSortAndFilterBar];
    [self addCategoryFilterToSortAndFilterBar];
    [self addSortAndFilterOptionToSortAndFilterBar];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerLocationFilterToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    _currBuyerLocationLabel = [MarketplaceUIHelper addBuyerLocationFilterToSortAndFilterBar:_sortAndFilterBar];
    _currBuyerLocationLabel.text = _currBuyerLocation;
    
    UIView *buyerLocationContainer = [Utilities getSubviewOfView:_sortAndFilterBar withTag:BUYER_LOCATION_CONTAINER_TAG];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyerLocationViewTouchEventHandler)];
    [buyerLocationContainer addGestureRecognizer:tapGesture];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addCategoryFilterToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    _currCategoryLabel = [MarketplaceUIHelper addCategoryFilterToSortAndFilterBar:_sortAndFilterBar];
    _currCategoryLabel.text = _currCategory;
    
    UIView *categoryContainer = [Utilities getSubviewOfView:_sortAndFilterBar withTag:CATEGORY_CONTAINER_TAG];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTouchEventHandler)];
    [categoryContainer addGestureRecognizer:tapGesture];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSortAndFilterOptionToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    _currSortFilterLabel = [MarketplaceUIHelper addSortAndFilterOptionToSortAndFilterBar:_sortAndFilterBar];
    _currSortFilterLabel.text = _currSortingChoice;
    
    UIView *sortFilterContainer = [Utilities getSubviewOfView:_sortAndFilterBar withTag:SORT_FILTER_CONTAINER_TAG];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortAndFilterViewTouchEventHandler)];
    [sortFilterContainer addGestureRecognizer:tapGesture];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addWantCollectionView
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantCollectionView = [MarketplaceUIHelper addCollectionViewToViewController:self];
    
    _topRefreshControl = [MarketplaceUIHelper addTopRefreshControlToCollectionView:_wantCollectionView];
    [_topRefreshControl addTarget:self action:@selector(refreshWhuntsList) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - CollectionViewDatasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_retrievedWantDataList count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    MarketplaceCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MarketplaceCollectionViewCell" forIndexPath:indexPath];
    cell.cellIndex = indexPath.row;
    cell.cellIdentifier = CELL_IN_MARKETPLACE;
    
    if (cell.wantData == nil) 
        [cell initCell];
    else
        [cell clearCellUI];
    
    WantData *wantData = [_retrievedWantDataList objectAtIndex:indexPath.row];
    [cell setWantData:wantData];
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    return [Utilities sizeOfFullCollectionCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellMargin   =   SPACE_BETWEEN_CELLS;
    
    return UIEdgeInsetsMake(kCellMargin, kCellMargin, kCellMargin, kCellMargin);
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellMargin   =   SPACE_BETWEEN_CELLS;
    
    return kCellMargin;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return SPACE_BETWEEN_CELLS;
}


#pragma mark - UICollectionViewDelegate methods

/*
 * When user clicks an item on marketplace, details of the item will be presented.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_isLoadingWhuntsDetails)
        return;
    
    _isLoadingWhuntsDetails = YES;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [Utilities showSmallIndeterminateProgressIndicatorInView:cell];
    
    ItemDetailsViewController *itemDetailsVC = [[ItemDetailsViewController alloc] init];
    itemDetailsVC.wantData = [_retrievedWantDataList objectAtIndex:indexPath.row];
    itemDetailsVC.itemImagesNum = itemDetailsVC.wantData.itemPicturesNum;
    
    TransactionHandler tranHandler = ^(TransactionData *offer)
    {
        if (offer)
        {
            itemDetailsVC.currOffer = offer;
        }
        [self.navigationController pushViewController:itemDetailsVC animated:YES];
        [Utilities hideIndeterminateProgressIndicatorInView:cell];
        _isLoadingWhuntsDetails = NO;
    };
    
    [MarketplaceBackend retrieveOfferByUser:[PFUser currentUser].objectId forItem:itemDetailsVC.wantData.itemID completionHandler:tranHandler];
}


#pragma mark - CityViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) cityView:(CityViewController *)controller didSpecifyLocation:(NSString *)location
//------------------------------------------------------------------------------------------------------------------------------
{
    if (location.length > 0)
    {
        _currBuyerLocation = location;
        _currBuyerLocationLabel.text = location;
    }
    else
    {
        _currBuyerLocation = NSLocalizedString(ITEM_BUYER_LOCATION_DEFAULT, nil);
        _currBuyerLocationLabel.text = NSLocalizedString(ITEM_BUYER_LOCATION_DEFAULT, nil);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:location forKey:CURRENT_BUYER_LOCATION_FILTER];
    
    [self retrieveWhuntsList];
}


#pragma mark - CategoryTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryTableView:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
//------------------------------------------------------------------------------------------------------------------------------
{
    _currCategoryLabel.text = category;
    
    _currCategory = category;
    [[NSUserDefaults standardUserDefaults] setObject:category forKey:CURRENT_CATEGORY_FILTER];
    
    [self retrieveWhuntsList];
}


#pragma mark - SortAndFilterTableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) sortAndFilterTableView:(SortAndFilterTableVC *)controller didCompleteChoosingSortingCriterion:(NSString *)criterion andProductOrigin:(NSString *)productOrigin
//------------------------------------------------------------------------------------------------------------------------------
{
    _currSortFilterLabel.text = criterion;
    
    _currSortingChoice = criterion;
    [[NSUserDefaults standardUserDefaults] setObject:criterion forKey:CURRENT_SORTING_BY];
    
    _currProductOrigin = productOrigin;
    [[NSUserDefaults standardUserDefaults] setObject:productOrigin forKey:CURRENT_PRODUCT_ORIGIN_FILTER];
    
    [self retrieveWhuntsList];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) buyerLocationViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [MarketplaceUIHelper presentLocationSelectorInViewController:self currLocation:_currBuyerLocation];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [MarketplaceUIHelper presentCategorySelectorInViewController:self currCategory:_currCategory];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) sortAndFilterViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [MarketplaceUIHelper presentSortAndFilterSelectorInViewController:self currSortingChoice:_currSortingChoice currProductOrigin:_currProductOrigin];
}

/*
 * Update whunt details of the edited whunt in marketplace
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) whuntDetailsEditedEventHandler: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    WantData *editedWhunt = notification.object;
    
    for (int i=0; i<_retrievedWantDataList.count; i++)
    {
        WantData *wantData = [_retrievedWantDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:editedWhunt.itemID])
        {
            [_retrievedWantDataList replaceObjectAtIndex:i withObject:editedWhunt];
            [_wantCollectionView reloadData];
            break;
        }
    }
}

/*
 * When offer is accepted, fulfilled whunt is removed from Marketplace
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) removeFulfilledWhuntFromMarketplace: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *itemID = notification.object;
    
    for (int i=0; i<_retrievedWantDataList.count; i++)
    {
        WantData *wantData = [_retrievedWantDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:itemID])
        {
            [_retrievedWantDataList removeObjectAtIndex:i];
            [_wantCollectionView reloadData];
            break;
        }
    }
}

/*
 * Display user's profile.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *userID = notification.object;
    [BackendUtil presentUserProfileOfUser:userID fromViewController:self];
}


#pragma mark - UISearchBarDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(searchCancelButtonTapEventHandler)];
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
//------------------------------------------------------------------------------------------------------------------------------
{
    [self searchForWhuntsBasedOnKeyword:searchBar.text];
    [self collapseSearchUI];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//------------------------------------------------------------------------------------------------------------------------------
{
    if (searchText.length == 0)
    {
        [self retrieveWhuntsList];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) searchCancelButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self searchForWhuntsBasedOnKeyword:_searchBar.text];
    [self collapseSearchUI];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) collapseSearchUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - UIScrollViewDelegate method

/*
 * Load new whunts when scroll to near the end of the scroll view
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger numOfWhunts = _retrievedWantDataList.count;
    NSInteger numOfRows = numOfWhunts/2;
    float loadingPos = (numOfRows - 3) * ([Utilities sizeOfFullCollectionCell].height + SPACE_BETWEEN_CELLS);
    
    if (_retrievedWantDataList.count >= NUM_OF_WHUNTS_IN_EACH_LOADING_TIME && scrollView.contentOffset.y >= loadingPos)
    {
        if (!_isLoadingMoreWhunts)
        {
            [self retrieveMoreWhunts];
        }
    }
    
    if (_lastContentOffset > scrollView.contentOffset.y) // Scroll up
    {
        if (_topRefreshControl.refreshing)
            [_topRefreshControl endRefreshing];
    }
    
    _lastContentOffset = scrollView.contentOffset.y;
}


#pragma mark - Whunt Data Handler

/*
 * Retrieve whunts that are not yet fulfilled.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveWhuntsList
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFQuery *query = [self queryForLoadingWhunts];
    
    WhuntsHandler succHandler = ^(NSArray *whunts)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        _retrievedWantDataList = [NSMutableArray arrayWithArray:whunts];
        [_wantCollectionView reloadData];
    };
    
    FailureHandler failHandler = ^(NSError *error)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        [Utilities displayErrorAlertView];
    };
    
    [MarketplaceBackend retrieveWhuntsWithQuery:query successHandler:succHandler failureHandler:failHandler];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) refreshWhuntsList
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [self queryForLoadingWhunts];
    
    WhuntsHandler succHandler = ^(NSArray *whunts)
    {
        [_topRefreshControl endRefreshing];
        _retrievedWantDataList = [NSMutableArray arrayWithArray:whunts];
        [_wantCollectionView reloadData];
    };
    
    FailureHandler failHandler = ^(NSError *error)
    {
        [_topRefreshControl endRefreshing];
        [Utilities displayErrorAlertView];
    };
    
    [MarketplaceBackend retrieveWhuntsWithQuery:query successHandler:succHandler failureHandler:failHandler];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveMoreWhunts
//------------------------------------------------------------------------------------------------------------------------------
{
    // Only load more data if the last load-more-data request completed.
    if (!_isLoadingMoreWhunts)
    {
        _isLoadingMoreWhunts = YES;
        
        PFQuery *query = [self queryForLoadingMoreWhunts];
        
        WhuntsHandler succHandler = ^(NSArray *whunts)
        {
            [_retrievedWantDataList addObjectsFromArray:whunts];
            [_wantCollectionView reloadData];
            _isLoadingMoreWhunts = NO;
        };
        
        FailureHandler failHandler = ^(NSError *error)
        {
            _isLoadingMoreWhunts = NO;
            
            [Utilities displayErrorAlertView];
        };
        
        [MarketplaceBackend retrieveWhuntsWithQuery:query successHandler:succHandler failureHandler:failHandler];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) searchForWhuntsBasedOnKeyword: (NSString *) searchKeyword
//------------------------------------------------------------------------------------------------------------------------------
{
    if (searchKeyword.length > 0)
    {
        [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
        
        PFQuery *query = [self queryForLoadingWhunts];
        
        WhuntsHandler succHandler = ^(NSArray *whunts)
        {
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            _retrievedWantDataList = [NSMutableArray arrayWithArray:whunts];
            [_wantCollectionView reloadData];
        };
        
        FailureHandler failHandler = ^(NSError *error)
        {
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            [Utilities displayErrorAlertView];
        };
        
        [MarketplaceBackend retrieveWhuntsWithQuery:query successHandler:succHandler failureHandler:failHandler];
    }
}


#pragma mark - Query helpers

//------------------------------------------------------------------------------------------------------------------------------
- (PFQuery *) queryForLoadingWhunts
//------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableDictionary *requirements = [NSMutableDictionary dictionaryWithObjectsAndKeys:_currBuyerLocation, BUYER_LOCATION_FILTER, _currCategory, ITEM_CATEGORY_FILTER, _currProductOrigin, PRODUCT_ORIGIN_FILTER, _currSortingChoice, SORTING_CHOICE, _searchBar.text, SEARCH_KEYWORD, nil];
    
    PFQuery *query = [MarketplaceBackend createQueryForWhuntsFromDictionary:requirements];
    
    return query;
}

//------------------------------------------------------------------------------------------------------------------------------
- (PFQuery *) queryForLoadingMoreWhunts
//------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableDictionary *requirements = [NSMutableDictionary dictionaryWithObjectsAndKeys:_currBuyerLocation, BUYER_LOCATION_FILTER, _currCategory, ITEM_CATEGORY_FILTER, _currProductOrigin, PRODUCT_ORIGIN_FILTER, _currSortingChoice, SORTING_CHOICE, _searchBar.text, SEARCH_KEYWORD, nil];
    
    if (_retrievedWantDataList.count > 0)
    {
        [requirements setObject:_retrievedWantDataList[_retrievedWantDataList.count-1] forKey:LAST_LOADED_WHUNT];
    }
    
    PFQuery *query = [MarketplaceBackend createQueryForWhuntsFromDictionary:requirements];
    
    return query;
}


@end
