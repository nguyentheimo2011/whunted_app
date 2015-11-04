//
//  PreferenceViewController.m
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PreferenceViewController.h"
#import "HashtagData.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>

#define kTravellingToTag                0
#define kResidingCountryTag             1

#define kMaximumLines                   10
#define kLeftRightMargin                30

#define kAddedTopBottomSpace            10

#define kBuyingDropDownMenuTag          101
#define kSellingDropDownMenuTag         102
#define kBuyingTextFieldTag             103
#define kSellingTextFieldTag            104
#define kBuyingAddingButtonTag          105
#define kSellingAddingButtonTag         106
#define kBuyingDeletionButtonTag        107
#define kSellingDeletionButtonTag       108

#define kTravellingToCountryList        @"travellingToCountryList"
#define kResidingCountryList            @"residingCountryList"
#define kBuyingPreferenceHashtagList    @"buyingPreferenceHashtagList"
#define kSellingPreferenceHashtagList   @"sellingPreferenceHashtagList"


@implementation PreferenceViewController
{
    UITableView         *_preferenceTableView;
    
    UITableViewCell     *_travellingToCell;
    UITableViewCell     *_residingCountryCel;
    UITableViewCell     *_buyingHashTagCell;
    UITableViewCell     *_sellingHashTagCell;
    
    UITextField         *_buyingHashtagTextField;
    UITextField         *_sellingHashtagTextField;
    UIScrollView        *_buyingHashtagContainer;
    UIScrollView        *_sellingHashtagContainer;
    
    IGLDropDownMenu     *_buyingDropDownMenu;
    IGLDropDownMenu     *_sellingDropDownMenu;
    
    NSArray             *_travellingToCountryList;
    NSArray             *_residingCountryList;
    
    NSMutableArray      *_buyingPreferenceHashtagList;
    NSMutableArray      *_sellingPreferenceHashtagList;
    
    CGRect              _lastBuyingHashtagFrame;
    CGRect              _lastSellingHashtagFrame;
    
    BOOL                _isExpandingContentSize;
    NSInteger           _currTextFieldTag;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [self registerNotification];
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"PreferenceScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillDisappear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillDisappear:animated];
    
    [self deregisterNotification];
    
    [self saveData];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self addPreferenceTableView];
    [self initCells];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    [Utilities logOutMessage:@"PreferenceViewController didReceiveMemoryWarning"];
}


#pragma mark - Notification Registration

//------------------------------------------------------------------------------------------------------------------------------
- (void) registerNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) deregisterNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - Data Initialization

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _buyingPreferenceHashtagList = [NSMutableArray array];
    _sellingPreferenceHashtagList = [NSMutableArray array];
    _isExpandingContentSize = NO;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) saveData
//------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableArray *tempBuyingList = [[NSMutableArray alloc] init];
    for (HashtagData *hashtagData in _buyingPreferenceHashtagList)
        [tempBuyingList addObject:[hashtagData toDict]];
    [[NSUserDefaults standardUserDefaults] setObject:tempBuyingList forKey:kBuyingPreferenceHashtagList];
    
    NSMutableArray *tempSellingList = [[NSMutableArray alloc] init];
    for (HashtagData *hashtagData in _sellingPreferenceHashtagList)
        [tempSellingList addObject:[hashtagData toDict]];
    [[NSUserDefaults standardUserDefaults] setObject:tempSellingList forKey:kSellingPreferenceHashtagList];
}


#pragma mark - UI

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Preferences", nil) forViewController:self];
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
    
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
    _preferenceTableView.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_1;
    [self.view addSubview:_preferenceTableView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//------------------------------------------------------------------------------------------------------------------------------
{
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
    _travellingToCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
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
    _residingCountryCel.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
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
    CGFloat const kTextFieldWidth = WINSIZE.width * 0.72;
    CGFloat const kTextFieldLeftMargin = WINSIZE.width * 0.24;
    CGFloat const kTextFieldTopMargin = 10.0f;
    
    _buyingHashtagTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldTopMargin, kTextFieldWidth, kTextFieldHeight)];
    _buyingHashtagTextField.placeholder = NSLocalizedString(@"Enter brand or model", nil);
    _buyingHashtagTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    _buyingHashtagTextField.layer.cornerRadius = 10.0f;
    _buyingHashtagTextField.layer.borderColor = [COLUMBIA_BLUE_COLOR CGColor];
    _buyingHashtagTextField.layer.borderWidth = 1.0f;
    _buyingHashtagTextField.layer.masksToBounds = YES;
    _buyingHashtagTextField.returnKeyType = UIReturnKeyDone;
    _buyingHashtagTextField.tag = kBuyingTextFieldTag;
    _buyingHashtagTextField.delegate = self;
    [_buyingHashTagCell addSubview:_buyingHashtagTextField];
    
    // Add left padding
    [Utilities addLeftPaddingToTextField:_buyingHashtagTextField];
    
    // Add button to the right of the text field
    CGFloat const kButtonWidth = WINSIZE.width * 0.12;
    CGFloat const kXPos = kTextFieldWidth - kButtonWidth;
    JTImageButton *rightButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kXPos, 0, kButtonWidth, kTextFieldHeight)];
    [rightButton createTitle:@" + " withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:20] iconOffsetY:0];
    rightButton.cornerRadius = 10.0f;
    rightButton.bgColor = PICTON_BLUE_COLOR;
    rightButton.borderColor = PICTON_BLUE_COLOR;
    rightButton.titleColor = [UIColor whiteColor];
    rightButton.tag = kBuyingAddingButtonTag;
    [rightButton addTarget:self action:@selector(hashtagAddingButtonTapEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    _buyingHashtagTextField.rightView = rightButton;
    _buyingHashtagTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // Add hashtag container
    CGFloat const kContainerTopMargin = 2.5f;
    CGFloat const kContainerLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kYPos = kTextFieldHeight + 2 * kTextFieldTopMargin + kContainerTopMargin;
    CGFloat const kContainerHeight = 80.0f;
    CGFloat const kContainerWidth = WINSIZE.width * 0.92;
    
    _buyingHashtagContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(kContainerLeftMargin, kYPos, kContainerWidth, kContainerHeight)];
    _buyingHashtagContainer.layer.cornerRadius = 10.0f;
    _buyingHashtagContainer.layer.borderWidth = 0.5f;
    _buyingHashtagContainer.layer.borderColor = [GRAY_COLOR_WITH_WHITE_COLOR_7 CGColor];
    _buyingHashtagContainer.contentSize = CGSizeMake(kTextFieldWidth, kContainerHeight);
    [_buyingHashTagCell addSubview:_buyingHashtagContainer];
    
    // Add drop down list of brand and model
    NSArray *dataArray = @[@{@"title":NSLocalizedString(kItemDetailBrand, nil)},
                           @{@"title":NSLocalizedString(kItemDetailModel, nil)}];
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"] withFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
        [dropdownItems addObject:item];
    }
    
    CGFloat const kDropDownMenuLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kDropDownMenuWidth = WINSIZE.width * 0.18;
    
    _buyingDropDownMenu = [[IGLDropDownMenu alloc] init];
    _buyingDropDownMenu.textFont = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    _buyingDropDownMenu.menuText = NSLocalizedString(kItemDetailSelect, nil);
    _buyingDropDownMenu.dropDownItems = dropdownItems;
    _buyingDropDownMenu.paddingLeft = (kDropDownMenuWidth - [Utilities widthOfText:kItemDetailSelect withFont:DEFAULT_FONT andMaxWidth:WINSIZE.width])/2;
    [_buyingDropDownMenu setFrame:CGRectMake(kDropDownMenuLeftMargin, kTextFieldTopMargin, kDropDownMenuWidth, kTextFieldHeight)];
    
    _buyingDropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
    _buyingDropDownMenu.flipWhenToggleView = YES;
    _buyingDropDownMenu.tag = kBuyingDropDownMenuTag;
    _buyingDropDownMenu.delegate = self;
    [_buyingDropDownMenu reloadView];
    
    [_buyingHashTagCell addSubview:_buyingDropDownMenu];
    
    // add current hashtag to hashtag container
    NSArray *tempBuyingDictList = [[NSUserDefaults standardUserDefaults] objectForKey:kBuyingPreferenceHashtagList];
    NSMutableArray *tempBuyingDataList = [NSMutableArray array];
    for (NSDictionary *dict in tempBuyingDictList)
        [tempBuyingDataList addObject:[[HashtagData alloc] initWithDict:dict]];
    
    for (int i=0; i < tempBuyingDataList.count; i++) {
        HashtagData *data = [tempBuyingDataList objectAtIndex:i];
        [self addANewHashtagForBuying:data];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSellingHashtagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _sellingHashTagCell = [[UITableViewCell alloc] init];
    _sellingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _sellingHashTagCell = [[UITableViewCell alloc] init];
    _sellingHashTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // add text field
    CGFloat const kTextFieldHeight = 35.0f;
    CGFloat const kTextFieldWidth = WINSIZE.width * 0.72;
    CGFloat const kTextFieldLeftMargin = WINSIZE.width * 0.24;
    CGFloat const kTextFieldTopMargin = 10.0f;
    
    _sellingHashtagTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldTopMargin, kTextFieldWidth, kTextFieldHeight)];
    _sellingHashtagTextField.placeholder = NSLocalizedString(@"Enter brand or model", nil);
    _sellingHashtagTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    _sellingHashtagTextField.layer.cornerRadius = 10.0f;
    _sellingHashtagTextField.layer.borderColor = [COLUMBIA_BLUE_COLOR CGColor];
    _sellingHashtagTextField.layer.borderWidth = 1.0f;
    _sellingHashtagTextField.layer.masksToBounds = YES;
    _sellingHashtagTextField.returnKeyType = UIReturnKeyDone;
    _sellingHashtagTextField.tag = kSellingTextFieldTag;
    _sellingHashtagTextField.delegate = self;
    [_sellingHashTagCell addSubview:_sellingHashtagTextField];
    
    // Add left padding
    [Utilities addLeftPaddingToTextField:_sellingHashtagTextField];
    
    // Add button to the right of the text field
    CGFloat const kButtonWidth = WINSIZE.width * 0.12;
    CGFloat const kXPos = kTextFieldWidth - kButtonWidth;
    JTImageButton *rightButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kXPos, 0, kButtonWidth, kTextFieldHeight)];
    [rightButton createTitle:@" + " withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:20] iconOffsetY:0];
    rightButton.cornerRadius = 10.0f;
    rightButton.bgColor = PICTON_BLUE_COLOR;
    rightButton.borderColor = PICTON_BLUE_COLOR;
    rightButton.titleColor = [UIColor whiteColor];
    rightButton.tag = kSellingAddingButtonTag;
    [rightButton addTarget:self action:@selector(hashtagAddingButtonTapEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    _sellingHashtagTextField.rightView = rightButton;
    _sellingHashtagTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // Add hashtag container
    CGFloat const kContainerTopMargin = 2.5f;
    CGFloat const kContainerLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kYPos = kTextFieldHeight + 2 * kTextFieldTopMargin + kContainerTopMargin;
    CGFloat const kContainerHeight = 80.0f;
    CGFloat const kContainerWidth = WINSIZE.width * 0.92;
    
    _sellingHashtagContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(kContainerLeftMargin, kYPos, kContainerWidth, kContainerHeight)];
    _sellingHashtagContainer.layer.cornerRadius = 10.0f;
    _sellingHashtagContainer.layer.borderWidth = 0.5f;
    _sellingHashtagContainer.layer.borderColor = [GRAY_COLOR_WITH_WHITE_COLOR_7 CGColor];
    _sellingHashtagContainer.contentSize = CGSizeMake(kTextFieldWidth, kContainerHeight);
    [_sellingHashTagCell addSubview:_sellingHashtagContainer];
    
    // Add drop down list of brand and model
    NSArray *dataArray = @[@{@"title":NSLocalizedString(kItemDetailBrand, nil)},
                           @{@"title":NSLocalizedString(kItemDetailModel, nil)}];
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"] withFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
        [dropdownItems addObject:item];
    }
    
    CGFloat const kDropDownMenuLeftMargin = WINSIZE.width * 0.04;
    CGFloat const kDropDownMenuWidth = WINSIZE.width * 0.18;
    
    _sellingDropDownMenu = [[IGLDropDownMenu alloc] init];
    _sellingDropDownMenu.textFont = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    _sellingDropDownMenu.menuText = NSLocalizedString(kItemDetailSelect, nil);
    _sellingDropDownMenu.dropDownItems = dropdownItems;
    _sellingDropDownMenu.paddingLeft = (kDropDownMenuWidth - [Utilities widthOfText:kItemDetailSelect withFont:DEFAULT_FONT andMaxWidth:WINSIZE.width])/2;
    [_sellingDropDownMenu setFrame:CGRectMake(kDropDownMenuLeftMargin, kTextFieldTopMargin, kDropDownMenuWidth, kTextFieldHeight)];
    
    _sellingDropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
    _sellingDropDownMenu.flipWhenToggleView = YES;
    _sellingDropDownMenu.tag = kSellingDropDownMenuTag;
    _sellingDropDownMenu.delegate = self;
    [_sellingDropDownMenu reloadView];
    
    [_sellingHashTagCell addSubview:_sellingDropDownMenu];
    
    // add current hashtag to hashtag container
    NSArray *tempSellingDictList = [[NSUserDefaults standardUserDefaults] objectForKey:kSellingPreferenceHashtagList];
    NSMutableArray *tempSellingDataList = [NSMutableArray array];
    for (NSDictionary *dict in tempSellingDictList)
        [tempSellingDataList addObject:[[HashtagData alloc] initWithDict:dict]];
    
    for (int i=0; i < tempSellingDataList.count; i++) {
        HashtagData *data = [tempSellingDataList objectAtIndex:i];
        [self addANewHashtagForSelling:data];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIView *) createHashtagViewWithHashtagData: (HashtagData *) data withTag: (NSInteger) tag withType: (NSInteger) buyingOrSellingTag
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *label = [[UILabel alloc] init];
    label.text = data.hashtagText;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    
    if (data.hashtagType == HashtagTypeBrand)
        label.backgroundColor = VIVID_SKY_BLUE_COLOR;
    else
        label.backgroundColor = TEA_ROSE_COLOR;
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
    [deletionButton createTitle:@"x" withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconOffsetY:0];
    deletionButton.titleColor = [UIColor whiteColor];
    deletionButton.borderColor = RED_ORAGNE_COLOR;
    deletionButton.bgColor = RED_ORAGNE_COLOR;
    deletionButton.cornerRadius = 0.0f;
    deletionButton.tag = tag;
    deletionButton.titleLabel.tag = buyingOrSellingTag;
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
- (BOOL) addANewHashtagForBuying: (HashtagData *) data
//------------------------------------------------------------------------------------------------------------------------------
{
    HashtagType selectedHashtagType = data.hashtagType;
    if (selectedHashtagType == HashtagTypeNone) {
        selectedHashtagType = [self getBuyingHashtagType];
    }
    
    if (selectedHashtagType == HashtagTypeNone) {
        // Present an alert view
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please select a hashtag type", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    } else {
        HashtagData *hashtagData = [[HashtagData alloc] initWithText:data.hashtagText andType:selectedHashtagType];
        UIView *hashtagView = [self createHashtagViewWithHashtagData:hashtagData withTag:[_buyingPreferenceHashtagList count] + 1 withType:kBuyingDeletionButtonTag];
        CGSize hashtagViewSize = hashtagView.frame.size;
        CGPoint hashtagViewPos = [self calculatePositionForBuyingHashtagView:hashtagView];
        hashtagView.frame = CGRectMake(hashtagViewPos.x, hashtagViewPos.y, hashtagViewSize.width, hashtagViewSize.height);
        [_buyingHashtagContainer addSubview:hashtagView];
        
        [_buyingPreferenceHashtagList addObject:hashtagData];
        
        _lastBuyingHashtagFrame = CGRectMake(hashtagViewPos.x, hashtagViewPos.y, hashtagViewSize.width, hashtagViewSize.height);
        
        return YES;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) addANewHashtagForSelling: (HashtagData *) data
//------------------------------------------------------------------------------------------------------------------------------
{
    HashtagType selectedHashtagType = data.hashtagType;
    if (selectedHashtagType == HashtagTypeNone) {
        selectedHashtagType = [self getSellingHashtagType];
    }
    
    if (selectedHashtagType == HashtagTypeNone) {
        // Present an alert view
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please select a hashtag type", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    } else {
        HashtagData *hashtagData = [[HashtagData alloc] initWithText:data.hashtagText andType:selectedHashtagType];
        UIView *hashtagView = [self createHashtagViewWithHashtagData:hashtagData withTag:[_sellingPreferenceHashtagList count] + 1 withType:kSellingDeletionButtonTag];
        CGSize hashtagViewSize = hashtagView.frame.size;
        CGPoint hashtagViewPos = [self calculatePositionForSellingHashtagView:hashtagView];
        hashtagView.frame = CGRectMake(hashtagViewPos.x, hashtagViewPos.y, hashtagViewSize.width, hashtagViewSize.height);
        [_sellingHashtagContainer addSubview:hashtagView];
        
        [_sellingPreferenceHashtagList addObject:hashtagData];
        
        _lastSellingHashtagFrame = CGRectMake(hashtagViewPos.x, hashtagViewPos.y, hashtagViewSize.width, hashtagViewSize.height);
        
        return YES;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGPoint) calculatePositionForBuyingHashtagView: (UIView *) hashtagView
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
        CGFloat nextXPos = _lastBuyingHashtagFrame.origin.x + _lastBuyingHashtagFrame.size.width + kLabelLeftMargin + hashtagViewSize.width + kLabelRightMargin;
        if (nextXPos > hashtagContainerSize.width) {
            CGFloat newContainerHeight = _lastBuyingHashtagFrame.origin.y + _lastBuyingHashtagFrame.size.height + kLabelTopMargin + hashtagViewSize.height + kLabelBottomMargin;
            if (newContainerHeight > hashtagContainerSize.height) {
                [_buyingHashtagContainer setContentSize:CGSizeMake(hashtagContainerSize.width, newContainerHeight)];
                [Utilities scrollToBottom:_buyingHashtagContainer];
            }
            return CGPointMake(kLabelLeftMargin, _lastBuyingHashtagFrame.origin.y + _lastBuyingHashtagFrame.size.height + kLabelTopMargin);
        } else {
            return CGPointMake(_lastBuyingHashtagFrame.origin.x + _lastBuyingHashtagFrame.size.width + kLabelLeftMargin, _lastBuyingHashtagFrame.origin.y);
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGPoint) calculatePositionForSellingHashtagView: (UIView *) hashtagView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelTopMargin = 10.0f;
    CGFloat const kLabelBottomMargin = 10.0f;
    CGFloat const kLabelLeftMargin = 10.0f;
    CGFloat const kLabelRightMargin = 2.0f;
    
    NSUInteger lastTag = [_sellingPreferenceHashtagList count];
    
    if (lastTag == 0) {
        return CGPointMake(kLabelLeftMargin, kLabelTopMargin);
    } else {
        CGSize hashtagViewSize = hashtagView.frame.size;
        CGSize hashtagContainerSize = _sellingHashtagContainer.frame.size;
        CGFloat nextXPos = _lastSellingHashtagFrame.origin.x + _lastSellingHashtagFrame.size.width + kLabelLeftMargin + hashtagViewSize.width + kLabelRightMargin;
        if (nextXPos > hashtagContainerSize.width) {
            CGFloat newContainerHeight = _lastSellingHashtagFrame.origin.y + _lastSellingHashtagFrame.size.height + kLabelTopMargin + hashtagViewSize.height + kLabelBottomMargin;
            if (newContainerHeight > hashtagContainerSize.height) {
                [_sellingHashtagContainer setContentSize:CGSizeMake(hashtagContainerSize.width, newContainerHeight)];
                [Utilities scrollToBottom:_sellingHashtagContainer];
            }
            return CGPointMake(kLabelLeftMargin, _lastSellingHashtagFrame.origin.y + _lastSellingHashtagFrame.size.height + kLabelTopMargin);
        } else {
            return CGPointMake(_lastSellingHashtagFrame.origin.x + _lastSellingHashtagFrame.size.width + kLabelLeftMargin, _lastSellingHashtagFrame.origin.y);
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
        return NSLocalizedString(@"Where are you living?", nil);
    else if (section == 2)
        return NSLocalizedString(@"What would you like to buy?", nil);
    else if (section == 3)
        return NSLocalizedString(@"What would you like to sell?", nil);
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
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *) tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0) {
        CountryTableViewController *countryVC = [[CountryTableViewController alloc] initWithSelectedCountries:_travellingToCountryList usedForFiltering:NO];
        countryVC.delegate = self;
        countryVC.tag = kTravellingToTag;
        [self.navigationController pushViewController:countryVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1) {
        CountryTableViewController *countryVC = [[CountryTableViewController alloc] initWithSelectedCountries:_residingCountryList usedForFiltering:NO];
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
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    _currTextFieldTag = textField.tag;
    
    if (_buyingDropDownMenu.isExpanding) {
        if (_buyingDropDownMenu.selectedIndex >= 0)
            [_buyingDropDownMenu selectItemAtIndex:_buyingDropDownMenu.selectedIndex];
        else
            [_buyingDropDownMenu reloadView];
    }
    
    if (_sellingDropDownMenu.isExpanding) {
        if (_sellingDropDownMenu.selectedIndex >= 0)
            [_sellingDropDownMenu selectItemAtIndex:_sellingDropDownMenu.selectedIndex];
        else
            [_sellingDropDownMenu reloadView];
    }
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{    
    [textField resignFirstResponder];
    
    if (textField.tag == kBuyingTextFieldTag) {
        if (textField.text.length > 0) {
            BOOL isAdded = [self addANewHashtagForBuying:[[HashtagData alloc] initWithText:textField.text andType:HashtagTypeNone]];
            if (isAdded)
                textField.text = @"";
        }
    } else if (textField.tag == kSellingTextFieldTag) {
        if (textField.text.length > 0) {
            BOOL isAdded = [self addANewHashtagForSelling:[[HashtagData alloc] initWithText:textField.text andType:HashtagTypeNone]];
            if (isAdded)
                textField.text = @"";
        }
    }
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    // splitting by white space
    /*NSString *kWhiteSpace = @" ";
    if ([string isEqualToString:kWhiteSpace]) {
        if (textField.text.length > 0) {
            BOOL isAdded = [self addANewHashtagForBuying:[[HashtagData alloc] initWithText:textField.text andType:HashtagTypeNone]];
            if (isAdded)
                textField.text = @"";
        }
        
        return NO;
    }*/
    
    return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
-(void) keyboardWillShow
//------------------------------------------------------------------------------------------------------------------------------
{
    [self setViewMovedUp:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
-(void) keyboardWillHide
//------------------------------------------------------------------------------------------------------------------------------
{
    [self setViewMovedUp:NO];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
//------------------------------------------------------------------------------------------------------------------------------
-(void)setViewMovedUp:(BOOL)movedUp
//------------------------------------------------------------------------------------------------------------------------------
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGSize contentSize = _preferenceTableView.contentSize;
    
    if (movedUp) {
        if (!_isExpandingContentSize) {
            contentSize.height += kOFFSET_FOR_KEYBOARD;
            [_preferenceTableView setContentSize:contentSize];
            _isExpandingContentSize = YES;
            
            if (_currTextFieldTag == kBuyingTextFieldTag) {
                CGPoint contentOffset = CGPointMake(0, 80);
                [_preferenceTableView setContentOffset:contentOffset animated:YES];
            } else {
                CGPoint bottomOffset = CGPointMake(0, _preferenceTableView.contentSize.height - _preferenceTableView.bounds.size.height + 35);
                [_preferenceTableView setContentOffset:bottomOffset animated:YES];
            }
        }
    } else {
        contentSize.height -= kOFFSET_FOR_KEYBOARD;
        [_preferenceTableView setContentSize:contentSize];
        _isExpandingContentSize = NO;
    }
    
    [UIView commitAnimations];
}

#pragma markr - IGLDropDownMenuDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger const kHashtagTypeBrandIndex = 0;
    NSInteger const kHashtagTypeModelIndex = 1;
    
    if (dropDownMenu.tag == kBuyingDropDownMenuTag) {
        if (index == kHashtagTypeBrandIndex) {
            _buyingHashtagTextField.placeholder = NSLocalizedString(@"Enter brand E.g. Gucci", nil);
        } else if (index == kHashtagTypeModelIndex) {
            _buyingHashtagTextField.placeholder = NSLocalizedString(@"Enter model E.g. iPhone", nil);
        }
    } else if (dropDownMenu.tag == kSellingDropDownMenuTag) {
        if (index == kHashtagTypeBrandIndex) {
            _sellingHashtagTextField.placeholder = NSLocalizedString(@"Enter brand E.g. Gucci", nil);
        } else if (index == kHashtagTypeModelIndex) {
            _sellingHashtagTextField.placeholder = NSLocalizedString(@"Enter model E.g. iPhone", nil);
        }
    }
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) deletionButtonTapEventHandler: (UIButton *) button
//------------------------------------------------------------------------------------------------------------------------------
{
    if (button.titleLabel.tag == kBuyingDeletionButtonTag) {
        for (int i=1; i <= _buyingPreferenceHashtagList.count; i++) {
            UIView *view = [_buyingHashtagContainer viewWithTag:i];
            [view removeFromSuperview];
        }
        
        [_buyingPreferenceHashtagList removeObjectAtIndex:button.tag - 1];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_buyingPreferenceHashtagList];
        _buyingPreferenceHashtagList = [NSMutableArray array];
        
        [_buyingHashtagContainer setContentSize:_buyingHashtagContainer.frame.size];
        
        for (int i=0; i < tempArray.count; i++) {
            HashtagData *data = [tempArray objectAtIndex:i];
            [self addANewHashtagForBuying:data];
        }
    } else if (button.titleLabel.tag == kSellingDeletionButtonTag) {
        for (int i=1; i <= _sellingPreferenceHashtagList.count; i++) {
            UIView *view = [_sellingHashtagContainer viewWithTag:i];
            [view removeFromSuperview];
        }
        
        [_sellingPreferenceHashtagList removeObjectAtIndex:button.tag - 1];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_sellingPreferenceHashtagList];
        _sellingPreferenceHashtagList = [NSMutableArray array];
        
        [_sellingHashtagContainer setContentSize:_sellingHashtagContainer.frame.size];
        
        for (int i=0; i < tempArray.count; i++) {
            HashtagData *data = [tempArray objectAtIndex:i];
            [self addANewHashtagForSelling:data];
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) hashtagAddingButtonTapEventHandler: (UIButton *) button
//------------------------------------------------------------------------------------------------------------------------------
{
    if (button.tag == kBuyingAddingButtonTag) {
        if (_buyingHashtagTextField.text.length > 0) {
            BOOL isAdded = [self addANewHashtagForBuying:[[HashtagData alloc] initWithText:_buyingHashtagTextField.text andType:HashtagTypeNone]];
            if (isAdded)
                _buyingHashtagTextField.text = @"";
        }
    } else if (button.tag == kSellingAddingButtonTag) {
        if (_sellingHashtagTextField.text.length > 0) {
            BOOL isAdded = [self addANewHashtagForSelling:[[HashtagData alloc] initWithText:_sellingHashtagTextField.text andType:HashtagTypeNone]];
            if (isAdded)
                _sellingHashtagTextField.text = @"";
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
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

//------------------------------------------------------------------------------------------------------------------------------
- (HashtagType) getBuyingHashtagType
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger const kHashtagTypeBrandIndex = 0;
    NSInteger const kHashtagTypeModelIndex = 1;
    
    if (_buyingDropDownMenu.selectedIndex == kHashtagTypeBrandIndex)
        return HashtagTypeBrand;
    else if (_buyingDropDownMenu.selectedIndex == kHashtagTypeModelIndex)
        return HashtagTypeModel;
    else
        return HashtagTypeNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (HashtagType) getSellingHashtagType
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger const kHashtagTypeBrandIndex = 0;
    NSInteger const kHashtagTypeModelIndex = 1;
    
    if (_sellingDropDownMenu.selectedIndex == kHashtagTypeBrandIndex)
        return HashtagTypeBrand;
    else if (_sellingDropDownMenu.selectedIndex == kHashtagTypeModelIndex)
        return HashtagTypeModel;
    else
        return HashtagTypeNone;
}

@end
