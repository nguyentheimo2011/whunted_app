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

#define     kNormalCellHeight       42.0f
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
    
    UITextField             *_cityTextField;
    
    NSInteger               _selectedSortingIndex;
}

@synthesize delegate            =   _delegate;
@synthesize sortingCriterion    =   _sortingCriterion;
@synthesize buyerLocationFilter =   _buyerLocationFilter;

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
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


#pragma mark - Data Initialization

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initData
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSArray *array = @[NSLocalizedString(@"Popular", nil), NSLocalizedString(@"Recent", nil), NSLocalizedString(@"Lowest Price", nil), NSLocalizedString(@"Highest Price", nil), NSLocalizedString(@"Nearest Price", nil)];
    _selectedSortingIndex = [array indexOfObject:_sortingCriterion];
}


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Sort & Filter", nil) forViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelSortAndFilter)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Apply", nil) style:UIBarButtonItemStylePlain target:self action:@selector(applyNewSortingAndFilteringCriteria)];
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
    [self addCheckMarkToSelectedSortingCell];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initPopularSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _popularSortCell = [[UITableViewCell alloc] init];
    _popularSortCell.textLabel.text = NSLocalizedString(SORTING_BY_POPULAR, nil);
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
    _recentSortCell.textLabel.text = NSLocalizedString(SORTING_BY_RECENT, nil);
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
    _lowestPriceSortCell.textLabel.text = NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil);
    _lowestPriceSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _lowestPriceSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _lowestPriceSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *lowestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin-2.5, kIconWidth+5, kIconHeight+5)];
    UIImage *lowestImage = [UIImage imageNamed:@"lowest_price_icon.png"];
    [lowestImageView setImage:lowestImage];
    [_lowestPriceSortCell addSubview:lowestImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initHighestPriceSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _highestPriceSortCell = [[UITableViewCell alloc] init];
    _highestPriceSortCell.textLabel.text = NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil);
    _highestPriceSortCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _highestPriceSortCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _highestPriceSortCell.indentationLevel = 3;
    
    // add popular sort icon
    UIImageView *highestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin-2.5, kIconWidth+5, kIconHeight+5)];
    UIImage *highestImage = [UIImage imageNamed:@"highest_price_icon.png"];
    [highestImageView setImage:highestImage];
    [_highestPriceSortCell addSubview:highestImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initNearestSortCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _nearestSortCell = [[UITableViewCell alloc] init];
    _nearestSortCell.textLabel.text = NSLocalizedString(SORTING_BY_NEAREST, nil);
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
- (void) addCheckMarkToSelectedSortingCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSArray *cells = @[_popularSortCell, _recentSortCell, _lowestPriceSortCell, _highestPriceSortCell, _nearestSortCell];
    
    if (_selectedSortingIndex != NSNotFound) {
        UITableViewCell *cell = [cells objectAtIndex:_selectedSortingIndex];
        cell.textLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:SMALL_FONT_SIZE];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initBuyerLocationCell
//-----------------------------------------------------------------------------------------------------------------------------
{
    _buyerLocationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BuyerLocationCell"];
    _buyerLocationCell.textLabel.text = NSLocalizedString(@"Location", nil);
    _buyerLocationCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _buyerLocationCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _buyerLocationCell.indentationLevel = 3;
    _buyerLocationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _buyerLocationCell.detailTextLabel.text = _buyerLocationFilter;
    _buyerLocationCell.detailTextLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    
    // add popular sort icon
    UIImageView *buyerLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *buyerLocationImage = [UIImage imageNamed:@"buyer_location_icon.png"];
    [buyerLocationImageView setImage:buyerLocationImage];
    [_buyerLocationCell addSubview:buyerLocationImageView];
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
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    return kNormalCellHeight;
}

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
        return NSLocalizedString(@"FILTER BY BUYER'S LOCATION", nil);
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

//--------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row != _selectedSortingIndex) {
            // clear checkmark from the previous cell
            UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedSortingIndex inSection:0]];
            prevCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
            prevCell.accessoryType = UITableViewCellAccessoryNone;
            
            // add checkmark to the chosen cell
            UITableViewCell *chosenCell = [tableView cellForRowAtIndexPath:indexPath];
            chosenCell.textLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:SMALL_FONT_SIZE];
            chosenCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            // update data
            _selectedSortingIndex = indexPath.row;
            _sortingCriterion = chosenCell.textLabel.text;
        }
    } else {
        CityViewController *cityViewController = [[CityViewController alloc] init];
        cityViewController.isToSetProductOrigin = NO;
        cityViewController.delegate = self;
        [self.navigationController pushViewController:cityViewController animated:YES];
    }
}


#pragma mark - Event Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) cancelSortAndFilter
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) applyNewSortingAndFilteringCriteria
//-----------------------------------------------------------------------------------------------------------------------------
{
    [_delegate sortAndFilterTableView:self didCompleteChoosingSortingCriterion:_sortingCriterion];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - CityViewDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (void) cityView:(CityViewController *)controller didSpecifyLocation:(NSString *)location
//-----------------------------------------------------------------------------------------------------------------------------
{
    _buyerLocationCell.detailTextLabel.text = location;
    
    _buyerLocationFilter = location;
}

@end
