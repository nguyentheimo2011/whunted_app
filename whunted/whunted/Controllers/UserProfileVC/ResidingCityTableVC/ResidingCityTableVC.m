//
//  ResidingCityTableVC.m
//  whunted
//
//  Created by thomas nguyen on 27/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ResidingCityTableVC.h"
#import "AppConstant.h"

@interface ResidingCityTableVC ()

@end

@implementation ResidingCityTableVC

@synthesize countryName = _countryName;
@synthesize  cityList = _cityList;
@synthesize delegate = _delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithCountry: (NSString *) country andCities: (NSArray *) cityList
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self) {
        _countryName = country;
        _cityList = cityList;
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeNavigationBar];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapEventHandler)];
    
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Table view data source

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_cityList count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellID = @"ResidingCityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_cityList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
        
    return cell;
}

#pragma mark - UITableView Delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *selectedCity = [_cityList objectAtIndex:indexPath.row];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_countryName, USER_PROFILE_USER_COUNTRY, selectedCity, USER_PROFILE_USER_CITY, nil];
    [_delegate residingCity:self didSelectCity:dict];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popToViewController:_delegate animated:YES];
}

#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
