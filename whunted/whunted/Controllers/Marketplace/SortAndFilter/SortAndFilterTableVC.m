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

#define     kCellHeight             40.0f
#define     kIconWidth              20.0f
#define     kIconHeight             20.0f
#define     kIconLeftMargin         15.0f
#define     kIconTopMargin          10.0f

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
    [self initCells];
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

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self initPopularSortCell];
    [self initRecentSortCell];
    [self initLowestPriceSortCell];
    [self initHighestPriceSortCell];
    [self initNearestSortCell];
    [self initBuyerLocationCell];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initPopularSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _popularSortCell = [[UITableViewCell alloc] init];
    _popularSortCell.textLabel.text = NSLocalizedString(@"Popular", nil);
    _popularSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _popularSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _popularSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *popImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *popImage = [UIImage imageNamed:@"popular_icon.png"];
    [popImageView setImage:popImage];
    [_popularSortCell addSubview:popImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initRecentSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _recentSortCell = [[UITableViewCell alloc] init];
    _recentSortCell.textLabel.text = NSLocalizedString(@"Recent", nil);
    _recentSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _recentSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _recentSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *recentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *recentImage = [UIImage imageNamed:@"recent_icon.png"];
    [recentImageView setImage:recentImage];
    [_recentSortCell addSubview:recentImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initLowestPriceSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _lowestPriceSortCell = [[UITableViewCell alloc] init];
    _lowestPriceSortCell.textLabel.text = NSLocalizedString(@"Lowest Price", nil);
    _lowestPriceSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _lowestPriceSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _lowestPriceSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *lowestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *lowestImage = [UIImage imageNamed:@"lowest_price_icon.png"];
    [lowestImageView setImage:lowestImage];
    [_lowestPriceSortCell addSubview:lowestImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initHighestPriceSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _highestPriceSortCell = [[UITableViewCell alloc] init];
    _highestPriceSortCell.textLabel.text = NSLocalizedString(@"Highest Price", nil);
    _highestPriceSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _highestPriceSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _highestPriceSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *highestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *highestImage = [UIImage imageNamed:@"highest_price_icon.png"];
    [highestImageView setImage:highestImage];
    [_highestPriceSortCell addSubview:highestImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initNearestSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _nearestSortCell = [[UITableViewCell alloc] init];
    _nearestSortCell.textLabel.text = NSLocalizedString(@"Nearest Price", nil);
    _nearestSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _nearestSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _nearestSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *nearestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *nearestImage = [UIImage imageNamed:@"nearest_icon.png"];
    [nearestImageView setImage:nearestImage];
    [_nearestSortCell addSubview:nearestImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initBuyerLocationCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _buyerLocationCell = [[UITableViewCell alloc] init];
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
    if (section == 0)
        return 5;
    else
        return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return _popularSortCell;
        else if (indexPath.row == 1)
            return _recentSortCell;
        else if (indexPath.row == 2)
            return _lowestPriceSortCell;
        else if (indexPath.row == 3)
            return _highestPriceSortCell;
        else
            return _nearestSortCell;
    } else
        return _buyerLocationCell;
}


#pragma mark - UITableViewDelegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 40.0f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 0.01f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return NSLocalizedString(@"SORT BY", nil);
    else
        return NSLocalizedString(@"FILTER BY LOCATION", nil);
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}


#pragma mark - Event Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) cancelSortAndFilter
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
