//
//  PreferenceViewController.m
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PreferenceViewController.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>
#import "IGLDropDownMenu.h"

#define kTravellingToTag            0
#define kResidingCountryTag         1

#define kMaximumLines               10
#define kLeftRightMargin            30

#define kAddedTopBottomSpace        10

#define kTravellingToCountryList        @"travellingToCountryList"
#define kResidingCountryList            @"residingCountryList"
#define kBuyingPreferenceHashtagList    @"buyingPreferenceHashtagList"
#define kSellingPreferenceHashtagList   @"sellingPreferenceHashtagList"

@interface PreferenceViewController ()

@end

@implementation PreferenceViewController
{
    UITableView     *_preferenceTableView;
    
    UITableViewCell *_travellingToCell;
    UITableViewCell *_residingCountryCel;
    UITableViewCell *_buyingHashTagCell;
    UITableViewCell *_sellingHashTagCell;
    
    UITextField     *_buyingHashtagTextField;
    UITextField     *_sellingHashtagTextField;
    UIScrollView    *_buyingHashtagContainer;
    UIScrollView    *_sellingHashtagContainer;
    
    NSArray         *_travellingToCountryList;
    NSArray         *_residingCountryList;
    
    NSMutableArray  *_buyingPreferenceHashtagList;
    NSMutableArray  *_sellingPreferenceHashtagList;
    
    CGRect          _lastHashtagFrame;
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
    _buyingPreferenceHashtagList = [NSMutableArray array];
    _sellingPreferenceHashtagList = [NSMutableArray array];
    
    [self initTravellingToCell];
    [self initResidingCountryCell];
    [self initBuyingHashtagCell];
    [self initSellingHashtagCell];
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
- (void) initBuyingHashtagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _buyingHashTagCell = [[UITableViewCell alloc] init];
    _buyingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // add text field
    CGFloat const kTextFieldHeight = 35.0f;
    CGFloat const kTextFieldWidth = WINSIZE.width * 0.76;
    CGFloat const kTextFieldLeftMargin = WINSIZE.width * 0.2;
    CGFloat const kTextFieldTopMargin = 10.0f;
    
    _buyingHashtagTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldTopMargin, kTextFieldWidth, kTextFieldHeight)];
    _buyingHashtagTextField.placeholder = NSLocalizedString(@"Enter a new hashtag", nil);
    _buyingHashtagTextField.layer.cornerRadius = 10.0f;
    _buyingHashtagTextField.layer.borderColor = [COLUMBIA_BLUE_COLOR CGColor];
    _buyingHashtagTextField.layer.borderWidth = 1.0f;
    _buyingHashtagTextField.layer.masksToBounds = YES;
    _buyingHashtagTextField.returnKeyType = UIReturnKeyDone;
    _buyingHashtagTextField.delegate = self;
    [_buyingHashTagCell addSubview:_buyingHashtagTextField];
    
    // Add left padding
    CGFloat const kLeftPaddingWidth = 10.0f;
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftPaddingWidth, kTextFieldHeight)];
    _buyingHashtagTextField.leftView = leftPadding;
    _buyingHashtagTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // Add button to the right of the text field
    CGFloat const kButtonWidth = WINSIZE.width * 0.12;
    CGFloat const kXPos = kTextFieldWidth - kButtonWidth;
    JTImageButton *rightButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kXPos, 0, kButtonWidth, kTextFieldHeight)];
    [rightButton createTitle:@" + " withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:20] iconOffsetY:0];
    rightButton.cornerRadius = 10.0f;
    rightButton.bgColor = PICTON_BLUE_COLOR;
    rightButton.borderColor = PICTON_BLUE_COLOR;
    rightButton.titleColor = [UIColor whiteColor];
    [rightButton addTarget:self action:@selector(hashtagAddingButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    _buyingHashtagTextField.rightView = rightButton;
    _buyingHashtagTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // Add hashtag container
    CGFloat const kContainerTopMargin = 2.5f;
    CGFloat const kContainerLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kYPos = kTextFieldHeight + 2 * kTextFieldTopMargin + kContainerTopMargin;
    CGFloat const kContainerHeight = 80.0f;
    CGFloat const kContainerWidth = WINSIZE.width * 0.92;
    
    _buyingHashtagContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(kContainerLeftMargin, kYPos, kContainerWidth, kContainerHeight)];
    _buyingHashtagContainer.backgroundColor = LIGHTEST_GRAY_COLOR;
    _buyingHashtagContainer.layer.cornerRadius = 10.0f;
    _buyingHashtagContainer.contentSize = CGSizeMake(kTextFieldWidth, kContainerHeight);
    [_buyingHashTagCell addSubview:_buyingHashtagContainer];
    
    // Add drop down list of brand and model
    NSArray *dataArray = @[@{@"title":NSLocalizedString(kItemDetailBrand, nil)},
                           @{@"title":NSLocalizedString(kItemDetailModel, nil)}];
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"] withFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
        [dropdownItems addObject:item];
    }
    
    CGFloat const kDropDownMenuLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kDropDownMenuWidth = WINSIZE.width * 0.14;
    
    IGLDropDownMenu *dropDownMenu = [[IGLDropDownMenu alloc] init];
    dropDownMenu.textFont = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    dropDownMenu.menuText = NSLocalizedString(kItemDetailSelect, nil);
    dropDownMenu.dropDownItems = dropdownItems;
    dropDownMenu.paddingLeft = 2.0f;
    [dropDownMenu setFrame:CGRectMake(kDropDownMenuLeftMargin, kTextFieldTopMargin, kDropDownMenuWidth, kTextFieldHeight)];
    
    dropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
    dropDownMenu.flipWhenToggleView = YES;
    [dropDownMenu reloadView];
    
    [_buyingHashTagCell addSubview:dropDownMenu];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSellingHashtagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _sellingHashTagCell = [[UITableViewCell alloc] init];
    _sellingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kTextFieldHeight = 35.0f;
    CGFloat const kTextFieldWidth = WINSIZE.width * 0.92;
    CGFloat const kTextFieldLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kTextFieldTopMargin = 10.0f;
    
    _sellingHashtagTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldTopMargin, kTextFieldWidth, kTextFieldHeight)];
    _sellingHashtagTextField.placeholder = NSLocalizedString(@"Enter a new hashtag", nil);
    _sellingHashtagTextField.layer.cornerRadius = 10.0f;
    _sellingHashtagTextField.layer.borderColor = [COLUMBIA_BLUE_COLOR CGColor];
    _sellingHashtagTextField.layer.borderWidth = 1.0f;
    _sellingHashtagTextField.returnKeyType = UIReturnKeyDone;
    _sellingHashtagTextField.delegate = self;
    [_sellingHashTagCell addSubview:_sellingHashtagTextField];
    
    // Add left padding
    CGFloat const kTextFieldLeftPadding = 10.0f;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeftPadding, kTextFieldHeight)];
    _sellingHashtagTextField.leftView = paddingView;
    _sellingHashtagTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // Add button to the right of the text field
    CGFloat const kButtonWidth = WINSIZE.width * 0.12;
    CGFloat const kXPos = kTextFieldWidth - kButtonWidth;
    JTImageButton *rightButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kXPos, 0, kButtonWidth, kTextFieldHeight)];
    [rightButton createTitle:@" + " withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:20] iconOffsetY:0];
    rightButton.cornerRadius = 10.0f;
    rightButton.bgColor = PICTON_BLUE_COLOR;
    rightButton.borderColor = PICTON_BLUE_COLOR;
    rightButton.titleColor = [UIColor whiteColor];
    [rightButton addTarget:self action:@selector(hashtagAddingButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    _sellingHashtagTextField.rightView = rightButton;
    _sellingHashtagTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // Add hashtag container
    CGFloat const kContainerTopMargin = 2.5f;
    CGFloat const kYPos = kTextFieldHeight + 2 * kTextFieldTopMargin + kContainerTopMargin;
    CGFloat const kContainerHeight = 80.0f;
    
    _sellingHashtagContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kYPos, kTextFieldWidth, kContainerHeight)];
    _sellingHashtagContainer.backgroundColor = LIGHTEST_GRAY_COLOR;
    _sellingHashtagContainer.layer.cornerRadius = 10.0f;
    _sellingHashtagContainer.contentSize = CGSizeMake(kTextFieldWidth, kContainerHeight);
    [_sellingHashTagCell addSubview:_sellingHashtagContainer];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIView *) createHashtagViewWithText: (NSString *) hashtag withTag: (NSInteger) tag
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *label = [[UILabel alloc] init];
    label.text = hashtag;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    label.backgroundColor = VIVID_SKY_BLUE_COLOR;
    [label sizeToFit];
    
    CGFloat kLabelWidth = label.frame.size.width + 10.0f;
    CGFloat const kLabelHeight = label.frame.size.height + 2.0f;
    CGFloat const kLabelLeftMargin = 10.0f;
    CGFloat const kButtonWidth = 15.0f;
    CGFloat const kButtonHeight = kLabelHeight;
    CGFloat const kHashtagContainerWidth = _buyingHashtagContainer.frame.size.width;
    
    if (kLabelWidth < kHashtagContainerWidth - 2 * kLabelLeftMargin - kButtonHeight)
        label.frame = CGRectMake(0, 0, kLabelWidth, kLabelHeight);
    else {
        kLabelWidth = kHashtagContainerWidth - 2 * kLabelLeftMargin - kButtonHeight;
        label.frame = CGRectMake(0, 0, kLabelWidth, kLabelHeight);
    }
    
    JTImageButton *deletionButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kLabelWidth, 0, kButtonWidth, kButtonHeight)];
    [deletionButton createTitle:@"x" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:16] iconOffsetY:0];
    deletionButton.titleColor = [UIColor whiteColor];
    deletionButton.borderColor = RED_ORAGNE_COLOR;
    deletionButton.bgColor = RED_ORAGNE_COLOR;
    deletionButton.cornerRadius = 0.0f;
    deletionButton.tag = tag;
    [deletionButton addTarget:self action:@selector(deletionButtonTapEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *hashTagContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth + kButtonWidth, kLabelHeight)];
    hashTagContainer.layer.cornerRadius = 5.0f;
    hashTagContainer.clipsToBounds = YES;
    
    // add gradient to label
    CAGradientLayer *gradLayer=[CAGradientLayer layer];
    gradLayer.frame = hashTagContainer.layer.bounds;
    [gradLayer setColors:[NSArray arrayWithObjects:(id)([UIColor redColor].CGColor), (id)([UIColor cyanColor].CGColor),nil]];
    gradLayer.endPoint=CGPointMake(1.0, 0.0);
    [hashTagContainer.layer addSublayer:gradLayer];
    
    [hashTagContainer addSubview:label];
    [hashTagContainer addSubview:deletionButton];
    hashTagContainer.tag = tag;
    
    return hashTagContainer;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addANewHashtagForBuying: (NSString *) hashtag
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *hashtagView = [self createHashtagViewWithText:hashtag withTag:[_buyingPreferenceHashtagList count] + 1];
    CGSize hashtagViewSize = hashtagView.frame.size;
    CGPoint hashtagViewPos = [self calculatePositionForHashtagView:hashtagView];
    hashtagView.frame = CGRectMake(hashtagViewPos.x, hashtagViewPos.y, hashtagViewSize.width, hashtagViewSize.height);
    [_buyingHashtagContainer addSubview:hashtagView];
    
    [_buyingPreferenceHashtagList addObject:hashtag];
    
    _lastHashtagFrame = CGRectMake(hashtagViewPos.x, hashtagViewPos.y, hashtagViewSize.width, hashtagViewSize.height);
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGPoint) calculatePositionForHashtagView: (UIView *) hashtagView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelTopMargin = 10.0f;
    CGFloat const kLabelBottomMargin = 10.0f;
    CGFloat const kLabelLeftMargin = 10.0f;
    CGFloat const kLabelRightMargin = 2.0f;
    
    NSUInteger lastTag = [_buyingPreferenceHashtagList count];
    
    if (lastTag == 0) {
        return CGPointMake(kLabelLeftMargin, kLabelTopMargin);
    } else {
        CGSize hashtagViewSize = hashtagView.frame.size;
        CGSize hashtagContainerSize = _buyingHashtagContainer.frame.size;
        CGFloat nextXPos = _lastHashtagFrame.origin.x + _lastHashtagFrame.size.width + kLabelLeftMargin + hashtagViewSize.width + kLabelRightMargin;
        if (nextXPos > hashtagContainerSize.width) {
            CGFloat newContainerHeight = _lastHashtagFrame.origin.y + _lastHashtagFrame.size.height + kLabelTopMargin + hashtagViewSize.height + kLabelBottomMargin;
            if (newContainerHeight > hashtagContainerSize.height) {
                [_buyingHashtagContainer setContentSize:CGSizeMake(hashtagContainerSize.width, newContainerHeight)];
                [Utilities scrollToBottom:_buyingHashtagContainer];
            }
            return CGPointMake(kLabelLeftMargin, _lastHashtagFrame.origin.y + _lastHashtagFrame.size.height + kLabelTopMargin);
        } else {
            return CGPointMake(_lastHashtagFrame.origin.x + _lastHashtagFrame.size.width + kLabelLeftMargin, _lastHashtagFrame.origin.y);
        }
    }
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
//------------------------------------------------------------------------------------------------------------------------------
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

#pragma mark - UITextField Delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{    
    [textField resignFirstResponder];
    
    if (textField.text.length > 0) {
        [self addANewHashtagForBuying:textField.text];
        textField.text = @"";
    }
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *kWhiteSpace = @" ";
    if ([string isEqualToString:kWhiteSpace]) {
        if (textField.text.length > 0) {
            [self addANewHashtagForBuying:textField.text];
            textField.text = @"";
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) deletionButtonTapEventHandler: (UIButton *) button
//------------------------------------------------------------------------------------------------------------------------------
{
    for (int i=1; i <= _buyingPreferenceHashtagList.count; i++) {
        UIView *view = [_buyingHashtagContainer viewWithTag:i];
        [view removeFromSuperview];
    }
    
    [_buyingPreferenceHashtagList removeObjectAtIndex:button.tag - 1];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_buyingPreferenceHashtagList];
    _buyingPreferenceHashtagList = [NSMutableArray array];
    
    [_buyingHashtagContainer setContentSize:_buyingHashtagContainer.frame.size];
    
    for (int i=0; i < tempArray.count; i++) {
        [self addANewHashtagForBuying:[tempArray objectAtIndex:i]];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) hashtagAddingButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_buyingHashtagTextField.text.length > 0) {
        [self addANewHashtagForBuying:_buyingHashtagTextField.text];
        _buyingHashtagTextField.text = @"";
    }
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
