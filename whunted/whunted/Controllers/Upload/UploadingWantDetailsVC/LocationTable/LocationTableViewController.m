//
//  LocationTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LocationTableViewController.h"

@implementation LocationTableViewController
{
    NSArray             *_locationList;
    NSUInteger          _selectedIndex;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    
    [super viewDidLoad];
    
    _locationList = [NSArray arrayWithObjects:@"Changhua", @"Hualien", @"Magong", @"Taichung", @"Taipao", @"Taipei", @"Yilan", nil];
    _selectedIndex = [_locationList indexOfObject:self.location];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
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
    return [_locationList count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellID = @"LocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_locationList objectAtIndex:indexPath.row];
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
    NSString *selectedLocation = [_locationList objectAtIndex:indexPath.row];
    [self.delegate locationTableViewController:self didSelectLocation:selectedLocation];
}

@end
