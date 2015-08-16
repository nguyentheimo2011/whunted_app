//
//  CategoryTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "Utilities.h"

@implementation CategoryTableViewController
{
    NSArray         *_categoryList;
    NSUInteger      _selectedIndex;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    [self customizeUI];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _categoryList = [NSArray arrayWithObjects:NSLocalizedString(@"Beauty products", nil), NSLocalizedString(@"Books and magazines", nil), NSLocalizedString(@"Luxury branded", nil), NSLocalizedString(@"Games & Toys", nil), NSLocalizedString(@"Professional services", nil), NSLocalizedString(@"Sporting equipment", nil), NSLocalizedString(@"Tickets and vouchers", nil), NSLocalizedString(@"Watches", nil), NSLocalizedString(@"Customization", nil), NSLocalizedString(@"Borrowing", nil), NSLocalizedString(@"Furniture", nil), NSLocalizedString(@"Others", nil),nil];
    
    _selectedIndex = [_categoryList indexOfObject:self.category];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_categoryList objectAtIndex:indexPath.row];
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedIndex != NSNotFound) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    _selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSString *selectedCategory = [_categoryList objectAtIndex:indexPath.row];
    [self.delegte categoryTableViewController:self didSelectCategory:selectedCategory];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}
 

@end
