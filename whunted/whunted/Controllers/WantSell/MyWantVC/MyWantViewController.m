//
//  MyWantViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MyWantViewController.h"
#import "HorizontalLineViewController.h"
#import "MyWantTableViewCell.h"

@interface MyWantViewController ()

@property (strong, nonatomic) UITableView *wantTableView;
@property (strong, nonatomic) UICollectionView *wantCollectionView;
@property (strong, nonatomic) HorizontalLineViewController *horizontalLineVC;

@end

@implementation MyWantViewController
{
    CGSize windowSize;
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        [self retrieveWantDataList];
        NSLog(@"");
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    windowSize = [[UIScreen mainScreen] bounds].size;
    
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
    NSString *labelText = [NSString stringWithFormat:@"%d wants", [self.wantDataList count]];
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

#pragma mark - Data Handler

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
                [self.wantTableView reloadData];
                NSString *labelText = [NSString stringWithFormat:@"%d wants", [self.wantDataList count]];
                [self.horizontalLineVC.numLabel setText:labelText];
            }
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
    
    MyWantTableViewCell *cell;
//    = (MyWantTableViewCell*)[self.wantTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WantData *wantData = [self.wantDataList objectAtIndex:indexPath.row];
        [cell.itemNameLabel setText:wantData.itemName];
        
        PFRelation *picRelation = wantData.itemPictureList;
        PFObject *firstObject = [[picRelation query] getFirstObject];
        PFFile *firstPicture = firstObject[@"itemPicture"];
        NSData *data = [firstPicture getData];
        UIImage *image = [UIImage imageWithData:data];
        [cell.imageView setImage:image];
    }
    
    
    return cell;
}

@end
