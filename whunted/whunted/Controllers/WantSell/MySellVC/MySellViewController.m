//
//  MySellViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MySellViewController.h"
#import "HorizontalLineViewController.h"
#import "WantData.h"
#import "OfferData.h"
#import "AppConstant.h"

#import <Parse/Parse.h>

@interface MySellViewController ()

@end

@implementation MySellViewController
{
    UITableView                     *_wantTableView;
    UICollectionView                *_wantCollectionView;
    HorizontalLineViewController    *_horizontalLineVC;
    
    NSString                        *_documents;
    NSMutableArray                  *_yourOfferPriceList;
}

//---------------------------------------------------------------------------------------------------------------------------------
- (id) init
//---------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        [self retrieveWantDataList];
    }
    
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//---------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];

    _documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _yourOfferPriceList = [[NSMutableArray alloc] init];
    
    [self addHorizontalLine];
    [self addTableView];
}

#pragma mark - UI Handlers

//---------------------------------------------------------------------------------------------------------------------------------
- (void) addHorizontalLine
//---------------------------------------------------------------------------------------------------------------------------------
{
    CGSize navBarSize = self.navigationController.navigationBar.frame.size;
    
    _horizontalLineVC = [[HorizontalLineViewController alloc] init];
    CGRect frame = _horizontalLineVC.view.frame;
    _horizontalLineVC.view.frame = CGRectMake(0, navBarSize.height + 15, WINSIZE.width, frame.size.height);
    NSString *labelText = [NSString stringWithFormat:@"%lu offers", (unsigned long)[self.wantDataList count]];
    [_horizontalLineVC.numLabel setText:labelText];
    [self.view addSubview:_horizontalLineVC.view];
}

//---------------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//---------------------------------------------------------------------------------------------------------------------------------
{
    _wantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, WINSIZE.width, WINSIZE.height * 0.7)];
    _wantTableView.dataSource = self;
    _wantTableView.delegate = self;
    [self.view addSubview:_wantTableView];
}

#pragma mark - Data Handlers

//---------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveWantDataList
//---------------------------------------------------------------------------------------------------------------------------------
{
    self.wantDataList = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:PF_OFFER_CLASS];
    [query whereKey:@"sellerID" equalTo:currentUser.objectId];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *offerObjects, NSError *error) {
        if (!error) {
            for (int i=0; i<[offerObjects count]; i++) {
                PFObject *object = [offerObjects objectAtIndex:i];
                NSString *itemID = object[@"itemID"];
                PFQuery *sQuery = [PFQuery queryWithClassName:@"WantedPost"];
                [sQuery getObjectInBackgroundWithId:itemID block:^(PFObject *wantPFObj, NSError *error) {
                    WantData *wantData = [[WantData alloc] initWithPFObject:wantPFObj];
                    [self.wantDataList addObject:wantData];
                    [_yourOfferPriceList addObject:object[@"offeredPrice"]];
                    if (i == [offerObjects count] - 1)
                        [_wantTableView reloadData];
                }];
            }
            
            NSString *labelText = [NSString stringWithFormat:@"%lu offers", (unsigned long)[self.wantDataList count]];
            [_horizontalLineVC.numLabel setText:labelText];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//---------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveLatestWantData
//---------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:PF_OFFER_CLASS];
    [query whereKey:@"sellerID" equalTo:currentUser.objectId];
    [query orderByDescending:@"updatedAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *offerObject, NSError *error) {
        if (!error) {
            NSString *itemID = offerObject[@"itemID"];
            PFQuery *sQuery = [PFQuery queryWithClassName:@"WantedPost"];
            [sQuery getObjectInBackgroundWithId:itemID block:^(PFObject *wantPFObj, NSError *error) {
                WantData *wantData = [[WantData alloc] initWithPFObject:wantPFObj];
                [self.wantDataList insertObject:wantData atIndex:0];
                [_yourOfferPriceList insertObject:offerObject[@"offeredPrice"] atIndex:0];
                [_wantTableView reloadData];
            }];
            
            NSString *labelText = [NSString stringWithFormat:@"%lu offers", (unsigned long)[self.wantDataList count]];
            [_horizontalLineVC.numLabel setText:labelText];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source

//---------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//---------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//---------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//---------------------------------------------------------------------------------------------------------------------------------
{
    return [self.wantDataList count];
}

//---------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//---------------------------------------------------------------------------------------------------------------------------------
{
    return WINSIZE.width * 1.4;
}

//---------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//---------------------------------------------------------------------------------------------------------------------------------
{
    static NSString *cellIdentifier = @"MySellTableViewCell";
    
    SellTableViewCell *cell = (SellTableViewCell*)[_wantTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[SellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    
    if ([_yourOfferPriceList count] > indexPath.row) {
        [cell.yourOfferLabel setText:[NSString stringWithFormat:@"Your offer: %@", [_yourOfferPriceList objectAtIndex:indexPath.row]]];
    }
    
    WantData *wantData = [self.wantDataList objectAtIndex:indexPath.row];
    cell.wantData = wantData;
    [cell.itemNameLabel setText:wantData.itemName];
    
    cell.itemImageView.image = nil;
    NSString *fileName = [NSString stringWithFormat:@"sell_%@.jpg", wantData.itemID];
    NSString *path = [_documents stringByAppendingPathComponent:fileName];
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
    
    return cell;
}

#pragma mark - WantTableView Delegate methods

//---------------------------------------------------------------------------------------------------------------------------------
- (void) sellTableViewCell:(SellTableViewCell *)cell didClickSellersNumButton:(WantData *)wantData
//---------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query;
    if (wantData.isDealClosed) {
        query = [PFQuery queryWithClassName:PF_ACCEPTED_OFFER_CLASS];
    } else {
        query = [PFQuery queryWithClassName:PF_OFFER_CLASS];
    }
    
    [query whereKey:@"itemID" equalTo:wantData.itemID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *sellersOfferList, NSError *error) {
        if (!error) {
            NSMutableArray *offerDataList = [[NSMutableArray alloc] init];
            for (PFObject *obj in sellersOfferList) {
                OfferData *offerData = [[OfferData alloc] initWithPFObject:obj];
                [offerDataList addObject:offerData];
            }
            wantData.sellersOfferList = [NSArray arrayWithArray:offerDataList];
            SellerListViewController *sellerListVC = [[SellerListViewController alloc] init];
            sellerListVC.wantData = wantData;
            sellerListVC.delegate = self;
            [self.navigationController pushViewController:sellerListVC animated:YES];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - SellerListViewController delegate methods

//---------------------------------------------------------------------------------------------------------------------------------
- (void) sellerListViewController:(SellerListViewController *)controller didAcceptOfferFromSeller:(WantData *)wantData
//---------------------------------------------------------------------------------------------------------------------------------
{
    [_wantTableView reloadData];
}

#pragma mark - Overridden methods

//---------------------------------------------------------------------------------------------------------------------------------
- (void) pushViewController:(UIViewController *)controller
//---------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController pushViewController:controller animated:YES];
}

@end

