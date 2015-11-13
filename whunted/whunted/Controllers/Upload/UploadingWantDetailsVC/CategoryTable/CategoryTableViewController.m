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
        
        _categoryList = [NSMutableArray arrayWithObjects:NSLocalizedString(ITEM_CATEGORY_LUXURY_FASHION, nil), NSLocalizedString(ITEM_CATEGORY_POPULAR_BRANDS, nil), NSLocalizedString(ITEM_CATEGORY_BEAUTY_PRODUCTS, nil), NSLocalizedString(ITEM_CATEGORY_CLOTHING_APPARELS, nil), NSLocalizedString(ITEM_CATEGORY_SHOES_BAG_ACCESSORIES, nil), NSLocalizedString(ITEM_CATEGORY_3C_PRODUCTS, nil), NSLocalizedString(ITEM_CATEGORY_ART_DESIGN, nil), NSLocalizedString(ITEM_CATEGORY_HOME_ACCESSORIES, nil), NSLocalizedString(ITEM_CATEGORY_HOME_FURNITURE, nil), NSLocalizedString(ITEM_CATEGORY_PET_SUPPLIES, nil), NSLocalizedString(ITEM_CATEGORY_GAMES, nil), NSLocalizedString(ITEM_CATEGORY_TOYS, nil), NSLocalizedString(ITEM_CATEGORY_BOOKS_MAGAZINES, nil), NSLocalizedString(ITEM_CATEGORY_VIDEO_PRODUCTION_EQUIPMENT, nil), NSLocalizedString(ITEM_CATEGORY_MUSICAL_INSTRUMENTS, nil), NSLocalizedString(ITEM_CATEGORY_SPORTS_EQUIPMENT, nil), NSLocalizedString(ITEM_CATEGORY_PROFESSIONAL_SERVICES, nil), NSLocalizedString(ITEM_CATEGORY_TICKETS_AND_VOUCHERS, nil), NSLocalizedString(ITEM_CATEGORY_CUSTOMIZED_PRODUCTS, nil), NSLocalizedString(ITEM_CATEGORY_RENTING, nil), NSLocalizedString(ITEM_CATEGORY_OTHERS, nil),nil];
        
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
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    if (_usedForFiltering)
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [_delegte categoryTableView:self didSelectCategory:category];
        }];
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [_delegte categoryTableView:self didSelectCategory:category];
    }
}
 

@end
