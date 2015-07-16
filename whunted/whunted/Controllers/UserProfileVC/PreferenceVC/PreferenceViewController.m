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

#import <JTImageButton.h>

#define kTravellingToTag            0
#define kResidingCountryTag         1

#define kMaximumLines               10
#define kLeftRightMargin            30

#define kAddedTopBottomSpace        10

#define kTravellingToCountryList    @"travellingToCountryList"
#define kResidingCountryList        @"residingCountryList"

@interface PreferenceViewController ()

@end

@implementation PreferenceViewController
{
    UITableView     *_preferenceTableView;
    
    UITableViewCell *_travellingToCell;
    UITableViewCell *_residingCountryCel;
    UITableViewCell *_buyingHashTagCell;
    UITableViewCell *_sellingHashTagCell;
    
    NSArray         *_travellingToCountryList;
    NSArray         *_residingCountryList;
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
    _travellingToCountryList = [[NSUserDefaults standardUserDefaults] objectForKey:kTravellingToCountryList];
    NSString *text = [_travellingToCountryList componentsJoinedByString:@", "];
    
    _travellingToCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TravellingTo"];
    if (text.length > 0)
        _travellingToCell.textLabel.text = text;
    else
        _travellingToCell.textLabel.text = @"E.g. USA, Germany";
    _travellingToCell.textLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:17];
    _travellingToCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _travellingToCell.textLabel.numberOfLines = kMaximumLines;
    _travellingToCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initResidingCountryCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _residingCountryList = [[NSUserDefaults standardUserDefaults] objectForKey:kResidingCountryList];
    NSString *text = [_residingCountryList componentsJoinedByString:@", "];
    
    _residingCountryCel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ResidingCountry"];
    if (text.length > 0)
        _residingCountryCel.textLabel.text = text;
    else
        _residingCountryCel.textLabel.text = @"E.g. Taiwan";
    _residingCountryCel.textLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:17];
    _residingCountryCel.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _residingCountryCel.textLabel.numberOfLines = kMaximumLines;
    _residingCountryCel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initBuyingHashTagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _buyingHashTagCell = [[UITableViewCell alloc] init];
    _buyingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kTextFieldHeight = 35.0f;
    CGFloat const kTextFieldWidth = WINSIZE.width * 0.92;
    CGFloat const kTextFieldLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kTextFieldTopMargin = 10.0f;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldTopMargin, kTextFieldWidth, kTextFieldHeight)];
    textField.backgroundColor = LIGHTEST_GRAY_COLOR;
    textField.placeholder = NSLocalizedString(@"Enter a new hashtag", nil);
    textField.layer.cornerRadius = 10.0f;
    [_buyingHashTagCell addSubview:textField];
    
    // Add left padding
    CGFloat const kTextFieldLeftPadding = 10.0f;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeftPadding, kTextFieldHeight)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    // Add button to the right of the text field
    CGFloat const kButtonWidth = WINSIZE.width * 0.15;
    CGFloat const kXPos = kTextFieldWidth - kButtonWidth;
    JTImageButton *rightButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kXPos, 0, kButtonWidth, kTextFieldHeight)];
    [rightButton createTitle:@"Add" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:16] iconOffsetY:0];
    rightButton.cornerRadius = 10.0f;
    rightButton.bgColor = CLASSY_BLUE_COLOR;
    rightButton.borderColor = CLASSY_BLUE_COLOR;
    rightButton.titleColor = [UIColor whiteColor];
    textField.rightView = rightButton;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    // Add hashtag container
    CGFloat const kContainerTopMargin = 2.5f;
    CGFloat const kYPos = kTextFieldHeight + 2 * kTextFieldTopMargin + kContainerTopMargin;
    CGFloat const kContainerHeight = 80.0f;
    
    UIScrollView *hashtagContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kYPos, kTextFieldWidth, kContainerHeight)];
    hashtagContainer.backgroundColor = LIGHTEST_GRAY_COLOR;
    hashtagContainer.layer.cornerRadius = 10.0f;
    hashtagContainer.contentSize = CGSizeMake(kTextFieldWidth, kContainerHeight);
    [_buyingHashTagCell addSubview:hashtagContainer];
    
    [hashtagContainer addSubview:[self createHashtagViewWithText:@"gucci"]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSellingHashTagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _sellingHashTagCell = [[UITableViewCell alloc] init];
    _sellingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIView *) createHashtagViewWithText: (NSString *) hashtag
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *label = [[UILabel alloc] init];
    label.text = hashtag;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    label.backgroundColor = VIVID_SKY_BLUE_COLOR;
    [label sizeToFit];
    
    CGFloat const kLabelWidth = label.frame.size.width + 10.0f;
    CGFloat const kLabelHeight = label.frame.size.height + 2.0f;
    CGFloat const kLabelTopMargin = 10.0f;
    CGFloat const kLabelLeftMargin = 10.0f;
    label.frame = CGRectMake(0, 0, kLabelWidth, kLabelHeight);
    
    CGFloat const kButtonWidth = 15.0f;
    CGFloat const kButtonHeight = kLabelHeight;
    JTImageButton *deletionButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kLabelWidth, 0, kButtonWidth, kButtonHeight)];
    [deletionButton createTitle:@"x" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:16] iconOffsetY:0];
    deletionButton.titleColor = [UIColor whiteColor];
    deletionButton.borderColor = RED_ORAGNE_COLOR;
    deletionButton.bgColor = RED_ORAGNE_COLOR;
    deletionButton.cornerRadius = 0.0f;
    [deletionButton addTarget:self action:@selector(deletionButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelTopMargin, kLabelWidth + kButtonWidth, kLabelHeight)];
    container.layer.cornerRadius = 5.0f;
    container.clipsToBounds = YES;
    
    // add gradient to label
    CAGradientLayer *gradLayer=[CAGradientLayer layer];
    gradLayer.frame = container.layer.bounds;
    [gradLayer setColors:[NSArray arrayWithObjects:(id)([UIColor redColor].CGColor), (id)([UIColor cyanColor].CGColor),nil]];
    gradLayer.endPoint=CGPointMake(1.0, 0.0);
    [container.layer addSublayer:gradLayer];
    
    [container addSubview:label];
    [container addSubview:deletionButton];
    
    return container;
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
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0) {
        return [self heightForLabelWithText:_travellingToCell.textLabel.text withFont:_travellingToCell.textLabel.font andWidth:WINSIZE.width - 2 * kLeftRightMargin] + kAddedTopBottomSpace;
    } else if (indexPath.section == 1) {
        return [self heightForLabelWithText:_residingCountryCel.textLabel.text withFont:_travellingToCell.textLabel.font andWidth:WINSIZE.width - 2 * kLeftRightMargin] + kAddedTopBottomSpace;
    } else
        return 150.0f;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *) tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0) {
        CountryTableViewController *countryVC = [[CountryTableViewController alloc] initWithSelectedCountries:_travellingToCountryList];
        countryVC.delegate = self;
        countryVC.tag = kTravellingToTag;
        [self.navigationController pushViewController:countryVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1) {
        CountryTableViewController *countryVC = [[CountryTableViewController alloc] initWithSelectedCountries:_residingCountryList];
        countryVC.delegate = self;
        countryVC.tag = kResidingCountryTag;
        [self.navigationController pushViewController:countryVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Delegate Methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) countryTableView:(CountryTableViewController *)controller didCompleteChoosingCountries:(NSArray *)countries
//------------------------------------------------------------------------------------------------------------------------------
{
    if (controller.tag == kTravellingToTag) {
        _travellingToCountryList = [NSArray arrayWithArray:countries];
        [[NSUserDefaults standardUserDefaults] setObject:_travellingToCountryList forKey:kTravellingToCountryList];
        
        _travellingToCountryList = [[NSUserDefaults standardUserDefaults] objectForKey:kTravellingToCountryList];
        NSString *text = [_travellingToCountryList componentsJoinedByString:@", "];
        if (text.length > 0)
            _travellingToCell.textLabel.text = text;
        else
            _travellingToCell.textLabel.text = @"E.g. USA, Germany";
        
        [_preferenceTableView reloadData];
    } else if (controller.tag == kResidingCountryTag) {
        _residingCountryList = [NSArray arrayWithArray:countries];
        [[NSUserDefaults standardUserDefaults] setObject:_residingCountryList forKey:kResidingCountryList];
        
        _residingCountryList = [[NSUserDefaults standardUserDefaults] objectForKey:kResidingCountryList];
        NSString *text = [_residingCountryList componentsJoinedByString:@", "];
        if (text.length > 0)
            _residingCountryCel.textLabel.text = text;
        else
            _residingCountryCel.textLabel.text = @"E.g. Taiwan";
        
        [_preferenceTableView reloadData];
    }
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) deletionButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

#pragma mark - Helper functions

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) heightForLabelWithText: (NSString *) text withFont: (UIFont *) font andWidth: (CGFloat) width
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = kMaximumLines;
    [label sizeToFit];
    
    return label.frame.size.height;
}

@end
