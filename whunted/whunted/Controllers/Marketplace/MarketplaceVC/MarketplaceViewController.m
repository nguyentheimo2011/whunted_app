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
}

@synthesize wantDataList    =   _wantDataList;
@synthesize delegate        =   _delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
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
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/3.0f, kSortAndFilterBarHeight - 0.5f)];
    [_sortAndFilterBar addSubview:container];
    
    // add icon
    CGFloat const kLeftMargin       =   6.0f;
    CGFloat const kTopMargin        =   8.0f;
    CGFloat const kIconWidth        =   15.0f;
    CGFloat const kIconHeight       =   15.0f;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, kIconWidth, kIconHeight)];
    [iconImageView setImage:[UIImage imageNamed:@"product_origin_small_icon.png"]];
    [container addSubview:iconImageView];
    
    // add labels
    CGFloat const kProductOriginLabelXPos   =   1.5 * kLeftMargin + kIconWidth;
    CGFloat const kProductOriginLabelWidth  =   WINSIZE.width - kProductOriginLabelXPos - kLeftMargin;
    CGFloat const kProductOriginLabelHeight =   20.0f;
    
    UILabel *productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProductOriginLabelXPos, kTopMargin, kProductOriginLabelWidth, kProductOriginLabelHeight)];
    productOriginLabel.text = NSLocalizedString(@"PRODUCT ORIGIN", nil);
    productOriginLabel.textColor = TEXT_COLOR_DARK_GRAY;
    productOriginLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:11];
    [container addSubview:productOriginLabel];
    
    CGFloat const kCurrLabelXPos    =   kProductOriginLabelXPos;
    CGFloat const kCurrLabelYPos    =   1.2 * kTopMargin + kIconHeight;
    CGFloat const kCurrLabelWidth   =   WINSIZE.width/3.0 - kCurrLabelXPos - kLeftMargin;
    CGFloat const kCurrLabelHeight  =   20.0f;
    
    _currProductOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrLabelXPos, kCurrLabelYPos, kCurrLabelWidth, kCurrLabelHeight)];
    _currProductOriginLabel.text = NSLocalizedString(@"Taiwan", nil);
    _currProductOriginLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _currProductOriginLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:13];
    [container addSubview:_currProductOriginLabel];
    
    // add down arrow icon
    CGFloat const kImageViewWidth   =   8.0f;
    CGFloat const kImageViewHeight  =   8.0f;
    CGFloat const kImageViewXPos    =   WINSIZE.width/3.0 - kImageViewWidth - kLeftMargin;
    CGFloat const kImageViewYPos    =   kCurrLabelYPos + 7.0f;
    UIImageView *downArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewXPos, kImageViewYPos, kImageViewWidth, kImageViewHeight)];
    [downArrowImageView setImage:[UIImage imageNamed:@"down_arrow_icon.png"]];
    [container addSubview:downArrowImageView];
    
    // add vertical line
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/3.0 - 0.5f, kTopMargin, 0.5f, kSortAndFilterBarHeight - 2 * kTopMargin)];
    verticalLine.backgroundColor = GRAY_COLOR_LIGHTER;
    [container addSubview:verticalLine];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addCategoryFilterToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/3.0f, 0, WINSIZE.width/3.0f, kSortAndFilterBarHeight - 0.5f)];
    [_sortAndFilterBar addSubview:container];
    
    // add icon
    CGFloat const kLeftMargin       =   8.0f;
    CGFloat const kTopMargin        =   8.0f;
    CGFloat const kIconWidth        =   15.0f;
    CGFloat const kIconHeight       =   15.0f;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, kIconWidth, kIconHeight)];
    [iconImageView setImage:[UIImage imageNamed:@"category_small_icon.png"]];
    [container addSubview:iconImageView];
    
    CGFloat const kCategoryLabelXPos   =   2 * kLeftMargin + kIconWidth;
    CGFloat const kCategoryLabelWidth  =   WINSIZE.width - kCategoryLabelXPos - kLeftMargin;
    CGFloat const kCategoryLabelHeight =   20.0f;
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCategoryLabelXPos, kTopMargin, kCategoryLabelWidth, kCategoryLabelHeight)];
    categoryLabel.text = NSLocalizedString(@"CATEGORY", nil);
    categoryLabel.textColor = TEXT_COLOR_DARK_GRAY;
    categoryLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:11];
    [container addSubview:categoryLabel];
    
    CGFloat const kCurrLabelXPos    =   kLeftMargin;
    CGFloat const kCurrLabelYPos    =   1.2 * kTopMargin + kIconHeight;
    CGFloat const kCurrLabelWidth   =   WINSIZE.width/3.0 - kCurrLabelXPos - kLeftMargin;
    CGFloat const kCurrLabelHeight  =   20.0f;
    
    _currCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrLabelXPos, kCurrLabelYPos, kCurrLabelWidth, kCurrLabelHeight)];
    _currCategoryLabel.text = NSLocalizedString(@"Luxury branded", nil);
    _currCategoryLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _currCategoryLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:13];
    [container addSubview:_currCategoryLabel];
    
    // add down arrow icon
    CGFloat const kImageViewWidth   =   8.0f;
    CGFloat const kImageViewHeight  =   8.0f;
    CGFloat const kImageViewXPos    =   WINSIZE.width/3.0 - kImageViewWidth - kLeftMargin;
    CGFloat const kImageViewYPos    =   kCurrLabelYPos + 7.0f;
    UIImageView *downArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewXPos, kImageViewYPos, kImageViewWidth, kImageViewHeight)];
    [downArrowImageView setImage:[UIImage imageNamed:@"down_arrow_icon.png"]];
    [container addSubview:downArrowImageView];
    
    // add vertical line
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/3.0 - 0.5f, kTopMargin, 0.5f, kSortAndFilterBarHeight - 2 * kTopMargin)];
    verticalLine.backgroundColor = GRAY_COLOR_LIGHTER;
    [container addSubview:verticalLine];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSortAndFilterOptionToSortAndFilterBar
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width * 2/3.0f, 0, WINSIZE.width/3.0f, kSortAndFilterBarHeight - 0.5f)];
    [_sortAndFilterBar addSubview:container];
    
    // add icon
    CGFloat const kLeftMargin       =   8.0f;
    CGFloat const kTopMargin        =   8.0f;
    CGFloat const kIconWidth        =   20.0f;
    CGFloat const kIconHeight       =   20.0f;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin/2, kIconWidth, kIconHeight)];
    [iconImageView setImage:[UIImage imageNamed:@"sort_filter_icon.png"]];
    [container addSubview:iconImageView];
    
    CGFloat const kSortFilterLabelXPos   =   1.5 * kLeftMargin + kIconWidth;
    CGFloat const kSortFilterLabelWidth  =   WINSIZE.width - kSortFilterLabelXPos - kLeftMargin;
    CGFloat const kSortFilterLabelHeight =   20.0f;
    
    UILabel *sortFilterLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSortFilterLabelXPos, kTopMargin, kSortFilterLabelWidth, kSortFilterLabelHeight)];
    sortFilterLabel.text = NSLocalizedString(@"SORT/FILTER", nil);
    sortFilterLabel.textColor = TEXT_COLOR_DARK_GRAY;
    sortFilterLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:11];
    [container addSubview:sortFilterLabel];
    
    CGFloat const kCurrLabelXPos    =   2 * kLeftMargin;
    CGFloat const kCurrLabelYPos    =   1.2 * kTopMargin + 15;
    CGFloat const kCurrLabelWidth   =   WINSIZE.width/3.0 - kCurrLabelXPos - kLeftMargin;
    CGFloat const kCurrLabelHeight  =   20.0f;
    
    _currSortFilterLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrLabelXPos, kCurrLabelYPos, kCurrLabelWidth, kCurrLabelHeight)];
    _currSortFilterLabel.text = NSLocalizedString(@"Price", nil);
    _currSortFilterLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _currSortFilterLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:13];
    [container addSubview:_currSortFilterLabel];
    
    // add down arrow icon
    CGFloat const kImageViewWidth   =   8.0f;
    CGFloat const kImageViewHeight  =   8.0f;
    CGFloat const kImageViewXPos    =   WINSIZE.width/3.0 - kImageViewWidth - kLeftMargin;
    CGFloat const kImageViewYPos    =   kCurrLabelYPos + 7.0f;
    UIImageView *downArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewXPos, kImageViewYPos, kImageViewWidth, kImageViewHeight)];
    [downArrowImageView setImage:[UIImage imageNamed:@"down_arrow_icon.png"]];
    [container addSubview:downArrowImageView];
}


#pragma mark - CollectionViewDatasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_wantDataList count];
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
    
    WantData *wantData = [_wantDataList objectAtIndex:indexPath.row];
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


#pragma mark - ItemDetailsViewController Delegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) itemDetailsViewController:(ItemDetailsViewController *)controller didCompleteOffer:(BOOL)completed
//------------------------------------------------------------------------------------------------------------------------------
{
    if (completed) {
        [_delegate marketPlaceUserDidOfferForAnItem];
    }
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
                [self.wantDataList addObject:wantData];
            }
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
            [self.wantDataList insertObject:wantData atIndex:0];
            [_wantCollectionView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
