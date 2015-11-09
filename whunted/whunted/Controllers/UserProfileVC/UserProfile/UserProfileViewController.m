//
//  UserProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UserProfileViewController.h"
#import "HistoryCollectionViewCell.h"
#import "PreferenceViewController.h"
#import "FeedbackReviewVC.h"
#import "FeedbackData.h"
#import "MarketplaceCollectionViewCell.h"
#import "ItemDetailsViewController.h"
#import "ProfileImageCache.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>
#import <HMSegmentedControl.h>

#define kTopMargin      WINSIZE.width / 30.0
#define kLeftMargin     WINSIZE.width / 30.0

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
    
    UIView                      *_leftHorizontalLine;
    UIView                      *_rightHorizontalLine;
    
    HMSegmentedControl          *_segmentedControl;
    
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
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    [Utilities logOutMessage:@"UserProfileViewController didReceiveMemoryWarning"];
}

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
    [self addPreferencesAndSettingsButtons];
    [self addSaperatorLineAndInfoLabel];
    [self addDate_Verification_DescriptionLabels];
    [self addUserDescription];
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
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMargin + 5, WINSIZE.width * 0.6, kBackgroundHeight)];
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
    CGFloat const kIconHeight = kBackgroundHeight * 0.8;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.08;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *smilingFaceImage = [UIImage imageNamed:@"smiling_face.png"];
    UIImageView *smilingFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [smilingFaceImageView setImage:smilingFaceImage];
    [containerView addSubview:smilingFaceImageView];
    
    _positiveFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _positiveFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:20];
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
    CGFloat const kIconHeight = kBackgroundHeight * 0.8;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.1;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *mehFaceImage = [UIImage imageNamed:@"meh_face.png"];
    UIImageView *mehFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [mehFaceImageView setImage:mehFaceImage];
    [containerView addSubview:mehFaceImageView];
    
    _mehFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _mehFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:20];
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
    CGFloat const kIconHeight = kBackgroundHeight * 0.8;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.12;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + 2 * kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *sadFaceImage = [UIImage imageNamed:@"sad_face.png"];
    UIImageView *sadFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [sadFaceImageView setImage:sadFaceImage];
    [containerView addSubview:sadFaceImageView];
    
    _negativeFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _negativeFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:20];
    _negativeFeedbackLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _negativeFeedbackLabel.text = @"0";
    [containerView addSubview:_negativeFeedbackLabel];
    
    [backgroundView addSubview:containerView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferencesAndSettingsButtons
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
        [self addSettingsButtonToView:backgroundView];
    }
    else
    {
        [self addFollowButtonToView:backgroundView];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferencesButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth = (backgroundView.frame.size.width - 10) / 2;
    CGFloat const kButtonHeight = backgroundView.frame.size.height;
    CGFloat const kButtonOriginX = 0;
    
    JTImageButton *preferencesButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, 0, kButtonWidth, kButtonHeight)];
    [preferencesButton createTitle:NSLocalizedString(@"Preferences", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:16] iconOffsetY:0];
    
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
- (void) addSettingsButtonToView: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonHeight = backgroundView.frame.size.height;
    CGFloat kButtonWidth = (backgroundView.frame.size.width - 10) / 2;
    CGFloat kButtonOriginX = kButtonWidth + 10;
    
    JTImageButton *settingsButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, 0, kButtonWidth, kButtonHeight)];
    [settingsButton createTitle:NSLocalizedString(@"Settings", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:16] iconOffsetY:0];
    
    // TODO: colors are likely to change
    settingsButton.bgColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    settingsButton.borderColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    settingsButton.titleColor = TEXT_COLOR_DARK_GRAY;
    
    settingsButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    settingsButton.cornerRadius = 6.0;
    [settingsButton addTarget:self action:@selector(settingsButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:settingsButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFollowButtonToView: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonHeight = backgroundView.frame.size.height;
    CGFloat const kButtonWidth = backgroundView.frame.size.width;
    CGFloat kButtonOriginX = 0;
    
    JTImageButton *followButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, 0, kButtonWidth, kButtonHeight)];
    [followButton createTitle:NSLocalizedString(@"+ Follow", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:14] iconOffsetY:0];
    
    // TODO: colors are likely to change
    followButton.bgColor = [UIColor whiteColor];
    followButton.borderColor = MAIN_BLUE_COLOR_WITH_DARK_2;
    followButton.borderWidth = 1.3f;
    followButton.titleColor = MAIN_BLUE_COLOR_WITH_DARK_2;
    
    followButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    followButton.cornerRadius = 6.0;
    followButton.enabled = NO;
    [backgroundView addSubview:followButton];
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
    CGFloat const kLabelOriginY = _currHeight;
    
    _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, kLabelOriginY, WINSIZE.width - 2 * kLeftMargin, kLabelHeight)];
    _countryLabel.text = _profileOwner[PF_USER_COUNTRY];
    _countryLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE];
    _countryLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_scrollView addSubview:_countryLabel];
    
    _currHeight += kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSaperatorLineAndInfoLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = NSLocalizedString(@"Info", nil);
    infoLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:16];
    infoLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [infoLabel sizeToFit];
    
    CGFloat const kLabelWidth = infoLabel.frame.size.width;
    CGFloat const kLabelHeight = infoLabel.frame.size.height;
    CGFloat const kLabelLeftMargin = WINSIZE.width / 2.0 - kLabelWidth / 2.0;
    CGFloat const kLabelTopMargin = WINSIZE.height / 96.0;
    CGFloat const kLabelYPos = _currHeight + kLabelTopMargin;
    infoLabel.frame = CGRectMake(kLabelLeftMargin, kLabelYPos, kLabelWidth, kLabelHeight);
    [_scrollView addSubview:infoLabel];
    
    // add two horizontal lines beside the total listing label
    CGFloat const kFirstLineLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kLineWidth = kLabelLeftMargin - 5 - kFirstLineLeftMargin;
    CGFloat const kLineYPos = kLabelYPos + kLabelHeight / 2.0;
    CGFloat const kSecondLineXPos = WINSIZE.width / 2.0 + kLabelWidth / 2.0 + 5;
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(kFirstLineLeftMargin, kLineYPos, kLineWidth, 1)];
    leftLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_5;
    [_scrollView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(kSecondLineXPos, kLineYPos, kLineWidth, 1)];
    rightLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_5;
    [_scrollView addSubview:rightLine];
    
    _currHeight += kLabelTopMargin + kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addDate_Verification_DescriptionLabels
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addJoiningDate];
    [self addVerificationInfo];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addJoiningDate
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSDate *joiningDate = _profileOwner.createdAt;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit  fromDate:joiningDate];
    
    CGFloat const kLabelLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kLabelTopMargin = WINSIZE.height / 96.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLabelLeftMargin;
    CGFloat const kLabelHeight = 20;
    UILabel *joiningDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kYPos, kLabelWidth, kLabelHeight)];
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
    CGFloat const kBackgroundLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kBackgroundTopMargin = WINSIZE.height / 192.0;
    CGFloat const kYPos = _currHeight + kBackgroundTopMargin;
    CGFloat const kBackgroundWidth = WINSIZE.width - 2 * kBackgroundLeftMargin;
    CGFloat const kBackgroundHeight = 20;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kBackgroundLeftMargin, kYPos, kBackgroundWidth, kBackgroundHeight)];
    [_scrollView addSubview:backgroundView];
    
    UILabel *verifiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, kBackgroundHeight)];
    verifiedLabel.text = NSLocalizedString(@"Verified", nil);
    verifiedLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    verifiedLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [verifiedLabel sizeToFit];
    
    BOOL facebookVerified = (BOOL) _profileOwner[PF_USER_FACEBOOK_VERIFIED];
    if (facebookVerified)
    {
        [backgroundView addSubview:verifiedLabel];
        
        UIImage *fbImage = [UIImage imageNamed:@"fb_verification.png"];
        
        CGFloat const kImageWith = 16;
        CGFloat const kImageLeftMargin = verifiedLabel.frame.size.width + 8;
        
        UIImageView *fbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftMargin, 2, kImageWith, kImageWith)];
        [fbImageView setImage:fbImage];
        [backgroundView addSubview:fbImageView];
    }
    
    BOOL emailVerified = (BOOL) _profileOwner[PF_USER_EMAIL_VERIFICATION];
    if (emailVerified)
    {
        UIImage *emailImage = [UIImage imageNamed:@"email_verification.png"];
        
        CGFloat const kImageWith = 20;
        CGFloat kImageLeftMargin;
        if (facebookVerified)
            kImageLeftMargin = verifiedLabel.frame.size.width + 2 * 8 + kImageWith;
        else
            kImageLeftMargin = verifiedLabel.frame.size.width + 8;
        
        UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftMargin, 0, kImageWith, kImageWith)];
        [emailImageView setImage:emailImage];
        [backgroundView addSubview:emailImageView];
    }
    
    _currHeight += kBackgroundTopMargin + kBackgroundHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserDescription
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kLabelTopMargin = WINSIZE.height / 192.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLabelLeftMargin;
    CGFloat const kMaxNumOfLines = 40;
    
    _userDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kYPos, kLabelWidth, 0)];
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
- (void) addControls
//-------------------------------------------------------------------------------------------------------------------------------
{
//    [self addListGridViewControl];
    [self addSegmentedControl];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addListGridViewControl
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kControlLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kControlTopMargin = WINSIZE.height / 24.0;
    CGFloat const kYPos = _currHeight + kControlTopMargin;
    CGFloat const kControlWidth = 35;
    
    JTImageButton *listGridViewControl = [[JTImageButton alloc] initWithFrame:CGRectMake(kControlLeftMargin, kYPos, kControlWidth, kControlWidth)];
    [listGridViewControl createTitle:@"" withIcon:[UIImage imageNamed:@"grid_view_icon.png"] font:nil iconHeight:kControlWidth-10 iconOffsetY:JTImageButtonIconOffsetYNone];
    listGridViewControl.borderColor = TEXT_COLOR_DARK_GRAY;
    listGridViewControl.tag = 0;
    [listGridViewControl addTarget:self action:@selector(listGridViewButtonTapEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:listGridViewControl];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kControlLeftMargin = WINSIZE.width / 4.0;
    CGFloat const kControlTopMargin = WINSIZE.height / 36.0;
    CGFloat const kYPos = _currHeight + kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width / 2.0;
    CGFloat const kControlHeight = 35;
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(kControlLeftMargin, kYPos, kControlWidth, kControlHeight)];
    _segmentedControl.sectionTitles = @[NSLocalizedString(@"Buying", nil), NSLocalizedString(@"Selling", nil)];
    
    _segmentedControl.selectedSegmentIndex = 0;
    
    /// TODO: colors are likely to change
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:17], NSForegroundColorAttributeName : TEXT_COLOR_LESS_DARK};
    _segmentedControl.backgroundColor = MAIN_BLUE_COLOR_WITH_WHITE_1;
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _segmentedControl.selectionIndicatorColor = MAIN_BLUE_COLOR_WITH_DARK_1;
    _segmentedControl.layer.cornerRadius = 5.0f;
    _segmentedControl.clipsToBounds = YES;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
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
    [_historyCollectionView registerClass:[HistoryCollectionViewCell class] forCellWithReuseIdentifier:@"HistoryCollectionViewCell"];
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
    if (_curViewMode == HistoryCollectionViewModeBuying)
    {
        HistoryCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionViewCell" forIndexPath:indexPath];
        cell.cellIndex = indexPath.row;
        
        if (cell.wantData == nil)
        {
            [cell initCell];
        }
        else
        {
            [cell clearCellUI];
        }
        
        WantData *wantData = [_myWantDataList objectAtIndex:indexPath.row];
        [cell setWantData:wantData];
        
        return cell;
    }
    else
    {
       MarketplaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarketplaceCollectionViewCell" forIndexPath:indexPath];
        cell.cellIndex = indexPath.row;
        cell.cellIdentifier = CELL_IN_USER_PROFILE;
        
        if (cell.wantData == nil)
            [cell initCell];
        else
            [cell clearCellUI];
        
        WantData *wantData = [_mySellDataList objectAtIndex:indexPath.row];
        [cell setWantData:wantData];
        
        return cell;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_curViewMode == HistoryCollectionViewModeBuying)
    {
        return [Utilities sizeOfSimplifiedCollectionCell];
    }
    else
    {
        return [Utilities sizeOfFullCollectionCell];
    }
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
        itemDetailsVC.wantData = [_myWantDataList objectAtIndex:indexPath.row];
    else
        itemDetailsVC.wantData = [_mySellDataList objectAtIndex:indexPath.row];
    
    itemDetailsVC.itemImagesNum = itemDetailsVC.wantData.itemPicturesNum;
    
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
- (void) segmentedControlSwitchEventHandler: (HMSegmentedControl *) segmentedControl
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
    
    if (_curViewMode == HistoryCollectionViewModeBuying)
    {
        CGFloat const kCellHeight = [Utilities sizeOfSimplifiedCollectionCell].height;
        NSInteger listSize = _myWantDataList.count;
        _collectionViewCurrHeight = ((listSize + 1) / 2) * (kCellHeight + kYDistanceBetweenCell);
    }
    else
    {
        CGFloat const kCellHeight = [Utilities sizeOfFullCollectionCell].height;
        NSInteger listSize = _mySellDataList.count;
        _collectionViewCurrHeight = ((listSize + 1) / 2) * (kCellHeight + kYDistanceBetweenCell);
    }
    
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
