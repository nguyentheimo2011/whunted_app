//
//  ProductOriginTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ProductOriginTableViewController.h"

@interface ProductOriginTableViewController ()

@end

@implementation ProductOriginTableViewController
{
    NSArray             *_fullCountryList;
}

@synthesize selectedOrigins;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithSelectedOrigins: (NSArray *) origins
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        selectedOrigins = [NSArray arrayWithArray:origins];
        [self getCountryList];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

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
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *country = [_fullCountryList objectAtIndex:indexPath.row];
    if ([selectedOrigins containsObject:country]) {
        NSMutableArray *_selectedCountries = [NSMutableArray arrayWithArray:selectedOrigins];
        [_selectedCountries removeObject:country];
        selectedOrigins = [NSArray arrayWithArray:_selectedCountries];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        NSMutableArray *_selectedCountries = [NSMutableArray arrayWithArray:selectedOrigins];
        [_selectedCountries addObject:country];
        selectedOrigins = [NSArray arrayWithArray:_selectedCountries];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
