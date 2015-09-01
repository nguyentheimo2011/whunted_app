//
//  NewsFeedViewController.m
//  whunted
//
//  Created by thomas nguyen on 5/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedTableViewCell.h"
#import "Utilities.h"


@implementation NewsFeedViewController

//-----------------------------------------------------------------------------------------------------------------------------
- (id)init
//-----------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Data Initialization

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initData
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.newsfeedList = [[NSMutableArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"Ten",nil];
}


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Newsfeed", nil) forViewController:self];
}


#pragma - UITableViewDataSource methods

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return [self.newsfeedList count];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    static NSString *cellIdentifier = @"NewsFeedTableViewCell";
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell.itemImageView setBackgroundColor:[UIColor colorWithRed:135.0/255 green:206.0/255 blue:255.0/255 alpha:1]];
    [cell.itemName setText:@"Coach"];
    
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 300;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) pushViewController:(UIViewController *)controller
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController pushViewController:controller animated:YES];
}


@end
