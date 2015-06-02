//
//  MarketplaceViewController.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceViewController.h"
#import "MarketplaceCollectionViewCell.h"

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
    _wantCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_wantCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    [self.view addSubview:_wantCollectionView];
}

#pragma mark - Data Handlers
- (void) retrieveWantDataList
{
    wantDataList = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
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

#pragma mark - Collection View Datasource 
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
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WINSIZE.width/2-5, WINSIZE.height/2);
}

@end
