//
//  MyWantViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MyWantViewController.h"
#import "HorizontalLineViewController.h"
#import "WantTableViewCell.h"
#import "WantData.h"

#import <Parse/Parse.h>

@interface MyWantViewController ()

@property (strong, nonatomic) UITableView *wantTableView;
@property (strong, nonatomic) UICollectionView *wantCollectionView;
@property (strong, nonatomic) HorizontalLineViewController *horizontalLineVC;

@end

@implementation MyWantViewController
{
    CGSize windowSize;
    NSString *documents;
}

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
    self.wantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, windowSize.width, windowSize.height * 0.7)];
    self.wantTableView.dataSource = self;
    self.wantTableView.delegate = self;
    [self.view addSubview:self.wantTableView];
}

#pragma mark - Data Handlers

- (void) retrieveWantDataList
{
    self.wantDataList = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"WantedPost"];
    [query whereKey:@"buyerID" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                WantData *wantData = [[WantData alloc] initWithPFObject:object];
                [self.wantDataList addObject:wantData];
            }
            [self.wantTableView reloadData];
            
            NSString *labelText = [NSString stringWithFormat:@"%lu wants", (unsigned long)[self.wantDataList count]];
            [self.horizontalLineVC.numLabel setText:labelText];
            
        } else {
            // Log details of the failure
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
    return windowSize.width * 1.3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyWantTableViewCell";
    
    WantTableViewCell *cell = (WantTableViewCell*)[self.wantTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[WantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WantData *wantData = [self.wantDataList objectAtIndex:indexPath.row];
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

    
    return cell;
}

@end
