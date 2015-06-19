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

@interface MarketplaceViewController ()

@property (nonatomic, strong) UICollectionView *_wantCollectionView;

@end

@implementation MarketplaceViewController
{
    NSString *documents;
}

@synthesize wantDataList;
@synthesize _wantCollectionView;

- (id) init
{
    self = [super init];
    if (self != nil) {
        [self retrieveWantDataList];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    [self addWantCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers

- (void) addWantCollectionView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _wantCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _wantCollectionView.dataSource = self;
    _wantCollectionView.delegate = self;
    _wantCollectionView.backgroundColor = BACKGROUND_COLOR;
    
    [_wantCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    [self.view addSubview:_wantCollectionView];
}

#pragma mark - Data Handlers
- (void) retrieveWantDataList
{
    wantDataList = [[NSMutableArray alloc] init];
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

- (void) retrieveLatestWantData
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

#pragma mark - CollectionView datasource methods
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [wantDataList count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MarketplaceCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MarketplaceCollectionViewCell" forIndexPath:indexPath];
    
    if (cell.itemImageView == nil) {
        [cell initCell];
    }
    
    WantData *wantData = [wantDataList objectAtIndex:indexPath.row];
    [cell.itemNameLabel setText:wantData.itemName];
    [cell.demandedPriceLabel setText:wantData.demandedPrice];
    [cell.buyerUsernameLabel setText:wantData.buyer.objectId];
    
    cell.itemImageView.image = nil;
    NSString *fileName = [NSString stringWithFormat:@"marketplace_%@.jpg", wantData.itemID];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists) {
        [cell.itemImageView hnk_setImageFromFile:path];
    } else {
        PFRelation *picRelation = wantData.itemPictureList;
        [[picRelation query] getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error) {
            if (!error) {
                PFFile *firstPicture = firstObject[@"itemPicture"];
                [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2) {
                    if (!error_2) {
                        UIImage *image = [UIImage imageWithData:data];
                        NSData *data = UIImageJPEGRepresentation(image, 1);
                        [data writeToFile:path atomically:YES];
                        [cell.itemImageView setImage:image];
                    } else {
                        NSLog(@"Error: %@ %@", error_2, [error_2 userInfo]);
                    }
                }];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"OfferedWant"];
    [query whereKey:@"itemID" equalTo:wantData.itemID];
    [query countObjectsInBackgroundWithBlock:^(int sellersNum, NSError *error) {
        NSString *text;
        if (sellersNum <= 1) {
            text = [NSString stringWithFormat:@"%d 賣家", sellersNum];
        } else {
            text = [NSString stringWithFormat:@"%d 賣家", sellersNum];
        }
        
        if (!error) {
            [cell.sellerNumButton setTitle:text forState:UIControlStateNormal];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WINSIZE.width/2-15, WINSIZE.width/2 + 110);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}

#pragma mark - UICollectionView delegate methods
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ItemDetailsViewController *itemDetailsVC = [[ItemDetailsViewController alloc] init];
    itemDetailsVC.wantData = [wantDataList objectAtIndex:indexPath.row];
    itemDetailsVC.delegate = self;
    [[itemDetailsVC.wantData.itemPictureList query] countObjectsInBackgroundWithBlock:^(int itemImagesNum, NSError *error) {
        if (!error) {
            itemDetailsVC.itemImagesNum = itemImagesNum;
            
            PFQuery *sQuery = [PFQuery queryWithClassName:@"OfferedWant"];
            [sQuery whereKey:@"sellerID" equalTo:[PFUser currentUser].objectId];
            [sQuery whereKey:@"itemID" equalTo:itemDetailsVC.wantData.itemID];
            [sQuery getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError *error) {
                if (!error) {
                    if (object) {
                        itemDetailsVC.offeredByCurrUser = YES;
                        itemDetailsVC.offerPFObject = object;
                    }
                    else
                        itemDetailsVC.offeredByCurrUser = NO;
                } else {
                    NSLog(@"Error %@ %@", error, [error userInfo]);
                }
                
                [self.navigationController pushViewController:itemDetailsVC animated:YES];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - ItemDetailsViewController Delegate
- (void) itemDetailsViewController:(ItemDetailsViewController *)controller didCompleteOffer:(BOOL)completed
{
    if (completed) {
        [self.delegate genericController:self shouldUpdateDataAt:3];
    }
}

#pragma mark - Overridden methods
- (void) pushViewController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}

@end
