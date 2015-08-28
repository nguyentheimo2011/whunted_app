//
//  MarketplaceViewController.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceViewController.h"
#import "SellerListViewController.h"
#import "OfferData.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "SyncEngine.h"

#import "MBProgressHUD.h"

#define     kSortAndFilterBarHeight     50.0f


@implementation MarketplaceViewController
{
    UICollectionView        *_wantCollectionView;
    
    UIView                  *_sortAndFilterBar;
    UILabel                 *_currProductOriginLabel;
    UILabel                 *_currCategoryLabel;
    UILabel                 *_currSortFilterLabel;
    
    NSString                *_currSortingBy;

    NSMutableArray          *_wantDataList;
    NSArray                 *_sortedAndFilteredWantDataList;
}

@synthesize delegate        =   _delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        [self initData];
        [self retrieveWantDataList];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeView];
    [self addSortAndFilterBar];
    [self addWantCollectionView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"MarketplaceViewController didReceiveMemoryWarning");
}


#pragma mark - Data Initialization

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _currSortingBy = [[NSUserDefaults standardUserDefaults] objectForKey:SORTING_BY];
    
    if (_currSortingBy.length == 0 || ![self isOfOneOfCorrectSortingSchemes:_currSortingBy])
        _currSortingBy = NSLocalizedString(SORTING_BY_RECENT, nil);
}


#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeView
//-------------------------------------------------------------------------------------------------------------------------------
{
    
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
    [self addProductOriginFilterToSortAndFilterBar];
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
- (void) addProductOriginFilterToSortAndFilterBar
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
    
    if (tag == 0) {
        iconImageView.frame = CGRectMake(8.0f, 8.0f, 15.0f, 15.0f);
        [iconImageView setImage:[UIImage imageNamed:@"product_origin_small_icon.png"]];
    } else if (tag == 1) {
        iconImageView.frame = CGRectMake(8.0f, 8.0f, 15.0f, 15.0f);
        [iconImageView setImage:[UIImage imageNamed:@"category_small_icon.png"]];
    } else if (tag == 2) {
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
    
    if (tag == 0) {
        titleLabel.text = NSLocalizedString(@"ORIGIN", nil);
        titleLabel.frame = CGRectMake(24.0f, 7.0f, WINSIZE.width/3.0 - 30.0f, 20.0f);
    } else if (tag == 1) {
        titleLabel.text = NSLocalizedString(@"CATEGORY", nil);
        titleLabel.frame = CGRectMake(30.0f, 7.0f, WINSIZE.width/3.0 - 36.0f, 20.0f);
    } else if (tag == 2) {
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
    
    if (tag == 0) {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 35.0f, 20.0f);
        curLabel.text = NSLocalizedString(@"Taiwan", nil);;
        _currProductOriginLabel = curLabel;
    } else if (tag == 1) {
        curLabel.frame = CGRectMake(9.0f, 25.0f, WINSIZE.width/3.0 - 20.0f, 20.0f);
        curLabel.text = NSLocalizedString(@"All", nil);
        _currCategoryLabel = curLabel;
    } else if (tag == 2) {
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
    
    if (tag == 0) {
        downArrowImageView.frame = CGRectMake(WINSIZE.width/3.0 - 16.0f, 32.0f, 8.0f, 8.0f);
    } else if (tag == 1) {
        downArrowImageView.frame = CGRectMake(WINSIZE.width/3.0 - 16.0f, 32.0f, 8.0f, 8.0f);
    } else if (tag == 2) {
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
    
    if (tag == 0) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productOriginViewTouchEventHandler)];
    } else if (tag == 1) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTouchEventHandler)];
    } else if (tag == 2) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortAndFilterViewTouchEventHandler)];
    }
    
    [container addGestureRecognizer:tapGesture];
}


#pragma mark - CollectionViewDatasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_sortedAndFilteredWantDataList count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    MarketplaceCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MarketplaceCollectionViewCell" forIndexPath:indexPath];
    
    if (cell.wantData == nil) 
        [cell initCell];
    else
        [cell clearCellUI];
    
    WantData *wantData = [_sortedAndFilteredWantDataList objectAtIndex:indexPath.row];
    [cell setWantData:wantData];
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellWidth    =   WINSIZE.width/2 - 12.0f;
    CGFloat const kCellHeight   =   kCellWidth + 115.0f;
    
    return CGSizeMake(kCellWidth, kCellHeight);
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


#pragma mark - UICollectionView delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ItemDetailsViewController *itemDetailsVC = [[ItemDetailsViewController alloc] init];
    itemDetailsVC.wantData = [_wantDataList objectAtIndex:indexPath.row];
    itemDetailsVC.delegate = self;
    
    itemDetailsVC.itemImagesNum = itemDetailsVC.wantData.itemPicturesNum;
    
    PFQuery *sQuery = [PFQuery queryWithClassName:PF_OFFER_CLASS];
    [sQuery whereKey:@"sellerID" equalTo:[PFUser currentUser].objectId];
    [sQuery whereKey:@"itemID" equalTo:itemDetailsVC.wantData.itemID];
    
//    if (![SyncEngine sharedEngine].syncInProgess)
//        [sQuery fromPinWithName:PF_OFFER_CLASS];
    
    [sQuery getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError *error) {
        if (!error) {
            if (object) {
                itemDetailsVC.currOffer = [[OfferData alloc] initWithPFObject:object];
            }
        } else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        [self.navigationController pushViewController:itemDetailsVC animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) productOriginViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    CountryTableViewController *countryTableView = [[CountryTableViewController alloc] initWithSelectedCountries:nil usedForFiltering:YES];
    countryTableView.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:countryTableView];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    CategoryTableViewController *categoryTableView = [[CategoryTableViewController alloc] initWithCategory:_currCategoryLabel.text usedForFiltering:YES];
    categoryTableView.delegte = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:categoryTableView];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) sortAndFilterViewTouchEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    SortAndFilterTableVC *sortAndFilterTableVC = [[SortAndFilterTableVC alloc] init];
    sortAndFilterTableVC.sortingCriterion = _currSortFilterLabel.text;
    sortAndFilterTableVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sortAndFilterTableVC];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
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


#pragma mark - CountryTableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) countryTableView:(CountryTableViewController *)controller didCompleteChoosingACountry:(NSString *)country
//------------------------------------------------------------------------------------------------------------------------------
{
    _currProductOriginLabel.text = NSLocalizedString(country, nil);
}


#pragma mark - CategoryTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryTableView:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
//------------------------------------------------------------------------------------------------------------------------------
{
    _currCategoryLabel.text = NSLocalizedString(category, nil);
}


#pragma mark - SortAndFilterTableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) sortAndFilterTableView:(SortAndFilterTableVC *)controller didCompleteChoosingSortingCriterion:(NSString *)criterion
//------------------------------------------------------------------------------------------------------------------------------
{
    _currSortFilterLabel.text = criterion;
    
    _currSortingBy = criterion;
    [[NSUserDefaults standardUserDefaults] setObject:criterion forKey:SORTING_BY];
    
    _sortedAndFilteredWantDataList = [self sortArray:_wantDataList by:_currSortingBy];
    [_wantCollectionView reloadData];
}


#pragma mark - Overridden methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) pushViewController:(UIViewController *)controller
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Backend Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveWantDataList
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantDataList = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
    [query orderByDescending:PF_CREATED_AT];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                WantData *wantData = [[WantData alloc] initWithPFObject:object];
                [_wantDataList addObject:wantData];
            }
            _sortedAndFilteredWantDataList = [self sortArray:_wantDataList by:_currSortingBy];
            [_wantCollectionView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateWantDataTable
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
    [query orderByDescending:PF_CREATED_AT];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        if (!error) {
            WantData *wantData = [[WantData alloc] initWithPFObject:obj];
            [_wantDataList insertObject:wantData atIndex:0];
            [_wantCollectionView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) sortArray: (NSArray *) array by: (NSString *) sortingBy
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *sortedArray;
    
    if ([sortingBy isEqualToString:SORTING_BY_POPULAR])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnPopular:)];
    else if ([sortingBy isEqualToString:SORTING_BY_RECENT])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnRecent:)];
    else if ([sortingBy isEqualToString:SORTING_BY_LOWEST_PRICE])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnAscendingPrice:)];
    else if ([sortingBy isEqualToString:SORTING_BY_HIGHEST_PRICE])
        sortedArray = [array sortedArrayUsingSelector:@selector(compareBasedOnDescendingPrice:)];
    else
        sortedArray = array;
    
    return sortedArray;
}


#pragma mark - Event Handlers

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

@end
