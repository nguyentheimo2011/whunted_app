//
//  SortAndFilterTableVC.m
//  whunted
//
//  Created by thomas nguyen on 26/8/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SortAndFilterTableVC.h"
#import "AppConstant.h"
#import "Utilities.h"


@implementation SortAndFilterTableVC
{
    UITableViewCell         *_popularSortCell;
    UITableViewCell         *_recentSortCell;
    UITableViewCell         *_lowestPriceSortCell;
    UITableViewCell         *_highestPriceSortCell;
    UITableViewCell         *_nearestSortCell;
    
    UITableViewCell         *_buyerLocationCell;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"SortAndFilterTableVC didReceiveMemoryWarning");
}


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Sort & Filter", nil) forViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelSortAndFilter)];
}


#pragma mark - TableViewDataSource methods

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 2;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 5;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    return cell;
}


#pragma mark - Event Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) cancelSortAndFilter
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
