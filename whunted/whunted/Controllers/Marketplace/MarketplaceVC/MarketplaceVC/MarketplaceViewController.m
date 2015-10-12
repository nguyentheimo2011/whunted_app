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
#import "Utilities.h"

#import <MBProgressHUD.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#define     kSortAndFilterBarHeight         50.0f

//-----------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceViewController ()
//-----------------------------------------------------------------------------------------------------------------------------

@property (atomic)      BOOL    isLoadingMoreWhunts;

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
    UIRefreshControl        *_bottomRefreshControl;
    
    NSString                *_currProductOrigin;
    NSString                *_currCategory;
    NSString                *_currSortingBy;
    NSString                *_currBuyerLocation;

    NSMutableArray          *_wantDataList;
    NSArray                 *_sortedAndFilteredWantDataList;
    NSMutableArray          *_displayedWantDataList;
    
    CGFloat                 _lastContentOffset;
}

@synthesize     delegate                =   _delegate;
@synthesize     isLoadingMoreWhunts     =   _isLoadingMoreWhunts;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil)
    {
        [self initData];
        [self retrieveWantDataList];
        [self addNotificationListener];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeView];
    [self initUI];
    [self addSortAndFilterBar];
    [self addWantCollectionView];
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
    _currSortingBy = [MarketplaceLogicHelper getSortingChoice:languageChanged];
    _currProductOrigin = [MarketplaceLogicHelper getProductOriginFilter:languageChanged];
}


#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    _searchBar = [MarketplaceUIHelper addSearchBoxToViewController:self];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeView
//-------------------------------------------------------------------------------------------------------------------------------
{
    // init leftBarButtonItem and rightBarButtonItem to limit the space for title view (search bar) on navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSortAndFilterBar
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBarYPos      =   [Utilities getHeightOfNavigationAndStatusBars:self];
    
    _sortAndFilterBar = [[UIView alloc] initWithFrame:CGRectMake(0, kBarYPos, WINSIZE.width, kSortAndFilterBarHeight)];
    _sortAndFilterBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sortAndFilterBar];
    
    [self addHorizontalLineToSortAndFilterBar];
    [self addBuyerLocationFilterToSortAndFilterBar];
    [self addCategoryFilterToSortAndFilterBar];
    [self addSortAndFilterOptionToSortAndFilterBar];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addWantCollectionView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCollectionViewYPos   =   [Utilities getHeightOfNavigationAndStatusBars:self] + kSortAndFilterBarHeight;
    CGFloat const kCollectionViewHeight =   WINSIZE.height - kCollectionViewYPos - [Utilities getHeightOfBottomTabBar:self];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _wantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kCollectionViewYPos, WINSIZE.width, kCollectionViewHeight) collectionViewLayout:layout];
    _wantCollectionView.dataSource = self;
    _wantCollectionView.delegate = self;
    _wantCollectionView.backgroundColor = LIGHTEST_GRAY_COLOR;
    
    [_wantCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    [self.view addSubview:_wantCollectionView];
    
    _topRefreshControl = [[UIRefreshControl alloc] init];
    _topRefreshControl.backgroundColor = BACKGROUND_GRAY_COLOR;
    [_topRefreshControl addTarget:self action:@selector(refreshWantData)
             forControlEvents:UIControlEventValueChanged];
    [_wantCollectionView addSubview:_topRefreshControl];
    
    _bottomRefreshControl = [UIRefreshControl new];
    _bottomRefreshControl.triggerVerticalOffset = 100;
    [_bottomRefreshControl addTarget:self action:@selector(retrieveMoreWantData) forControlEvents:UIControlEventValueChanged];
    _wantCollectionView.bottomRefreshControl = _bottomRefreshControl;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addHorizontalLineToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, kSortAndFilterBarHeight - 0.5f, WINSIZE.width, 0.5f)];
    horizontalLine.backgroundColor = GRAY_COLOR_LIGHT;
    [_sortAndFilterBar addSubview:horizontalLine];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerLocationFilterToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [self createContainerView:0];
    
    [self addIconImageViewToContainer:container withTag:0];
    [self addTitleLabelToContainer:container withTag:0];
    [self addCurCriterionLabelToContainer:container withTag:0];
    [self addDownIconArrowToContainer:container withTag:0];
    [self addVerticalLineToContainer:container];
    [self addTapGestureRecognizerToView:container withTag:0];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addCategoryFilterToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [self createContainerView:1];
    
    [self addIconImageViewToContainer:container withTag:1];
    [self addTitleLabelToContainer:container withTag:1];
    [self addCurCriterionLabelToContainer:container withTag:1];
    [self addDownIconArrowToContainer:container withTag:1];
    [self addVerticalLineToContainer:container];
    [self addTapGestureRecognizerToView:container withTag:1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSortAndFilterOptionToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [self createContainerView:2];
    
    [self addIconImageViewToContainer:container withTag:2];
    [self addTitleLabelToContainer:container withTag:2];
    [self addCurCriterionLabelToContainer:container withTag:2];
    [self addDownIconArrowToContainer:container withTag:2];
    [self addTapGestureRecognizerToView:container withTag:2];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIView *) createContainerView: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(tag * WINSIZE.width/3.0f, 0, WINSIZE.width/3.0f, kSortAndFilterBarHeight - 0.5f)];
    [_sortAndFilterBar addSubview:container];
    
    return container;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addIconImageViewToContainer: (UIView *) container withTag: (NSInteger) tag
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTitleLabelToContainer: (UIView *) container withTag: (NSInteger) tag
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
- (void) addCurCriterionLabelToContainer: (UIView *) container withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *curLabel = [[UILabel alloc] init];
    curLabel.textColor = TEXT_COLOR_DARK_GRAY;
    curLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:13];
    [container addSubview:curLabel];
    
    if (tag == 0)
    {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 35.0f, 20.0f);
        curLabel.text = _currBuyerLocation;
        _currBuyerLocationLabel = curLabel;
    }
    else if (tag == 1)
    {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 20.0f, 20.0f);
        curLabel.text = _currCategory;
        _currCategoryLabel = curLabel;
    }
    else if (tag == 2)
    {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 26.0f, 20.0f);
        curLabel.text = _currSortingBy;
        _currSortFilterLabel = curLabel;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDownIconArrowToContainer: (UIView *) container withTag: (NSInteger) tag
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
- (void) addVerticalLineToContainer: (UIView *) container
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/3.0 - 0.5f, 8.0f, 0.5f, kSortAndFilterBarHeight - 2 * 8.0f)];
    verticalLine.backgroundColor = GRAY_COLOR_LIGHTER;
    [container addSubview:verticalLine];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTapGestureRecognizerToView: (UIView *) container withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UITapGestureRecognizer *tapGesture;
    
    if (tag == 0)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyerLocationViewTouchEventHandler)];
    }
    else if (tag == 1)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTouchEventHandler)];
    }
    else if (tag == 2)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortAndFilterViewTouchEventHandler)];
    }
    
    [container addGestureRecognizer:tapGesture];
}


#pragma mark - CollectionViewDatasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_displayedWantDataList count];
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
    
    WantData *wantData = [_displayedWantDataList objectAtIndex:indexPath.row];
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
    CGFloat const kCellMargin   =   8.0f;
    
    return UIEdgeInsetsMake(kCellMargin, kCellMargin, kCellMargin, kCellMargin);
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellMargin   =   8.0f;
    
    return kCellMargin;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 8.0f;
}


#pragma mark - UICollectionViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ItemDetailsViewController *itemDetailsVC = [[ItemDetailsViewController alloc] init];
    itemDetailsVC.wantData = [_displayedWantDataList objectAtIndex:indexPath.row];
    itemDetailsVC.delegate = self;
    
    itemDetailsVC.itemImagesNum = itemDetailsVC.wantData.itemPicturesNum;
    
    PFQuery *sQuery = [PFQuery queryWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [sQuery whereKey:@"sellerID" equalTo:[PFUser currentUser].objectId];
    [sQuery whereKey:@"itemID" equalTo:itemDetailsVC.wantData.itemID];
    
    [sQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            if (objects.count > 0)
            {
                itemDetailsVC.currOffer = [[TransactionData alloc] initWithPFObject:[objects objectAtIndex:0]];
            }
        }
        else
        {
            [Utilities handleError:error];
        }
        
        [self.navigationController pushViewController:itemDetailsVC animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) buyerLocationViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"FilterByBuyerLocationEvent" label:@"SortAndFilterBar" value:nil];
    
    CityViewController *cityViewController = [[CityViewController alloc] init];
    cityViewController.labelText = NSLocalizedString(@"Filter by buyer's location:", nil);
    cityViewController.viewTitle = NSLocalizedString(@"Location", nil);
    cityViewController.viewControllerIsPresented = YES;
    cityViewController.currentLocation = _currBuyerLocation;
    cityViewController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"FilterByCategoryEvent" label:@"SortAndFilterBar" value:nil];
    
    CategoryTableViewController *categoryTableView = [[CategoryTableViewController alloc] initWithCategory:_currCategoryLabel.text usedForFiltering:YES];
    categoryTableView.delegte = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:categoryTableView];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) sortAndFilterViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"Sort" label:@"SortAndFilterBar" value:nil];
    
    SortAndFilterTableVC *sortAndFilterTableVC = [[SortAndFilterTableVC alloc] init];
    sortAndFilterTableVC.sortingCriterion = _currSortFilterLabel.text;
    sortAndFilterTableVC.productOriginFilter = _currProductOrigin;
    sortAndFilterTableVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sortAndFilterTableVC];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

/*
 * Update whunt details of the edited whunt in marketplace
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) whuntDetailsEditedEventHandler: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    WantData *editedWhunt = notification.object;
    
    for (int i=0; i<_wantDataList.count; i++)
    {
        WantData *wantData = [_wantDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:editedWhunt.itemID])
        {
            [_wantDataList replaceObjectAtIndex:i withObject:editedWhunt];
            [self updateMatchedWantData];
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
    
    for (int i=0; i<_wantDataList.count; i++)
    {
        WantData *wantData = [_wantDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:itemID])
        {
            [_wantDataList removeObjectAtIndex:i];
            [self updateMatchedWantData];
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
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewUserProfileEvent" label:@"BuyerUsernameButton" value:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserHandler handler = ^(PFUser *user)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    NSString *userID = notification.object;
    [Utilities retrieveUserInfoByUserID:userID andRunBlock:handler];
}


#pragma mark - ItemDetailsViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) itemDetailsViewController:(ItemDetailsViewController *)controller didCompleteOffer:(BOOL)completed
//------------------------------------------------------------------------------------------------------------------------------
{
    if (completed) {
        [_delegate marketPlaceUserDidOfferForAnItem];
    }
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
    
    [self updateMatchedWantData];
}


#pragma mark - CategoryTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryTableView:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
//------------------------------------------------------------------------------------------------------------------------------
{
    _currCategoryLabel.text = category;
    
    _currCategory = category;
    [[NSUserDefaults standardUserDefaults] setObject:category forKey:CURRENT_CATEGORY_FILTER];
    
    [self updateMatchedWantData];
}


#pragma mark - SortAndFilterTableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) sortAndFilterTableView:(SortAndFilterTableVC *)controller didCompleteChoosingSortingCriterion:(NSString *)criterion andProductOrigin:(NSString *)productOrigin
//------------------------------------------------------------------------------------------------------------------------------
{
    _currSortFilterLabel.text = criterion;
    
    _currSortingBy = criterion;
    [[NSUserDefaults standardUserDefaults] setObject:criterion forKey:CURRENT_SORTING_BY];
    
    _currProductOrigin = productOrigin;
    [[NSUserDefaults standardUserDefaults] setObject:productOrigin forKey:CURRENT_PRODUCT_ORIGIN_FILTER];
    
    [self retrieveWantDataList];
}


#pragma mark - Overridden methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) pushViewController:(UIViewController *)controller
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Backend Handler

/*
 * Retrieve whunts that are not yet fulfilled.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveWantDataList
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantDataList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_ITEM_IS_FULFILLED equalTo:STRING_OF_NO];
    [self setSortingBy:query];
    [query setLimit:NUM_OF_WHUNTS_IN_EACH_LOADING_TIME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            for (PFObject *object in objects)
            {
                WantData *wantData = [[WantData alloc] initWithPFObject:object];
                [_wantDataList addObject:wantData];
            }
            
            [self updateMatchedWantData];
        }
        else
        {
            // Log details of the failure
            [Utilities handleError:error];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) refreshWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantDataList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_ITEM_IS_FULFILLED equalTo:STRING_OF_NO];
    [self setSortingBy:query];
    [query setLimit:NUM_OF_WHUNTS_IN_EACH_LOADING_TIME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             for (PFObject *object in objects)
             {
                 WantData *wantData = [[WantData alloc] initWithPFObject:object];
                 [_wantDataList addObject:wantData];
             }
             
             [self updateMatchedWantData];
         }
         else
         {
             // Log details of the failure
             [Utilities handleError:error];
         }
         
         [_topRefreshControl endRefreshing];
     }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveMoreWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    // Only load more data if the last load-more-data request completed.
    if (!_isLoadingMoreWhunts)
    {
        _isLoadingMoreWhunts = YES;
        
        PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
        [query whereKey:PF_ITEM_IS_FULFILLED equalTo:STRING_OF_NO];
        
        if (_wantDataList.count > 0)
        {
            WantData *wantData = [_wantDataList objectAtIndex:_wantDataList.count-1];
            [self setConditionsForQuery:query lastWantData:wantData];
            [query whereKey:PF_OBJECT_ID notEqualTo:wantData.itemID];
        }
        
        [self setSortingBy:query];
        [query setLimit:NUM_OF_WHUNTS_IN_EACH_LOADING_TIME];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (!error)
             {
                 for (PFObject *object in objects)
                 {
                     WantData *wantData = [[WantData alloc] initWithPFObject:object];
                     [_wantDataList addObject:wantData];
                 }
                 
                 [self updateMatchedWantData];
             }
             else
             {
                 [Utilities handleError:error];
             }
             
             [_bottomRefreshControl endRefreshing];
             _isLoadingMoreWhunts = NO;
         }];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) sortArray: (NSArray *) array by: (NSString *) sortingBy
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *sortedArray;
    
    if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_POPULAR, nil)])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnPopular:)];
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_RECENT, nil)])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnRecent:)];
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil)])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnAscendingPrice:)];
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil)])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnDescendingPrice:)];
    else
        sortedArray = array;
    
    return sortedArray;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) filterArray: (NSArray *) array byCategory: (NSString *) category
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_ALL, nil)])
        return array;
    else
    {
        NSMutableArray *filteredArray = [NSMutableArray array];
        
        for (WantData *wantData in array)
        {
            NSString *synonym = [Utilities getSynonymOfWord:category];
            
            // Filter by both chinese and english
            if ([wantData.itemCategory isEqualToString:category] || [wantData.itemCategory isEqualToString:synonym])
                [filteredArray addObject:wantData];
        }
        
        return filteredArray;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) filterArray: (NSArray *) array byProductOrigin: (NSString *) productOrigin
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([productOrigin isEqualToString:NSLocalizedString(ITEM_PRODUCT_ORIGIN_ALL, nil)])
        return array;
    else
    {
        NSMutableArray *filteredArray = [NSMutableArray array];
        
        for (WantData *wantData in array)
        {
            if ([wantData.itemOrigins containsObject:productOrigin] || [wantData.itemOrigins containsObject:NSLocalizedString(productOrigin, nil)])
            {
                [filteredArray addObject:wantData];
            }
        }
        
        return filteredArray;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) filterArray: (NSArray *) array byBuyerLocation: (NSString *) buyerLocation
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([buyerLocation isEqualToString:NSLocalizedString(ITEM_BUYER_LOCATION_DEFAULT, nil)])
        return array;
    else
    {
        NSMutableArray *filteredArray = [NSMutableArray array];
        
        for (WantData *wantData in array)
        {
            if ([wantData.meetingLocation isEqualToString:buyerLocation])
            {
                [filteredArray addObject:wantData];
            }
        }
        
        return filteredArray;
    }
}


#pragma mark - Helpers

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateMatchedWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    _sortedAndFilteredWantDataList = [self filterArray:_wantDataList byCategory:_currCategory];
    _sortedAndFilteredWantDataList = [self filterArray:_sortedAndFilteredWantDataList byProductOrigin:_currProductOrigin];
    _sortedAndFilteredWantDataList = [self filterArray:_sortedAndFilteredWantDataList byBuyerLocation:_currBuyerLocation];
    _sortedAndFilteredWantDataList = [self sortArray:_sortedAndFilteredWantDataList by:_currSortingBy];
    _displayedWantDataList = [NSMutableArray arrayWithArray:_sortedAndFilteredWantDataList];
    
    [_wantCollectionView reloadData];
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) isOfOneOfCorrectSortingSchemes: (NSString *) sortingBy
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_POPULAR, nil)])
        return YES;
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_RECENT, nil)])
        return YES;
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil)])
        return YES;
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil)])
        return YES;
    else if ([sortingBy isEqualToString:NSLocalizedString(SORTING_BY_NEAREST, nil)])
        return YES;
    else
        return NO;
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) isOfOneOfCorrectCategories: (NSString *) category
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_ALL, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_BEAUTY_PRODUCTS, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_BOOKS_AND_MAGAZINES, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_BORROWING, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_CUSTOMIZATION, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_FUNITURE, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_GAMES_AND_TOYS, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_LUXURY_BRANDED, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_OTHERS, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_PROFESSIONAL_SERVICES, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_SPORT_EQUIPMENTS, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_TICKETS_AND_VOUCHERS, nil)])
        return YES;
    else if ([category isEqualToString:NSLocalizedString(ITEM_CATEGORY_WATCHES, nil)])
        return YES;
    else
        return NO;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) isOfOneOfCorrectLocation: (NSString *) location
//------------------------------------------------------------------------------------------------------------------------------
{
    
        
}


#pragma mark - UISearchBarDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
//------------------------------------------------------------------------------------------------------------------------------
{
    [self searchWantDataBasedOnTerm:searchBar.text];
    
    [self completeSearch];    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) searchWantDataBasedOnTerm: (NSString *) searchTerm
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantDataList = [[NSMutableArray alloc] init];
    
    PFQuery *query1 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query1 whereKey:PF_ITEM_IS_FULFILLED equalTo:STRING_OF_NO];
    [query1 whereKey:PF_ITEM_NAME containsString:searchTerm];
    
    PFQuery *query2 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query2 whereKey:PF_ITEM_IS_FULFILLED equalTo:STRING_OF_NO];
    [query2 whereKey:PF_ITEM_DESC containsString:searchTerm];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             for (PFObject *object in objects)
             {
                 WantData *wantData = [[WantData alloc] initWithPFObject:object];
                 [_wantDataList addObject:wantData];
             }
             
             [self updateMatchedWantData];
         }
         else
         {
             // Log details of the failure
             [Utilities handleError:error];
         }
     }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelSearch
//------------------------------------------------------------------------------------------------------------------------------
{
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) completeSearch
//------------------------------------------------------------------------------------------------------------------------------
{
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


#pragma mark - UIScrollViewDelegate method

//------------------------------------------------------------------------------------------------------------------------------
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_lastContentOffset > scrollView.contentOffset.y) // Scroll up
    {
        if (_topRefreshControl.refreshing)
            [_topRefreshControl endRefreshing];
    }
    else if (_lastContentOffset < scrollView.contentOffset.y) // Scroll down
    {
        if (_bottomRefreshControl.refreshing)
            [_bottomRefreshControl endRefreshing];
    }
    
    _lastContentOffset = scrollView.contentOffset.y;
}


#pragma mark - Helper functions

//------------------------------------------------------------------------------------------------------------------------------
- (void) setSortingBy: (PFQuery *) query
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_currSortingBy isEqualToString:NSLocalizedString(SORTING_BY_RECENT, nil)])
    {
        [query orderByDescending:PF_CREATED_AT];
    }
    else if ([_currSortingBy isEqualToString:NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil)])
    {
        [query orderByAscending:PF_ITEM_DEMANDED_PRICE];
    }
    else if ([_currSortingBy isEqualToString:NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil)])
    {
        [query orderByDescending:PF_ITEM_DEMANDED_PRICE];
    }
    else
    {
        [query orderByDescending:PF_CREATED_AT];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setConditionsForQuery: (PFQuery *) query lastWantData: (WantData *) wantData
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_currSortingBy isEqualToString:NSLocalizedString(SORTING_BY_RECENT, nil)])
    {
        [query whereKey:PF_CREATED_AT lessThan:wantData.createdDate];
    }
    else if ([_currSortingBy isEqualToString:NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil)])
    {
        [query whereKey:PF_ITEM_DEMANDED_PRICE greaterThanOrEqualTo:[Utilities numberFromFormattedPrice:wantData.demandedPrice]];
    }
    else if ([_currSortingBy isEqualToString:NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil)])
    {
        [query whereKey:PF_ITEM_DEMANDED_PRICE lessThanOrEqualTo:[Utilities numberFromFormattedPrice:wantData.demandedPrice]];
    }
    else
    {
        [query whereKey:PF_CREATED_AT lessThan:wantData.createdDate];
    }
}

@end
