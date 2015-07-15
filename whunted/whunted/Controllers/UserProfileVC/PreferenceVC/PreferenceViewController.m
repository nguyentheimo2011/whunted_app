//
//  PreferenceViewController.m
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "PreferenceViewController.h"
#import "Utilities.h"
#import "AppConstant.h"

@interface PreferenceViewController ()

@end

@implementation PreferenceViewController
{
    UITableView     *_preferenceTableView;
    
    UITableViewCell *_travellingToCell;
    UITableViewCell *_residingCountryCel;
    UITableViewCell *_buyingHashTagCell;
    UITableViewCell *_sellingHashTagCell;
    
    NSMutableArray  *_travellingToCountryList;
    NSMutableArray  *_residingCountryList;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self addPreferenceTableView];
    [self initCells];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"PreferenceViewController didReceiveMemoryWarning");
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Utilities customizeTitleLabel:@"Preferences" forViewController:self];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:17]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:TEXT_COLOR_DARK_GRAY];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferenceTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    _preferenceTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _preferenceTableView.delegate = self;
    _preferenceTableView.dataSource = self;
    _preferenceTableView.backgroundColor = LIGHTEST_GRAY_COLOR;
    [self.view addSubview:_preferenceTableView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//------------------------------------------------------------------------------------------------------------------------------
{
    [self initTravellingToCell];
    [self initResidingCountryCell];
    [self initBuyingHashTagCell];
    [self initSellingHashTagCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initTravellingToCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _travellingToCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TravellingTo"];
    _travellingToCell.textLabel.text = @"E.g. USA, Germany";
    _travellingToCell.textLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    _travellingToCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initResidingCountryCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _residingCountryCel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ResidingCountry"];
    _residingCountryCel.textLabel.text = @"E.g. Taiwan";
    _residingCountryCel.textLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    _residingCountryCel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initBuyingHashTagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _buyingHashTagCell = [[UITableViewCell alloc] init];
    _buyingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSellingHashTagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _sellingHashTagCell = [[UITableViewCell alloc] init];
    _sellingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UITableView Datasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    return 4;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
        return _travellingToCell;
    else if (indexPath.section == 1)
        return _residingCountryCel;
    else if (indexPath.section == 2)
        return _buyingHashTagCell;
    else
        return _sellingHashTagCell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return NSLocalizedString(@"Where are you travelling to?", nil);
    else if (section == 1)
        return NSLocalizedString(@"Where are you residing at?", nil);
    else if (section == 2)
        return NSLocalizedString(@"What do you like to buy?", nil);
    else if (section == 3)
        return NSLocalizedString(@"What do you like to sell?", nil);
    else
        return @"";
}

#pragma mark - UITableView delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 0.01f;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 40.0f;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}


@end
