//
//  CountryListVC.m
//  whunted
//
//  Created by thomas nguyen on 19/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "CountryListVC.h"
#import "Utilities.h"
#import "AppConstant.h"

@implementation CountryListVC
{
    UITableView             *_countriesTableView;
    
    NSDictionary            *_countriesAndCodesDict;
    NSArray                 *_availabelCountries;
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//---------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self loadUI];
}


#pragma mark - Data Initialization

//---------------------------------------------------------------------------------------------------------------------------
- (void) initData
//---------------------------------------------------------------------------------------------------------------------------
{
    _countriesAndCodesDict = @{@"Australia":@"+61", @"Belgium":@"+32", @"Canada":@"+1", @"China":@"+86", @"Czech Republic":@"+420", @"Denmark":@"+45", @"France":@"+33", @"Germany":@"+49", @"Hong Kong":@"+852", @"Italy":@"+39", @"Japan":@"+81", @"South Korea":@"+82", @"Macau":@"+853", @"Malaysia":@"+60", @"New Zealand":@"+64", @"Norway":@"+47", @"Singapore": @"+65", @"Spain":@"+34", @"Taiwan":@"+886", @"Thailand":@"+66", @"Turkey":@"+90", @"United Kingdom":@"+44", @"United States":@"+1"};
    
    _availabelCountries = [_countriesAndCodesDict allKeys];
    _availabelCountries = [_availabelCountries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


#pragma mark - UI Handler

//---------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//---------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Choose a country", nil) forViewController:self];
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topLeftBackButtonEventHandler)];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) loadUI
//---------------------------------------------------------------------------------------------------------------------------
{
    [self addCountriesTableView];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) addCountriesTableView
//---------------------------------------------------------------------------------------------------------------------------
{
    _countriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    _countriesTableView.dataSource = self;
    _countriesTableView.delegate = self;
    [self.view addSubview:_countriesTableView];
}


#pragma mark - Event Handler

//---------------------------------------------------------------------------------------------------------------------------
- (void) topLeftBackButtonEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDatasource methods

//---------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//---------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//---------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//---------------------------------------------------------------------------------------------------------------------------
{
    return _availabelCountries.count;
}

//---------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//---------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellID = @"CountryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _availabelCountries[indexPath.row];
    cell.textLabel.textColor = TEXT_COLOR_LESS_DARK;
    cell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

@end
