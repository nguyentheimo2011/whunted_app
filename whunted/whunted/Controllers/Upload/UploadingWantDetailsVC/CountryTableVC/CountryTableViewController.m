//
//  ProductOriginTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CountryTableViewController.h"
#import "Utilities.h"


@implementation CountryTableViewController
{
    NSArray             *_fullCountryList;
}

@synthesize delegate            =   _delegate;
@synthesize selectedCountries   =   _selectedCountries;
@synthesize usedForFiltering    =   _usedForFiltering;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithSelectedCountries: (NSArray *) origins usedForFiltering: (BOOL) used
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        _selectedCountries = [NSArray arrayWithArray:origins];
        _usedForFiltering = used;
        
        [self getCountryList];
        [self customizeNavigationBar];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

#pragma mark - UI Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoosingOrigins)];
    
    if (!_usedForFiltering) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(completeChoosingOrigins)];
    }
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Product Origin", nil) forViewController:self];
    
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - Data Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) getCountryList
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CountryNames" ofType:@"plist"];
    _fullCountryList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
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
    return [_fullCountryList count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellID = @"ProductOriginCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_fullCountryList objectAtIndex:indexPath.row];
    
    NSString *country = [_fullCountryList objectAtIndex:indexPath.row];
    if ([_selectedCountries containsObject:country]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *country = [_fullCountryList objectAtIndex:indexPath.row];
    
    if (_usedForFiltering)
    {   // if country table is used for filtering, only on country can be chosen
        [_delegate countryTableView:self didCompleteChoosingACountry:country];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {   // multiple countries can be chosen        
        if ([_selectedCountries containsObject:country]) {
            // remove country from selected list
            NSMutableArray *countries = [NSMutableArray arrayWithArray:_selectedCountries];
            [countries removeObject:country];
            _selectedCountries = [NSArray arrayWithArray:countries];
            
            // remove check mark
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            // add country to selected list
            NSMutableArray *countries = [NSMutableArray arrayWithArray:_selectedCountries];
            [countries addObject:country];
            _selectedCountries = [NSArray arrayWithArray:countries];
            
            // add check mark
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) completeChoosingOrigins
//------------------------------------------------------------------------------------------------------------------------------
{
    if (!_usedForFiltering) {
        [_delegate countryTableView:self didCompleteChoosingCountries:_selectedCountries];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelChoosingOrigins
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_usedForFiltering)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

@end
