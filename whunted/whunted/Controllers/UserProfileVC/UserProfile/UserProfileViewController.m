//
//  UserProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PreferenceViewController.h"
#import "FeedbackReviewVC.h"
#import "FeedbackData.h"
#import "MarketplaceCollectionViewCell.h"
#import "ItemDetailsViewController.h"
#import "ProfileImageCache.h"
#import "VerificationCodeRequesterVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>

#define kTopMargin      WINSIZE.width / 30.0
#define kLeftMargin     WINSIZE.width / 30.0 * 1.5

//-------------------------------------------------------------------------------------------------------------------------------
@interface UserProfileViewController ()
//-------------------------------------------------------------------------------------------------------------------------------

@property (atomic)  BOOL        isLoadingWhuntsDetails;

@end


//-------------------------------------------------------------------------------------------------------------------------------
@implementation UserProfileViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIScrollView                *_scrollView;
    UIView                      *_topRightView;
    
    UILabel                     *_positiveFeedbackLabel;
    UILabel                     *_mehFeedbackLabel;
    UILabel                     *_negativeFeedbackLabel;
    
    UILabel                     *_totalListingsNumLabel;
    
    JTImageButton               *_followerButton;
    JTImageButton               *_followingButton;
    
    UICollectionView            *_historyCollectionView;
    
    UIImageView                 *_profileImageView;
    UILabel                     *_userFullNameLabel;
    UILabel                     *_countryLabel;
    UILabel                     *_userDescriptionLabel;
    
    UIImageView                 *_phoneImageView;
    
    UIView                      *_leftHorizontalLine;
    UIView                      *_rightHorizontalLine;
    
    UISegmentedControl          *_segmentedControl;
    
    CGFloat                     _currHeight;
    CGFloat                     _collectionViewOriginY;
    CGFloat                     _collectionViewCurrHeight;
    
    HistoryCollectionViewMode   _curViewMode;
    
    NSMutableDictionary         *_ratingDict;
    NSMutableArray              *_myWantDataList;
    NSMutableArray              *_mySellDataList;
    
    NSMutableArray              *_myCompletedSellDataList;
    NSMutableArray              *_myOngoingSellDataList;
    
    BOOL                        _isViewingMyProfile;
    BOOL                        _loadingCompletedDataDone;
    BOOL                        _loadingOngoingDataDone;
    BOOL                        _ongoingOrAcceptedTableLoaded;  // Used to update listings num in Selling tab
    
    NSInteger                   _count;
}

@synthesize profileOwner            =   _profileOwner;
@synthesize isLoadingWhuntsDetails  =   _isLoadingWhuntsDetails;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithProfileOwner: (PFUser *) profileOwner
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self)
    {
        _profileOwner = profileOwner;
        
        [self initData];
        [self initUI];
        [self retrieveMyWantList];
        [self addNotificationListener];
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"UserProfileScreen"];
    [self displayReminderForPhoneVerification];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    [Utilities logOutMessage:@"UserProfileViewController didReceiveMemoryWarning"];
}


#pragma mark - Setting Up

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//-------------------------------------------------------------------------------------------------------------------------------
{
    _curViewMode = HistoryCollectionViewModeBuying;
    
    _myWantDataList = [[NSMutableArray alloc] init];
    
    if ([_profileOwner.objectId isEqualToString:[PFUser currentUser].objectId])
        _isViewingMyProfile = YES;
    else
        _isViewingMyProfile = NO;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationListener
//-------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfile) name:NOTIFICATION_USER_PROFILE_EDITED_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfile) name:NOTIFICATION_USER_PROFILE_UPDATED_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventAfterPhoneVerification) name:NOTIFICATION_USER_DID_VERIFY_PHONE_NUMBER object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whuntFulfilledEventHandler:) name:NOTIFICATION_OFFER_ACCEPTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whuntDetailsEditedEventHandler:) name:NOTIFICATION_WHUNT_DETAILS_EDITED_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameButtonTapEventHandler:) name:NOTIFICATION_USERNAME_BUTTON_USER_PROFILE_TAP_EVENT object:nil];
}

/*
 * 1. Retrieve whunts posted by the profile owner  2. Retrieve whunts that profile owner has fulfiled or offered.
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveData
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self retrieveMyWantList];
    [self retrieveMySellList];
}


#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self customizeView];
    [self addScrollView];
    [self addProfileImage_Name_Country_Rating];
    [self addPreferencesAndEditButtons];
    [self addUserDescription];
    [self addDate_Verification_DescriptionLabels];
    [self addControls];
    [self addTotalListingsNumLabel];
    [self addHistoryCollectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeView
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *title = [NSString stringWithFormat:@"@%@", _profileOwner[PF_USER_USERNAME]];
    [Utilities customizeTitleLabel:title forViewController:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonTapEventHandler)];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat statusAndNavBarHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height - statusAndNavBarHeight - tabBarHeight)];
    [self.view addSubview:_scrollView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addProfileImage_Name_Country_Rating
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addProfileImage];
    [self addUserFullNameLabel];
    [self addCountryLabel];
    [self addRatingView];
    [self updateNumOfFeedbacks];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addProfileImage
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIView *profileBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * 0.3, WINSIZE.width * 0.3)];
    [_scrollView addSubview:profileBg];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", _profileOwner.objectId, USER_PROFILE_IMAGE];
    UIImage *profileImage = [[ProfileImageCache sharedCache] objectForKey:key];
    
    CGFloat const kMarginWidth = WINSIZE.width / 30.0;
    CGFloat const kImageWidth = WINSIZE.width * 0.3 - 2 * kMarginWidth;
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginWidth, kMarginWidth, kImageWidth, kImageWidth)];
    [_profileImageView setImage:profileImage];
    _profileImageView.layer.cornerRadius = kImageWidth/2;
    _profileImageView.clipsToBounds = YES;
    [profileBg addSubview:_profileImageView];
    
    if (!_profileImageView.image)
    {
        _profileImageView.image = [UIImage imageNamed:@"default_profile_image.png"];
        
        ImageHandler handler = ^(UIImage *image)
        {
            _profileImageView.image = image;
            [[ProfileImageCache sharedCache] setObject:image forKey:key];
            
            if (!image)
            {
                _profileImageView.image = [UIImage imageNamed:@"default_profile_image.png"];
            }
        };
        [Utilities retrieveProfileImageForUser:_profileOwner andRunBlock:handler];
    }
    
    _currHeight = WINSIZE.width * 0.3;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addRatingView
//-------------------------------------------------------------------------------------------------------------------------------
{
    _topRightView = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width * (0.3 + 1.0/30), 0, WINSIZE.width * 0.7, WINSIZE.width * 0.3)];
    [_scrollView addSubview:_topRightView];
    
    CGFloat const kBackgroundHeight = (WINSIZE.width * 0.3 - 2 * kTopMargin) / 2 - 10.0f;
    CGFloat kBackgroundOriginY = kTopMargin + 5;
    if (!_isViewingMyProfile)
    {
        kBackgroundOriginY = kTopMargin + 10;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kBackgroundOriginY, WINSIZE.width * 0.6, kBackgroundHeight)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ratingViewTapEventHandler)];
    [backgroundView addGestureRecognizer:tapRecognizer];
    
    // TODO: color is likely to change later
    [backgroundView setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_3];
    
    backgroundView.layer.cornerRadius = 6.0f;
    backgroundView.clipsToBounds = YES;
    [_topRightView addSubview:backgroundView];
    
    [self addSmilingViewToBackground:backgroundView];
    [self addMehViewToBackground:backgroundView];
    [self addSadViewToBackground:backgroundView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSmilingViewToBackground: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundHeight = backgroundView.frame.size.height;
    CGFloat const kBackgroundWidth = backgroundView.frame.size.width;
    CGFloat const kIconHeight = kBackgroundHeight * 0.7;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.08;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.15;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *smilingFaceImage = [UIImage imageNamed:@"smiling_face.png"];
    UIImageView *smilingFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [smilingFaceImageView setImage:smilingFaceImage];
    [containerView addSubview:smilingFaceImageView];
    
    _positiveFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _positiveFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:18];
    _positiveFeedbackLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _positiveFeedbackLabel.text = @"0";
    [containerView addSubview:_positiveFeedbackLabel];
    
    [backgroundView addSubview:containerView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addMehViewToBackground: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundHeight = backgroundView.frame.size.height;
    CGFloat const kBackgroundWidth = backgroundView.frame.size.width;
    CGFloat const kIconHeight = kBackgroundHeight * 0.7;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.1;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.15;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *mehFaceImage = [UIImage imageNamed:@"meh_face.png"];
    UIImageView *mehFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [mehFaceImageView setImage:mehFaceImage];
    [containerView addSubview:mehFaceImageView];
    
    _mehFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _mehFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:18];
    _mehFeedbackLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _mehFeedbackLabel.text = @"0";
    [containerView addSubview:_mehFeedbackLabel];
    
    [backgroundView addSubview:containerView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSadViewToBackground: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundHeight = backgroundView.frame.size.height;
    CGFloat const kBackgroundWidth = backgroundView.frame.size.width;
    CGFloat const kIconHeight = kBackgroundHeight * 0.7;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.12;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.15;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + 2 * kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *sadFaceImage = [UIImage imageNamed:@"sad_face.png"];
    UIImageView *sadFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [sadFaceImageView setImage:sadFaceImage];
    [containerView addSubview:sadFaceImageView];
    
    _negativeFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _negativeFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:18];
    _negativeFeedbackLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _negativeFeedbackLabel.text = @"0";
    [containerView addSubview:_negativeFeedbackLabel];
    
    [backgroundView addSubview:containerView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferencesAndEditButtons
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundHeight = (WINSIZE.width * 0.3 - 2 * kTopMargin) / 2 - 10.0f;
    CGFloat const kBackgroundWidth  = WINSIZE.width * 0.6;
    CGFloat const kOriginY = kTopMargin + kBackgroundHeight + 15.0f;
    CGFloat const kOriginX = 0;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kOriginX, kOriginY, kBackgroundWidth, kBackgroundHeight)];
    [_topRightView addSubview:backgroundView];
    
    if (_isViewingMyProfile)
    {
        [self addPreferencesButton:backgroundView];
        [self addEditButtonToView:backgroundView];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferencesButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth = (backgroundView.frame.size.width - 10) / 2;
    CGFloat const kButtonHeight = backgroundView.frame.size.height;
    CGFloat const kButtonOriginX = kButtonWidth + 10;
    
    JTImageButton *preferencesButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, 0, kButtonWidth, kButtonHeight)];
    [preferencesButton createTitle:NSLocalizedString(@"Preferences", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:14] iconOffsetY:0];
    
    // TODO: colors are likely to change
    preferencesButton.bgColor = GRAY_COLOR_WITH_WHITE_COLOR_2_5;
    preferencesButton.borderColor = GRAY_COLOR_WITH_WHITE_COLOR_2_5;
    preferencesButton.titleColor = TEXT_COLOR_DARK_GRAY;
    
    preferencesButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    preferencesButton.cornerRadius = 6.0;
    [preferencesButton addTarget:self action:@selector(preferencesButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:preferencesButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addEditButtonToView: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonHeight = backgroundView.frame.size.height;
    CGFloat kButtonWidth = (backgroundView.frame.size.width - 10) / 2;
    CGFloat kButtonOriginX = 0;
    
    JTImageButton *editButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, 0, kButtonWidth, kButtonHeight)];
    [editButton createTitle:NSLocalizedString(@"Edit Profile", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:14] iconOffsetY:0];
    
    // TODO: colors are likely to change
    editButton.bgColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    editButton.borderColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    editButton.titleColor = TEXT_COLOR_DARK_GRAY;
    
    editButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    editButton.cornerRadius = 6.0;
    [editButton addTarget:self action:@selector(editButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:editButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserFullNameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelHeight = 20.0f;
    CGFloat const kLabelOriginY = _currHeight;
    _userFullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, kLabelOriginY, WINSIZE.width - 2 * kLeftMargin, kLabelHeight)];
    
    NSString *firstName = _profileOwner[PF_USER_FIRSTNAME];
    NSString *lastName = _profileOwner[PF_USER_LASTNAME];
    if (firstName.length == 0 && lastName.length == 0)
    {
        _userFullNameLabel.text = _profileOwner[PF_USER_USERNAME];
    }
    else if (firstName.length == 0)
    {
        _userFullNameLabel.text = lastName;
    }
    else if (lastName.length == 0)
    {
        _userFullNameLabel.text = firstName;
    }
    else
    {
        _userFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    }
    
    _userFullNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
    _userFullNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_scrollView addSubview:_userFullNameLabel];
    
    _currHeight += kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addCountryLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelHeight = 20.0f;
    CGFloat const kLabelOriginY = _currHeight - 2.0f;
    
    _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, kLabelOriginY, WINSIZE.width - 2 * kLeftMargin, kLabelHeight)];
    _countryLabel.text = _profileOwner[PF_USER_COUNTRY];
    _countryLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE];
    _countryLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_scrollView addSubview:_countryLabel];
    
    _currHeight += kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addDate_Verification_DescriptionLabels
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addJoiningDate];
    [self addVerificationInfo];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserDescription
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelTopMargin = WINSIZE.height / 192.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLeftMargin;
    CGFloat const kMaxNumOfLines = 40;
    
    _userDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, kYPos, kLabelWidth, 0)];
    _userDescriptionLabel.text = _profileOwner[PF_USER_DESCRIPTION];
    _userDescriptionLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _userDescriptionLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _userDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _userDescriptionLabel.numberOfLines = kMaxNumOfLines;
    [_userDescriptionLabel sizeToFit];
    [_scrollView addSubview:_userDescriptionLabel];
    
    _currHeight += kLabelTopMargin + _userDescriptionLabel.frame.size.height;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addJoiningDate
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSDate *joiningDate = _profileOwner.createdAt;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit  fromDate:joiningDate];
    
    CGFloat const kLabelTopMargin = WINSIZE.height / 96.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLeftMargin;
    CGFloat const kLabelHeight = 20;
    UILabel *joiningDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, kYPos, kLabelWidth, kLabelHeight)];
    joiningDateLabel.text = [NSString stringWithFormat:@"%@ %ld/%ld/%ld", NSLocalizedString(@"Date joined", nil), (long)components.day, (long)components.month, (long)components.year];
    joiningDateLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    joiningDateLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_scrollView addSubview:joiningDateLabel];
    
    _currHeight += kLabelTopMargin + kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addVerificationInfo
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundTopMargin = WINSIZE.height / 192.0;
    CGFloat const kYPos = _currHeight + kBackgroundTopMargin;
    CGFloat const kBackgroundWidth = WINSIZE.width - 2 * kLeftMargin;
    CGFloat const kBackgroundHeight = 20;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kLeftMargin, kYPos, kBackgroundWidth, kBackgroundHeight)];
    [_scrollView addSubview:backgroundView];
    
    UILabel *verifiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, kBackgroundHeight)];
    verifiedLabel.text = NSLocalizedString(@"Verified", nil);
    verifiedLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    verifiedLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [verifiedLabel sizeToFit];
    
    
    CGFloat currOriginX = verifiedLabel.frame.size.width + 8;
    
    BOOL facebookVerified = [_profileOwner[PF_USER_FACEBOOK_VERIFIED] boolValue];
    if (facebookVerified)
    {
        [backgroundView addSubview:verifiedLabel];
        
        UIImage *fbImage = [UIImage imageNamed:@"fb_verification.png"];
        
        CGFloat const kImageWith = 16;
        
        UIImageView *fbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currOriginX, 2, kImageWith, kImageWith)];
        [fbImageView setImage:fbImage];
        [backgroundView addSubview:fbImageView];
        
        currOriginX += 8 + kImageWith;
    }
    
    BOOL emailVerified = [_profileOwner[PF_USER_EMAIL_VERIFICATION] boolValue];
    if (emailVerified)
    {
        if (!facebookVerified)
            [backgroundView addSubview:verifiedLabel];
        
        UIImage *emailImage = [UIImage imageNamed:@"email_verification.png"];
        
        CGFloat const kImageWith = 20;
        
        UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currOriginX, 0, kImageWith, kImageWith)];
        [emailImageView setImage:emailImage];
        [backgroundView addSubview:emailImageView];
        
        currOriginX += 8 + kImageWith;
    }
    
    BOOL phoneVerified = [_profileOwner[PF_USER_PHONE_VERIFIED] boolValue];
    
    if (!facebookVerified && !emailVerified)
        [backgroundView addSubview:verifiedLabel];
    
    UIImage *phoneImage = [UIImage imageNamed:@"verified_phone_icon.png"];
    
    CGFloat const kImageWidth = 16;
    
    _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currOriginX, 2, kImageWidth, kImageWidth)];
    [_phoneImageView setImage:phoneImage];
    [backgroundView addSubview:_phoneImageView];
    
    if (phoneVerified)
    {
        _phoneImageView.hidden = NO;
    }
    else
    {
        _phoneImageView.hidden = YES;
    }
    
    _currHeight += kBackgroundTopMargin + kBackgroundHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addControls
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addSegmentedControl];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kControlTopMargin =   WINSIZE.height / 36.0;
    CGFloat const kControlOriginX   =   WINSIZE.width / 4.0;
    CGFloat const kControlOriginY   =   _currHeight + kControlTopMargin;
    CGFloat const kControlWidth     =   WINSIZE.width / 2.0;
    CGFloat const kControlHeight    =   32;
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Buying", nil), NSLocalizedString(@"Selling", nil)]];
    _segmentedControl.frame = CGRectMake(kControlOriginX, kControlOriginY, kControlWidth, kControlHeight);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE]} forState:UIControlStateNormal];
    _segmentedControl.tintColor = MAIN_BLUE_COLOR;
    [_segmentedControl addTarget:self action:@selector(segmentedControlSwitchEventHandler:) forControlEvents:UIControlEventValueChanged];
    
    [_scrollView addSubview:_segmentedControl];
    
    _currHeight += kControlTopMargin + kControlHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addTotalListingsNumLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    _totalListingsNumLabel = [[UILabel alloc] init];
    _totalListingsNumLabel.text = NSLocalizedString(@" Listings", nil);
    _totalListingsNumLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:16];
    _totalListingsNumLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_totalListingsNumLabel sizeToFit];
    
    CGFloat const kLabelWidth = _totalListingsNumLabel.frame.size.width;
    CGFloat const kLabelHeight = _totalListingsNumLabel.frame.size.height;
    CGFloat const kLabelLeftMargin = WINSIZE.width / 2.0 - kLabelWidth / 2.0;
    CGFloat const kLabelTopMargin = WINSIZE.height / 48.0;
    CGFloat const kLabelYPos = _currHeight + kLabelTopMargin;
    _totalListingsNumLabel.frame = CGRectMake(kLabelLeftMargin, kLabelYPos, kLabelWidth, kLabelHeight);
    [_scrollView addSubview:_totalListingsNumLabel];
    
    // add two horizontal lines beside the total listing label
    CGFloat const kFirstLineLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kLineWidth = kLabelLeftMargin - 5 - kFirstLineLeftMargin;
    CGFloat const kLineYPos = kLabelYPos + kLabelHeight / 2.0;
    CGFloat const kSecondLineXPos = WINSIZE.width / 2.0 + kLabelWidth / 2.0 + 5;
    
    _leftHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(kFirstLineLeftMargin, kLineYPos, kLineWidth, 1)];
    _leftHorizontalLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_5;
    [_scrollView addSubview:_leftHorizontalLine];
    
    _rightHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(kSecondLineXPos, kLineYPos, kLineWidth, 1)];
    _rightHorizontalLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_5;
    [_scrollView addSubview:_rightHorizontalLine];
    
    _currHeight += kLabelTopMargin + kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addHistoryCollectionView
//-------------------------------------------------------------------------------------------------------------------------------
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat const kCollectionTopMargin  =   WINSIZE.height / 48.0;
    CGFloat const kCollectionYPos       =   _currHeight + kCollectionTopMargin;
    _collectionViewOriginY              =   kCollectionYPos;
    _collectionViewCurrHeight           =   0;
    
    _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kCollectionYPos, WINSIZE.width, 0) collectionViewLayout:layout];
    _historyCollectionView.dataSource       =   self;
    _historyCollectionView.delegate         =   self;
    _historyCollectionView.backgroundColor  =   GRAY_COLOR_WITH_WHITE_COLOR_2;
    _historyCollectionView.scrollEnabled    =   NO;
    
    [_historyCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    
    [_scrollView addSubview:_historyCollectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) updateTotalListingNumLabel: (NSInteger) listingsNum numListingsDisplayed: (BOOL) displayed
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSString *text;
    if (displayed)
        text = [NSString  stringWithFormat:@"%ld %@", listingsNum, [self getListingTextBasedOnNum:listingsNum]];
    else
        text = [NSString  stringWithFormat:@"%@", [self getListingTextBasedOnNum:listingsNum]];
    
    _totalListingsNumLabel.text = text;
    [_totalListingsNumLabel sizeToFit];

    CGFloat const kLabelWidth = _totalListingsNumLabel.frame.size.width;
    CGFloat const kLabelHeight = _totalListingsNumLabel.frame.size.height;
    CGFloat const kLabelLeftMargin = WINSIZE.width / 2.0 - kLabelWidth / 2.0;
    CGFloat const kLabelYPos = _totalListingsNumLabel.frame.origin.y;
    _totalListingsNumLabel.frame = CGRectMake(kLabelLeftMargin, kLabelYPos, kLabelWidth, kLabelHeight);
    [_scrollView addSubview:_totalListingsNumLabel];

    CGFloat const kFirstLineLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kLineWidth = kLabelLeftMargin - 5 - kFirstLineLeftMargin;
    CGFloat const kLineYPos = kLabelYPos + kLabelHeight / 2.0;
    CGFloat const kSecondLineXPos = WINSIZE.width / 2.0 + kLabelWidth / 2.0 + 5;

    _leftHorizontalLine.frame = CGRectMake(kFirstLineLeftMargin, kLineYPos, kLineWidth, 1);
    _rightHorizontalLine.frame = CGRectMake(kSecondLineXPos, kLineYPos, kLineWidth, 1);
}


#pragma mark - CollectionViewDataSource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_curViewMode == HistoryCollectionViewModeBuying)
    {
        [self resizeHistoryCollectionView];
        return [_myWantDataList count];
    }
    else
    {
        [self resizeHistoryCollectionView];
        return [_mySellDataList count];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    MarketplaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarketplaceCollectionViewCell" forIndexPath:indexPath];
    cell.cellIndex = indexPath.row;
    cell.cellIdentifier = CELL_IN_USER_PROFILE;
    cell.profileOwner = _profileOwner;
    
    if (cell.wantData == nil)
        [cell initCell];
    else
        [cell clearCellUI];
    
    if (_curViewMode == HistoryCollectionViewModeBuying)
    {
        WantData *wantData = [_myWantDataList objectAtIndex:indexPath.row];
        [cell setWantData:wantData];
    }
    else
    {
        WantData *wantData = [_mySellDataList objectAtIndex:indexPath.row];
        [cell setWantData:wantData];
    }
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
        return [Utilities sizeOfFullCollectionCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 8.0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 10.0;
}


#pragma mark - UICollectionViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_isLoadingWhuntsDetails)
        return;
    
    _isLoadingWhuntsDetails = YES;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [Utilities showSmallIndeterminateProgressIndicatorInView:cell];
    
    ItemDetailsViewController *itemDetailsVC = [[ItemDetailsViewController alloc] init];
    
    if (_curViewMode == HistoryCollectionViewModeBuying)
    {
        itemDetailsVC.wantData = [_myWantDataList objectAtIndex:indexPath.row];
        itemDetailsVC.viewedOnSellingTab = NO;
    }
    else
    {
        itemDetailsVC.wantData = [_mySellDataList objectAtIndex:indexPath.row];
        itemDetailsVC.viewedOnSellingTab = YES;
    }
    
    itemDetailsVC.itemImagesNum = itemDetailsVC.wantData.itemPicturesNum;
    
    // set viewControllerName for itemDetailsVC
    PFUser *currUser = [PFUser currentUser];
    if (![_profileOwner.objectId isEqualToString:currUser.objectId])
        itemDetailsVC.viewControllerName = ITEM_DETAILS_FROM_MARKETPLACE;
    
    PFQuery *sQuery = [PFQuery queryWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [sQuery whereKey:@"sellerID" equalTo:_profileOwner.objectId];
    [sQuery whereKey:@"itemID" equalTo:itemDetailsVC.wantData.itemID];
    
    [sQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (objects.count > 0)
            {
                itemDetailsVC.currOffer = [[TransactionData alloc] initWithPFObject:[objects objectAtIndex:0]];
            }
        }
        else
        {
            [Utilities handleError:error];
        }
        
        [self.navigationController pushViewController:itemDetailsVC animated:YES];
        [Utilities hideIndeterminateProgressIndicatorInView:cell];
        _isLoadingWhuntsDetails = NO;
    }];
}


#pragma mark - Event Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) displayReminderForPhoneVerification
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSNumber *temp = [[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_TIMES_APP_IS_LAUNCHED];
    NSInteger numOfTimesAppIsLaunched = [temp integerValue];
    
    NSNumber *temp_2 = [[NSUserDefaults standardUserDefaults] objectForKey:PHONE_VERIFICATION_REMINDER_DISPLAYED];
    NSInteger reminderDisplayed = [temp_2 boolValue];
    
    PFUser *currUser = [PFUser currentUser];
    BOOL phoneVerified = [currUser[PF_USER_PHONE_VERIFIED] boolValue];
    
    // if this is the second time user launchs the app, then alert him/her to do phone verification
    if (numOfTimesAppIsLaunched == 2 && !reminderDisplayed && !phoneVerified)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:PHONE_VERIFICATION_REMINDER_DISPLAYED];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Phone Verification", nil) message:NSLocalizedString(@"Phone verification helps to increase trust among buyers and sellers. Would you like to verify your phone number now?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Yes, let's verify", nil) otherButtonTitles:NSLocalizedString(@"I'll verify later", nil), nil];
        [alertView show];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) listGridViewButtonTapEventHandler: (id) sender
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kIconHeight = 25;
    
    JTImageButton *listGridViewControl = (JTImageButton *) sender;
    if (listGridViewControl.tag == 0)
    {
        [listGridViewControl createTitle:nil withIcon:[UIImage imageNamed:@"list_view_icon.png"] font:nil iconHeight:kIconHeight iconOffsetY:JTImageButtonIconOffsetYNone];
        listGridViewControl.tag = 1;
    }
    else
    {
        [listGridViewControl createTitle:@"" withIcon:[UIImage imageNamed:@"grid_view_icon.png"] font:nil iconHeight:kIconHeight iconOffsetY:JTImageButtonIconOffsetYNone];
        listGridViewControl.tag = 0;
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) preferencesButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    PreferenceViewController *preferenceVC = [[PreferenceViewController alloc] init];
    [self.navigationController pushViewController:preferenceVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) segmentedControlSwitchEventHandler: (UISegmentedControl *) segmentedControl
//-------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"SwitchSegmentedControlInUserProfileEvent" label:@"SegmentedControl" value:nil];
    
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        _curViewMode = HistoryCollectionViewModeBuying;
        [self updateTotalListingNumLabel:_myWantDataList.count numListingsDisplayed:YES];
    }
    else
    {
        _curViewMode = HistoryCollectionViewModeSelling;
        
        if (!_mySellDataList)
        {
            [self updateTotalListingNumLabel:0 numListingsDisplayed:NO];
            [self retrieveMySellList];
        }
        else
            [self updateTotalListingNumLabel:_mySellDataList.count numListingsDisplayed:YES];
    }
    
    [_historyCollectionView reloadData];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) resizeHistoryCollectionView
//-------------------------------------------------------------------------------------------------------------------------------
{
    _currHeight -= _collectionViewCurrHeight;
    
    CGFloat const kYDistanceBetweenCell     =   16.0f;
    CGFloat const kCellHeight = [Utilities sizeOfFullCollectionCell].height;
    
    NSInteger listSize;
    if (_curViewMode == HistoryCollectionViewModeBuying)
        listSize = _myWantDataList.count;
    else
        listSize = _mySellDataList.count;
    _collectionViewCurrHeight = ((listSize + 1) / 2) * (kCellHeight + kYDistanceBetweenCell);
    
    _historyCollectionView.frame = CGRectMake(0, _collectionViewOriginY, WINSIZE.width, _collectionViewCurrHeight);
    _currHeight = _collectionViewOriginY + _collectionViewCurrHeight;
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, _currHeight)];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) settingsButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    SettingsTableVC *settingsVC = [[SettingsTableVC alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) ratingViewTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    [query whereKey:PF_FEEDBACK_RECEIVER_ID equalTo:_profileOwner.objectId];
    [query orderByAscending:PF_UPDATED_AT];
    [query findObjectsInBackgroundWithBlock:^(NSArray * array, NSError *error)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        
        if (error)
        {
            [Utilities handleError:error];
        }
        else
        {
            FeedbackReviewVC *feedbackVC = [[FeedbackReviewVC alloc] init];
            feedbackVC.ratingDict = _ratingDict;
            
            NSMutableArray *feedbackList = [NSMutableArray array];
            for (PFObject *obj in array)
            {
                [feedbackList addObject:[[FeedbackData alloc] initWithPFObject:obj]];
            }
            
            feedbackVC.feedbackList = feedbackList;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
    }];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) updateUserProfile
//-------------------------------------------------------------------------------------------------------------------------------
{
    [_scrollView removeFromSuperview];
    
    [self initUI];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) whuntDetailsEditedEventHandler: (NSNotification *) notification
//-------------------------------------------------------------------------------------------------------------------------------
{
    WantData *editedWhunt = notification.object;
    
    for (int i=0; i<_myWantDataList.count; i++)
    {
        WantData *wantData = [_myWantDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:editedWhunt.itemID])
        {
            [_myWantDataList replaceObjectAtIndex:i withObject:editedWhunt];
            [_historyCollectionView reloadData];
            break;
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) whuntFulfilledEventHandler: (NSNotification *) notification
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSString *itemID = notification.object;
    
    // Update whunt in Buying list
    for (int i=0; i<_myWantDataList.count; i++)
    {
        WantData *wantData = [_myWantDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:itemID])
        {
            wantData.isFulfilled = YES;
            [self sortMyWhuntsList];
            [_historyCollectionView reloadData];
            break;
        }
    }
    
    // Update whunt in Selling list
    for (int i=0; i<_mySellDataList.count; i++)
    {
        WantData *wantData = [_mySellDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:itemID])
        {
            wantData.isFulfilled = YES;
            [_historyCollectionView reloadData];
            break;
        }
    }
}

/*
 * Display user's profile.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewUserProfileEvent" label:@"BuyerUsernameButton" value:nil];
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    UserHandler handler = ^(PFUser *user)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    NSString *userID = notification.object;
    [Utilities retrieveUserInfoByUserID:userID andRunBlock:handler];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) editButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    UserData *userData = [[UserData alloc] initWithParseUser:[PFUser currentUser]];
    EditProfileViewController *editProfileVC = [[EditProfileViewController alloc] initWithUserData:userData];
    [self.navigationController pushViewController:editProfileVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) handleEventAfterPhoneVerification
//-------------------------------------------------------------------------------------------------------------------------------
{
    [[PFUser currentUser] fetchInBackground];
    _phoneImageView.hidden = NO;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Yay!", nil) message:NSLocalizedString(@"Your phone number has been verified.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - UIAlertViewDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 0)
        [self userChoseToVerifyNow];
    else
        [self userChoseToVerifyLater];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) userChoseToVerifyNow
//-------------------------------------------------------------------------------------------------------------------------------
{
    VerificationCodeRequesterVC *codeRequester = [[VerificationCodeRequesterVC alloc] init];
    [self.navigationController pushViewController:codeRequester animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) userChoseToVerifyLater
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Phone Verification", nil) message:NSLocalizedString(@"To verify your phone number later, tap Settings button at the top and choose Verify Phone Number.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alertView show];
}


#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *) getListingTextBasedOnNum: (NSInteger) num
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (num <= 1)
        return NSLocalizedString(@"Listing", nil);
    else
        return NSLocalizedString(@"Listings", nil);
}


#pragma mark - Backend

//-------------------------------------------------------------------------------------------------------------------------------
- (void) updateNumOfFeedbacks
//-------------------------------------------------------------------------------------------------------------------------------
{
    _ratingDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0, FEEDBACK_RATING_POSITIVE, @0, FEEDBACK_RATING_NEUTRAL, @0, FEEDBACK_RATING_NEGATIVE, nil];
    
    // update positive feedback label
    PFQuery *posQuery = [[PFQuery alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    [posQuery whereKey:PF_FEEDBACK_RECEIVER_ID equalTo:_profileOwner.objectId];
    [posQuery whereKey:PF_FEEDBACK_RATING equalTo:FEEDBACK_RATING_POSITIVE];
    [posQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
        }
        else
        {
            _positiveFeedbackLabel.text = [NSString stringWithFormat:@"%d", count];
            [_ratingDict setValue:[NSNumber numberWithInt:count] forKey:FEEDBACK_RATING_POSITIVE];
        }
    }];
    
    // update neutral feedback label
    PFQuery *neuQuery = [[PFQuery alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    [neuQuery whereKey:PF_FEEDBACK_RECEIVER_ID equalTo:_profileOwner.objectId];
    [neuQuery whereKey:PF_FEEDBACK_RATING equalTo:FEEDBACK_RATING_NEUTRAL];
    [neuQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
        }
        else
        {
            _mehFeedbackLabel.text = [NSString stringWithFormat:@"%d", count];
            [_ratingDict setValue:[NSNumber numberWithInt:count] forKey:FEEDBACK_RATING_NEUTRAL];
        }
    }];
    
    // update negative feedback label
    PFQuery *negQuery = [[PFQuery alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    [negQuery whereKey:PF_FEEDBACK_RECEIVER_ID equalTo:_profileOwner.objectId];
    [negQuery whereKey:PF_FEEDBACK_RATING equalTo:FEEDBACK_RATING_NEGATIVE];
    [negQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
        }
        else
        {
            _negativeFeedbackLabel.text = [NSString stringWithFormat:@"%d", count];
            [_ratingDict setValue:[NSNumber numberWithInt:count] forKey:FEEDBACK_RATING_NEGATIVE];
        }
    }];
}

/*
 * Retrieve all whunts posted by one user. Sort it in such a way that unfulfilled whunts are on top and fulfilled whunts are 
 * at the bottom.
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveMyWantList
//-------------------------------------------------------------------------------------------------------------------------------
{
    _myWantDataList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_ITEM_IS_DELETED equalTo:STRING_OF_NO];
    [query whereKey:PF_ITEM_BUYER_ID equalTo:_profileOwner.objectId];
    [query orderByDescending:PF_CREATED_AT];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            for (PFObject *object in objects)
            {
                WantData *wantData = [[WantData alloc] initWithPFObject:object];
                [_myWantDataList addObject:wantData];
            }
            
            [self sortMyWhuntsList];
            
            [self updateTotalListingNumLabel:_myWantDataList.count numListingsDisplayed:YES];
            
            [_historyCollectionView reloadData];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

/*
 * Sort my whunts list in such a way that unfulfilled whunts are on top and fulfilled whunts are at the bottom.
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void) sortMyWhuntsList
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableArray *unfulfilledWhunts = [[NSMutableArray alloc] init];
    NSMutableArray *fulfilledWhunts = [[NSMutableArray alloc] init];
    
    for (WantData *wantData in _myWantDataList)
    {
        if (wantData.isFulfilled)
            [fulfilledWhunts addObject:wantData];
        else
            [unfulfilledWhunts addObject:wantData];
    }
    
    [unfulfilledWhunts addObjectsFromArray:fulfilledWhunts];
    _myWantDataList = unfulfilledWhunts;
}

/*
 * Retrieve a list of whunts in which I act as a seller. The whunts includes those already fulfilled and those not yet fulfilled.
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveMySellList
//-------------------------------------------------------------------------------------------------------------------------------
{
    _mySellDataList = [[NSMutableArray alloc] init];
    _myOngoingSellDataList = [[NSMutableArray alloc] init];
    _myCompletedSellDataList = [[NSMutableArray alloc] init];
    
    _count = 0;
    
    _loadingCompletedDataDone = NO;
    _loadingOngoingDataDone = NO;
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    // retrieve TransactionData from ongoing table
    [self retrieveSellingTransactionDataFromTable:PF_ONGOING_TRANSACTION_CLASS completionBlock:^{
        [_mySellDataList addObjectsFromArray:_myOngoingSellDataList];
        
        if (_loadingCompletedDataDone)
        {
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            
            [_mySellDataList addObjectsFromArray:_myCompletedSellDataList];
            [_historyCollectionView reloadData];
            
            _scrollView.contentOffset = CGPointMake(_segmentedControl.frame.origin.x, _segmentedControl.frame.origin.y - 200.0f);
        }
        else
            _loadingOngoingDataDone = YES;
    }];
    
    // retrieve TransactionData from completed table
    [self retrieveSellingTransactionDataFromTable:PF_ACCEPTED_TRANSACTION_CLASS completionBlock:^{
        if (_loadingOngoingDataDone)
        {
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            
            [_mySellDataList addObjectsFromArray:_myCompletedSellDataList];
            [_historyCollectionView reloadData];
            
            _scrollView.contentOffset = CGPointMake(_segmentedControl.frame.origin.x, _segmentedControl.frame.origin.y - 200.0f);
        }
        else
            _loadingCompletedDataDone = YES;
    }];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveSellingTransactionDataFromTable: (NSString *) tableName completionBlock: (CompletionHandler) handler
//-------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *currentUser = _profileOwner;
    
    PFQuery *query = [PFQuery queryWithClassName:tableName];
    [query whereKey:@"sellerID" equalTo:currentUser.objectId];
    [query orderByDescending:PF_UPDATED_AT];
    [query findObjectsInBackgroundWithBlock:^(NSArray *offerObjects, NSError *error)
    {
        if (!error)
        {
            // Update listings number
            _count += offerObjects.count;
            if (_ongoingOrAcceptedTableLoaded)
            {
                [self updateTotalListingNumLabel:_count numListingsDisplayed:YES];
                
                if (_count == 0)
                    [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            }
            else
            {
                _ongoingOrAcceptedTableLoaded = YES;
            }
            
            // Update history collection view
            if (offerObjects.count == 0)
            {
                if ([tableName isEqualToString:PF_ONGOING_TRANSACTION_CLASS])
                    _loadingOngoingDataDone = YES;
                else
                    _loadingCompletedDataDone = YES;
            }
            else
            {
                __block NSInteger count = 0;
                
                for (int i=0; i<offerObjects.count; i++)
                {
                    if ([tableName isEqualToString:PF_ONGOING_TRANSACTION_CLASS])
                        [_myOngoingSellDataList addObject:[[WantData alloc] init]];
                    else
                        [_myCompletedSellDataList addObject:[[WantData alloc] init]];
                }
                
                for (int i=0; i<offerObjects.count; i++)
                {
                    PFObject *object = [offerObjects objectAtIndex:i];
                    NSString *itemID = object[@"itemID"];
                    PFQuery *sQuery = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
                    [sQuery getObjectInBackgroundWithId:itemID block:^(PFObject *wantPFObj, NSError *error)
                     {
                         WantData *wantData = [[WantData alloc] initWithPFObject:wantPFObj];
                         if ([tableName isEqualToString:PF_ONGOING_TRANSACTION_CLASS])
                             [_myOngoingSellDataList replaceObjectAtIndex:i withObject:wantData];
                         else
                             [_myCompletedSellDataList replaceObjectAtIndex:i withObject:wantData];
                         
                         count++;
                         
                         if (count == offerObjects.count) // complete loading all whunts in selling section
                         {
                             handler();
                         }
                     }];
                }
            }
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}


#pragma mark - Backend Update

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveLatestWantData
//-------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_ITEM_IS_DELETED equalTo:STRING_OF_NO];
    [query whereKey:@"buyerID" equalTo:_profileOwner.objectId];
    [query orderByDescending:PF_CREATED_AT];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error)
    {
        if (!error)
        {
            WantData *wantData = [[WantData alloc] initWithPFObject:obj];
            [_myWantDataList insertObject:wantData atIndex:0];
            [self updateTotalListingNumLabel:_myWantDataList.count numListingsDisplayed:YES];
            [_historyCollectionView reloadData];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveLatestSellData
//-------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *currentUser = _profileOwner;
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [query whereKey:@"sellerID" equalTo:currentUser.objectId];
    [query orderByDescending:@"updatedAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *offerObject, NSError *error)
    {
        if (!error)
        {
            NSString *itemID = offerObject[@"itemID"];
            PFQuery *sQuery = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
            [sQuery getObjectInBackgroundWithId:itemID block:^(PFObject *wantPFObj, NSError *error)
            {
                WantData *wantData = [[WantData alloc] initWithPFObject:wantPFObj];
                [self replacePrevSellDataIfNecessary:wantData];
                [self updateTotalListingNumLabel:_mySellDataList.count numListingsDisplayed:YES];
                [_historyCollectionView reloadData];
            }];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) replacePrevSellDataIfNecessary: (WantData *) targetedWantData
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (_mySellDataList.count == 0)
    {
        [_mySellDataList addObject:targetedWantData];
        return;
    }
    
    for (int i=0; i<_mySellDataList.count; i++)
    {
        WantData *wantData = [_mySellDataList objectAtIndex:i];
        
        if ([wantData.itemID isEqualToString:targetedWantData.itemID])
        {
            [_mySellDataList removeObject:wantData];
            [_mySellDataList insertObject:targetedWantData atIndex:0];
            break;
        }
        else
        {
            if (i == _mySellDataList.count-1)
            {
                [_mySellDataList insertObject:targetedWantData atIndex:0];
                break;
            }
        }
    }
}

@end
