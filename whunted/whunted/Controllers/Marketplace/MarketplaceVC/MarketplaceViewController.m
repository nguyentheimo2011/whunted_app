//
//  MarketplaceViewController.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceViewController.h"
#import "SellerListViewController.h"
#import "AppConstant.h"
#import "MBProgressHUD.h"
#import "SyncEngine.h"
#import "OfferData.h"

@interface MarketplaceViewController ()

@property (nonatomic, strong) UICollectionView *wantCollectionView;

@end

//------------------------------------------------------------------------------------------------------------------------------

@implementation MarketplaceViewController

@synthesize wantDataList = _wantDataList;
@synthesize wantCollectionView = _wantCollectionView;

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
    [self setTitle:@"Marketplace"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addWantCollectionView
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _wantCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _wantCollectionView.dataSource = self;
    _wantCollectionView.delegate = self;
    _wantCollectionView.backgroundColor = BACKGROUND_GRAY_COLOR;
    
    [_wantCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    [self.view addSubview:_wantCollectionView];
}

#pragma mark - CollectionView datasource methods

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
    
    if (cell.itemImageView == nil) {
        [cell initCell];
    }
    
    WantData *wantData = [_wantDataList objectAtIndex:indexPath.row];
    [cell setWantData:wantData];
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    return CGSizeMake(WINSIZE.width/2-15, WINSIZE.width/2 + 110);
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 10.0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 15.0;
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
        [self.delegate genericController:self shouldUpdateDataAt:3];
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
    [query orderByDescending:@"updatedAt"];
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
- (void) retrieveLatestWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
    [query orderByDescending:@"updatedAt"];
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
