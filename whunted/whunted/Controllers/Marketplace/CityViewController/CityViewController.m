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


@implementation CityViewController
{
    UILabel                 *_guidanceLabel;
    UITextField             *_cityTextField;
    
    UITableView             *_cityTableView;
    
    NSArray                 *_citiesAndCountriesListl;
    NSArray                 *_matchedCitiesAndCountriesList;
}

@synthesize isToSetProductOrigin    =   _isToSetProductOrigin;

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
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
        [Utilities customizeTitleLabel:NSLocalizedString(@"Buyer's City", nil) forViewController:self];
        
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
        _guidanceLabel.text = NSLocalizedString(@"Filter by buyer's city:", nil);
    
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
    CGFloat const kTableViewOriginY     =   _cityTextField.frame.origin.y + _cityTextField.frame.size.height;
    CGFloat const kTableViewWidth       =   _cityTextField.frame.size.width;
    CGFloat const kTableViewHeight      =   200.0f;
    
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(kTableViewOriginX, kTableViewOriginY, kTableViewWidth, kTableViewHeight)];
    _cityTableView.layer.borderWidth = 0.5f;
    _cityTableView.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    _cityTableView.layer.cornerRadius = 8.0f;
    _cityTableView.dataSource = self;
    _cityTableView.delegate = self;
    [self.view addSubview:_cityTableView];
}


#pragma mark - UITableViewDataSource methods

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 5;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
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
}


#pragma mark - UITextFieldDelegate methods

//-----------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//-----------------------------------------------------------------------------------------------------------------------------
{
    [textField resignFirstResponder];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

@end
