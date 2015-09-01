//
//  CityViewController.m
//  whunted
//
//  Created by thomas nguyen on 31/8/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CityViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

#define     MAX_NUM_OF_MATCHES      20


@implementation CityViewController
{
    UILabel                 *_guidanceLabel;
    UITextField             *_cityTextField;
    
    UITableView             *_cityTableView;
    
    NSMutableArray          *_citiesAndCountriesList;
    NSArray                 *_matchedCitiesAndCountriesList;
    NSMutableArray          *_taiwaneseCountryAndCitiesList;
}

@synthesize delegate                =   _delegate;
@synthesize isToSetProductOrigin    =   _isToSetProductOrigin;

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self addGuidanceLabel];
    [self addTextField];
    [self addCityTable];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"CityViewController didReceiveMemoryWarning");
}


#pragma mark - Data Initialization

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initData
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self getCountriesToCitiesListFromJSONFile];
    [self matchCountriesAndCitiesWithText:@""];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) getCountriesToCitiesListFromJSONFile
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countriesToCities" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *countriesToCitiesDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *countries = [countriesToCitiesDict allKeys];
    _citiesAndCountriesList = [[NSMutableArray alloc] init];
    
    for (NSString *country in countries) {
        [_citiesAndCountriesList addObject:country];
        
        NSArray *cities = [countriesToCitiesDict objectForKey:country];
        for (NSString *city in cities) {
            NSString *newCity = [NSString stringWithFormat:@"%@, %@", city, country];
            [_citiesAndCountriesList addObject:newCity];
        }
    }
    
    NSArray *taiwaneseCities = [countriesToCitiesDict objectForKey:@"Taiwan"];
    _taiwaneseCountryAndCitiesList = [NSMutableArray array];
    [_taiwaneseCountryAndCitiesList addObject:@"Taiwan"];
    for (NSString *city in taiwaneseCities) {
        NSString *newCity = [NSString stringWithFormat:@"%@, Taiwan", city];
        [_taiwaneseCountryAndCitiesList addObject:newCity];
    }
}


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isToSetProductOrigin) {
        [Utilities customizeTitleLabel:NSLocalizedString(@"Product Origin", nil) forViewController:self];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelSortAndFilter)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Apply", nil) style:UIBarButtonItemStylePlain target:self action:@selector(applyNewSortingAndFilteringCriteria)];
    }
    else {
        [Utilities customizeTitleLabel:NSLocalizedString(@"Location", nil) forViewController:self];
        
        [Utilities customizeBackButtonForViewController:self withAction:@selector(backToPreviousView)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topDoneButtonTapEventHandler)];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addGuidanceLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelLeftMargin  =   WINSIZE.width/10.0f;
    CGFloat const kLabelTopMargin   =   [Utilities getHeightOfNavigationAndStatusBars:self] + 10.0f;
    CGFloat const kLabelWidth       =   WINSIZE.width - 2 * kLabelLeftMargin;
    CGFloat const kLabelHeight      =   20.0f;
    
    _guidanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelTopMargin, kLabelWidth, kLabelHeight)];
    
    if (_isToSetProductOrigin)
        _guidanceLabel.text = NSLocalizedString(@"Product origin:", nil);
    else
        _guidanceLabel.text = NSLocalizedString(@"Filter by buyer's location:", nil);
    
    _guidanceLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _guidanceLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [self.view addSubview:_guidanceLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addTextField
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextFieldLeftMargin  =   WINSIZE.width/10.0f;
    CGFloat const kTextFieldTopMargin   =   10.0f;
    CGFloat const kTextFieldOriginY     =   _guidanceLabel.frame.origin.y + _guidanceLabel.frame.size.height + kTextFieldTopMargin;
    CGFloat const kTextFieldWidth       =   WINSIZE.width - 2 * kTextFieldLeftMargin;
    CGFloat const kTextFieldHeight      =   40.0f;
    
    _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldOriginY, kTextFieldWidth, kTextFieldHeight)];
    _cityTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _cityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Enter city", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]}];
    _cityTextField.returnKeyType = UIReturnKeyDone;
    _cityTextField.layer.borderWidth = 0.5f;
    _cityTextField.layer.borderColor = [TEXT_COLOR_DARK_GRAY CGColor];
    _cityTextField.layer.cornerRadius = 8.0f;
    _cityTextField.delegate = self;
    [Utilities customizeTextField:_cityTextField];
    [self.view addSubview:_cityTextField];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addCityTable
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableViewOriginX     =   _cityTextField.frame.origin.x;
    CGFloat const kTableViewOriginY     =   _cityTextField.frame.origin.y + _cityTextField.frame.size.height + 5.0f;
    CGFloat const kTableViewWidth       =   _cityTextField.frame.size.width;
    CGFloat const kTableViewHeight      =   200.0f;
    
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(kTableViewOriginX, kTableViewOriginY, kTableViewWidth, kTableViewHeight)];
    _cityTableView.layer.borderWidth = 0.5f;
    _cityTableView.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    _cityTableView.layer.cornerRadius = 8.0f;
    _cityTableView.dataSource = self;
    _cityTableView.delegate = self;
    [self.view addSubview:_cityTableView];
    
    _cityTableView.hidden = YES;
}


#pragma mark - UITableViewDataSource methods

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return _matchedCitiesAndCountriesList.count;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *cellID = @"CountryAndCityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_matchedCitiesAndCountriesList objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 40.0f;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _cityTextField.text = [_matchedCitiesAndCountriesList objectAtIndex:indexPath.row];
    _cityTableView.hidden = YES;
    [_cityTextField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    _cityTableView.hidden = YES;
    [textField resignFirstResponder];
    
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *adjustedString = [Utilities getResultantStringFromText:textField.text andRange:range andReplacementString:string];
    [self matchCountriesAndCitiesWithText:adjustedString];
    [_cityTableView reloadData];
    
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    _cityTableView.hidden = NO;
    
    return YES;
}


#pragma mark - Event Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) cancelSortAndFilter
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) applyNewSortingAndFilteringCriteria
//-----------------------------------------------------------------------------------------------------------------------------
{
    [_delegate cityView:self didSpecifyLocation:_cityTextField.text];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) backToPreviousView
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) topDoneButtonTapEventHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [_delegate cityView:self didSpecifyLocation:_cityTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) matchCountriesAndCitiesWithText: (NSString *) typedText
//-----------------------------------------------------------------------------------------------------------------------------
{
    if (typedText.length == 0) {
        _matchedCitiesAndCountriesList = [_taiwaneseCountryAndCitiesList subarrayWithRange:NSMakeRange(0, MAX_NUM_OF_MATCHES)];
    } else {
        NSString *filter = @"SELF BEGINSWITH[cd] %@";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filter, typedText];
        
        _matchedCitiesAndCountriesList = [_citiesAndCountriesList filteredArrayUsingPredicate:predicate];
        
        if (_matchedCitiesAndCountriesList.count > MAX_NUM_OF_MATCHES)
            _matchedCitiesAndCountriesList = [_matchedCitiesAndCountriesList subarrayWithRange:NSMakeRange(0, MAX_NUM_OF_MATCHES)];
    }
}

@end
