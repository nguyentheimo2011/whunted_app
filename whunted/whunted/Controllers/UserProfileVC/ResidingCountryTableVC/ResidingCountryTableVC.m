//
//  ResidingCountryTableVC.m
//  whunted
//
//  Created by thomas nguyen on 24/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ResidingCountryTableVC.h"
#import "AppConstant.h"
#import "Utilities.h"


@implementation ResidingCountryTableVC
{
    NSDictionary        *_countryDict;
}

@synthesize delegate = _delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    [self customizeNavigationBar];
    [self getCountryDict];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"ResidingCountryTableScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapEventHandler)];
    
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Data Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) getCountryDict
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CountryAndCityList" ofType:@"plist"];
    _countryDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
}


#pragma mark - UITableView Data Souce

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
    return [[_countryDict allKeys] count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellID = @"ResidingCountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [[_countryDict allKeys] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *selectedCountry = [[_countryDict allKeys] objectAtIndex:indexPath.row];
    NSArray *cityList = [_countryDict objectForKey:selectedCountry];
    
    ResidingCityTableVC *cityTableVC = [[ResidingCityTableVC alloc] initWithCountry:selectedCountry andCities:cityList];
    cityTableVC.delegate = _delegate;
    
    [self.navigationController pushViewController:cityTableVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
