//
//  MyWantViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MyWantViewController.h"
#import "HorizontalLineViewController.h"
#import "WantData.h"
#import "SellersOfferData.h"

#import <Parse/Parse.h>

@interface MyWantViewController ()

@property (strong, nonatomic) UITableView *_wantTableView;
@property (strong, nonatomic) UICollectionView *wantCollectionView;
@property (strong, nonatomic) HorizontalLineViewController *horizontalLineVC;

@end

@implementation MyWantViewController
{
    CGSize windowSize;
    NSString *documents;
}

@synthesize _wantTableView;

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
    // Do any additional setup after loading the view from its nib.
    
    windowSize = [[UIScreen mainScreen] bounds].size;
    documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    [self addHorizontalLine];
    [self addTableView];
}

#pragma mark - UI Handlers

- (void) addHorizontalLine
{
    CGSize navBarSize = self.navigationController.navigationBar.frame.size;
    
    self.horizontalLineVC = [[HorizontalLineViewController alloc] init];
    CGRect frame = self.horizontalLineVC.view.frame;
    self.horizontalLineVC.view.frame = CGRectMake(0, navBarSize.height + 15, windowSize.width, frame.size.height);
    NSString *labelText = [NSString stringWithFormat:@"%lu wants", (unsigned long)[self.wantDataList count]];
    [self.horizontalLineVC.numLabel setText:labelText];
    [self.view addSubview:self.horizontalLineVC.view];
}

- (void) addTableView
{
    _wantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, windowSize.width, windowSize.height * 0.7)];
    _wantTableView.dataSource = self;
    _wantTableView.delegate = self;
    [self.view addSubview:_wantTableView];
}

#pragma mark - Data Handlers

- (void) retrieveWantDataList
{
    self.wantDataList = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
    [query whereKey:@"buyerID" equalTo:currentUser];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                WantData *wantData = [[WantData alloc] initWithPFObject:object];
                [self.wantDataList addObject:wantData];
            }
            [_wantTableView reloadData];
            
            NSString *labelText = [NSString stringWithFormat:@"%lu wants", (unsigned long)[self.wantDataList count]];
            [self.horizontalLineVC.numLabel setText:labelText];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) retrieveLatestWantData
{
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
    [query whereKey:@"buyerID" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"updatedAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        if (!error) {
            WantData *wantData = [[WantData alloc] initWithPFObject:obj];
            [self.wantDataList insertObject:wantData atIndex:0];
            [_wantTableView reloadData];
            
            NSString *labelText = [NSString stringWithFormat:@"%lu wants", (unsigned long)[self.wantDataList count]];
            [self.horizontalLineVC.numLabel setText:labelText];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.wantDataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return windowSize.width * 1.4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyWantTableViewCell";
    
    WantTableViewCell *cell = (WantTableViewCell*)[_wantTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[WantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    
    WantData *wantData = [self.wantDataList objectAtIndex:indexPath.row];
    cell.wantData = wantData;
    [cell.itemNameLabel setText:wantData.itemName];
    
    cell.itemImageView.image = nil;
    NSString *fileName = [NSString stringWithFormat:@"want_%@.jpg", wantData.itemID];
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
    
    if (wantData.isDealClosed) {
        [cell.sellersNumButton setTitle:@"1 seller" forState:UIControlStateNormal];
        [cell.sellersNumButton setBackgroundColor:[UIColor colorWithRed:219.0/255 green:112.0/255 blue:147.0/255 alpha:1.0]];
    } else {
        [cell.sellersNumButton setBackgroundColor: APP_COLOR_4];
        [cell.sellersNumButton setTitle:@"0 seller" forState:UIControlStateNormal];
        PFQuery *query = [PFQuery queryWithClassName:@"OfferedWant"];
        [query whereKey:@"itemID" equalTo:wantData.itemID];
        [query countObjectsInBackgroundWithBlock:^(int sellersNum, NSError *error) {
            NSString *text;
            if (sellersNum <= 1) {
                text = [NSString stringWithFormat:@"%d seller", sellersNum];
            } else {
                text = [NSString stringWithFormat:@"%d sellers", sellersNum];
            }
            
            if (!error) {
                [cell.sellersNumButton setTitle:text forState:UIControlStateNormal];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }

    
    return cell;
}

#pragma mark - WantTableView Delegate methods
- (void) wantTableViewCell:(WantTableViewCell *)cell didClickSellersNumButton:(WantData *)wantData
{
    PFQuery *query;
    if (wantData.isDealClosed) {
        query = [PFQuery queryWithClassName:@"AcceptedOffer"];
    } else {
        query = [PFQuery queryWithClassName:@"OfferedWant"];
    }
    
    [query whereKey:@"itemID" equalTo:wantData.itemID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *sellersOfferList, NSError *error) {
        if (!error) {
            NSMutableArray *offerDataList = [[NSMutableArray alloc] init];
            for (PFObject *obj in sellersOfferList) {
                SellersOfferData *offerData = [[SellersOfferData alloc] initWithPFObject:obj];
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
- (void) sellerListViewController:(SellerListViewController *)controller didAcceptOfferFromSeller:(WantData *)wantData
{
    [_wantTableView reloadData];
}


@end
