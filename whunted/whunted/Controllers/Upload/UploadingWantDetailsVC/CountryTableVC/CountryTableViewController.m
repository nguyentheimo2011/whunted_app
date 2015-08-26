//
//  ProductOriginTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CountryTableViewController.h"

@implementation CountryTableViewController
{
    NSArray             *_fullCountryList;
}

@synthesize selectedCountries   =   _selectedCountries;
@synthesize delegate            =   _delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithSelectedCountries: (NSArray *) origins
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        _selectedCountries = [NSArray arrayWithArray:origins];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoosingOrigins)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(completeChoosingOrigins)];
    
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
    if ([_selectedCountries containsObject:country]) {
        NSMutableArray *countries = [NSMutableArray arrayWithArray:_selectedCountries];
        [countries removeObject:country];
        _selectedCountries = [NSArray arrayWithArray:countries];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        NSMutableArray *countries = [NSMutableArray arrayWithArray:_selectedCountries];
        [countries addObject:country];
        _selectedCountries = [NSArray arrayWithArray:countries];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) completeChoosingOrigins
//------------------------------------------------------------------------------------------------------------------------------
{
    [_delegate countryTableView:self didCompleteChoosingCountries:_selectedCountries];
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelChoosingOrigins
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
