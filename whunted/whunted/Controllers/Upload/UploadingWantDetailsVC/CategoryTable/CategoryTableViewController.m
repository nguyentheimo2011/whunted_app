//
//  CategoryTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation CategoryTableViewController
{
    NSMutableArray      *_categoryList;
    NSUInteger          _selectedIndex;
}

@synthesize usedForFiltering = _usedForFiltering;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithCategory:(NSString *)category usedForFiltering: (BOOL) used
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self)
    {
        _usedForFiltering = used;
        
        _categoryList = [NSMutableArray arrayWithObjects:NSLocalizedString(ITEM_CATEGORY_BEAUTY_PRODUCTS, nil), NSLocalizedString(ITEM_CATEGORY_BOOKS_AND_MAGAZINES, nil), NSLocalizedString(ITEM_CATEGORY_LUXURY_BRANDED, nil), NSLocalizedString(ITEM_CATEGORY_GAMES_AND_TOYS, nil), NSLocalizedString(ITEM_CATEGORY_PROFESSIONAL_SERVICES, nil), NSLocalizedString(ITEM_CATEGORY_SPORT_EQUIPMENTS, nil), NSLocalizedString(ITEM_CATEGORY_TICKETS_AND_VOUCHERS, nil), NSLocalizedString(ITEM_CATEGORY_WATCHES, nil), NSLocalizedString(ITEM_CATEGORY_CUSTOMIZATION, nil), NSLocalizedString(ITEM_CATEGORY_BORROWING, nil), NSLocalizedString(ITEM_CATEGORY_FUNITURE, nil), NSLocalizedString(ITEM_CATEGORY_OTHERS, nil),nil];
        
        if (_usedForFiltering)
            [_categoryList insertObject:NSLocalizedString(@"All", nil) atIndex:0];
        
        _selectedIndex = [_categoryList indexOfObject:category];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"CategoryScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_usedForFiltering)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoosingCategory)];
    }
    else
    {
        [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
    }
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Category", nil) forViewController:self];
}


#pragma mark - Table view data source

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_categoryList count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellID = @"CategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_categoryList objectAtIndex:indexPath.row];
    if (indexPath.row == _selectedIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectedIndex != NSNotFound)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *selectedCategory = [_categoryList objectAtIndex:indexPath.row];
    [self completeChoosingCategory:selectedCategory];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelChoosingCategory
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) completeChoosingCategory: (NSString *) category
//------------------------------------------------------------------------------------------------------------------------------
{
    [_delegte categoryTableView:self didSelectCategory:category];
    
    if (_usedForFiltering)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
 

@end
