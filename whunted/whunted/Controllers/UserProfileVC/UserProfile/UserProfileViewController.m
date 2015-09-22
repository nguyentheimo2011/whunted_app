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
#import <MBProgressHUD.h>

#define kTopMargin      WINSIZE.width / 30.0

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
    JTImageButton               *_preferencesButton;
    
    UICollectionView            *_historyCollectionView;
    
    UIImageView                 *_profileImageView;
    UILabel                     *_userFullNameLabel;
    UILabel                     *_countryLabel;
    UILabel                     *_userDescriptionLabel;
    
    UIView                      *_leftHorizontalLine;
    UIView                      *_rightHorizontalLine;
    
    CGFloat                     _statusAndNavBarHeight;
    CGFloat                     _tabBarHeight;
    CGFloat                     _currHeight;
    CGFloat                     _collectionViewOriginY;
    CGFloat                     _collectionViewCurrHeight;
    
    HistoryCollectionViewMode   _curViewMode;
    
    NSMutableDictionary         *_ratingDict;
    NSMutableArray              *_myWantDataList;
    NSMutableArray              *_mySellDataList;
    
    BOOL                        _isViewingMyProfile;
}

@synthesize delegate        =   _delegate;
@synthesize profileOwner    =   _profileOwner;

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
    NSLog(@"UserProfileViewController didReceiveMemoryWarning");
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


#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self customizeView];
    [self addScrollView];
    [self addProfileImage_Name_Country_Rating];
    [self addFollower_Following_PreferencesButtons];
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
    
    if (_isViewingMyProfile)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonTapEventHandler)];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//-------------------------------------------------------------------------------------------------------------------------------
{
    _statusAndNavBarHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    _tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height - _statusAndNavBarHeight - _tabBarHeight)];
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
    
    _currHeight = WINSIZE.width * 0.3;
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
        ImageHandler handler = ^(UIImage *image) {
            _profileImageView.image = image;
        };
        [Utilities retrieveProfileImageForUser:_profileOwner andRunBlock:handler];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserFullNameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    _topRightView = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.3, 0, WINSIZE.width * 0.7, WINSIZE.width * 0.3)];
    [_scrollView addSubview:_topRightView];
    
    CGFloat const kLabelHeight = WINSIZE.width / 16.0;
    _userFullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopMargin, WINSIZE.width * 0.5, kLabelHeight)];
    _userFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", _profileOwner[PF_USER_FIRSTNAME], _profileOwner[PF_USER_LASTNAME]];
    _userFullNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:BIG_FONT_SIZE];
    _userFullNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_topRightView addSubview:_userFullNameLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addCountryLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelHeight = WINSIZE.width / 16.0;
    _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopMargin + kLabelHeight, WINSIZE.width * 0.5, kLabelHeight)];
    _countryLabel.text = _profileOwner[PF_USER_COUNTRY];
    _countryLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _countryLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_topRightView addSubview:_countryLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addRatingView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelHeight = WINSIZE.width / 16.0;
    CGFloat const kWhiteSpaceWidth = WINSIZE.width / 32.0;
    CGFloat const kBackgroundHeight = WINSIZE.width * 0.3 - 2 * kTopMargin - 2 * kLabelHeight - kWhiteSpaceWidth;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMargin + 2 * kLabelHeight + kWhiteSpaceWidth, WINSIZE.width * 0.6, kBackgroundHeight)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ratingViewTapEventHandler)];
    [backgroundView addGestureRecognizer:tapRecognizer];
    
    // TODO: color is likely to change later
    [backgroundView setBackgroundColor:BACKGROUND_GRAY_COLOR];
    
    backgroundView.layer.cornerRadius = 6.0f;
    backgroundView.clipsToBounds = YES;
    [_topRightView addSubview:backgroundView];
    
    [self addSmilingViewToBackground:backgroundView];
    [self addMehViewToBackground:backgroundView];
    [self addSadViewToBackground:backgroundView];
    [self addNextSignToBackground:backgroundView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSmilingViewToBackground: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundHeight = backgroundView.frame.size.height;
    CGFloat const kBackgroundWidth = backgroundView.frame.size.width;
    CGFloat const kIconHeight = kBackgroundHeight * 0.8;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.05;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *smilingFaceImage = [UIImage imageNamed:@"smiling_face.png"];
    UIImageView *smilingFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [smilingFaceImageView setImage:smilingFaceImage];
    [containerView addSubview:smilingFaceImageView];
    
    _positiveFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _positiveFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:20];
    _positiveFeedbackLabel.textColor = DARKER_BLUE_COLOR;
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
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.05;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *mehFaceImage = [UIImage imageNamed:@"meh_face.png"];
    UIImageView *mehFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [mehFaceImageView setImage:mehFaceImage];
    [containerView addSubview:mehFaceImageView];
    
    _mehFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _mehFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:20];
    _mehFeedbackLabel.textColor = DARKER_BLUE_COLOR;
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
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.05;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + 2 * kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *sadFaceImage = [UIImage imageNamed:@"sad_face.png"];
    UIImageView *sadFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [sadFaceImageView setImage:sadFaceImage];
    [containerView addSubview:sadFaceImageView];
    
    _negativeFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _negativeFeedbackLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:20];
    _negativeFeedbackLabel.textColor = DARKER_BLUE_COLOR;
    _negativeFeedbackLabel.text = @"0";
    [containerView addSubview:_negativeFeedbackLabel];
    
    [backgroundView addSubview:containerView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addNextSignToBackground: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundHeight = backgroundView.frame.size.height;
    CGFloat const kBackgroundWidth = backgroundView.frame.size.width;
    CGFloat const kIconHeight = kBackgroundHeight * 0.6;
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.025;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.2;
    CGFloat kXPos = kBackgroundWidth - kIconLeftMargin - kIconHeight;
    
    UIImage *nextSignImage = [UIImage imageNamed:@"move_to_next_icon.png"];
    UIImageView *nextSignImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXPos, kIconTopMargin, kIconHeight, kIconHeight)];
    [nextSignImageView setImage:nextSignImage];
    [backgroundView addSubview:nextSignImageView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFollower_Following_PreferencesButtons
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kYPos = WINSIZE.width * 0.3;
    CGFloat const kBackgroundHeight = 80;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kYPos, WINSIZE.width, kBackgroundHeight)];
    [_scrollView addSubview:backgroundView];
    
    [self addFollowerButton:backgroundView];
    [self addFollowingButton:backgroundView];
    [self addPreferencesButton:backgroundView];
    
    _currHeight += kBackgroundHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFollowerButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat       kButtonWidth = WINSIZE.width / 3.6;
    CGFloat const kButtonHeight = 60;
    CGFloat       kButtonLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    if (!_isViewingMyProfile)
    {
        kButtonLeftMargin = WINSIZE.width * 0.1f;
        kButtonWidth = WINSIZE.width * (1 - 0.3) / 2.0;
    }
    
    NSString *title = [NSString stringWithFormat:@"0\n %@", NSLocalizedString(@"follower", nil)];
    
    _followerButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonLeftMargin, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_followerButton createTitle:title withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:16] iconOffsetY:0];
    
    // TODO: colors are likely to change
    _followerButton.bgColor = DARK_BLUE_COLOR;
    _followerButton.borderColor = DARK_BLUE_COLOR;
    _followerButton.titleColor = [UIColor whiteColor];
    
    _followerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _followerButton.cornerRadius = 10.0;
    [backgroundView addSubview:_followerButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFollowingButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth = _followerButton.frame.size.width;
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonXPos = _followerButton.frame.size.width + 2 * _followerButton.frame.origin.x;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    NSString *title = [NSString stringWithFormat:@"0\n %@", NSLocalizedString(@"following", nil)];
    
    _followingButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_followingButton createTitle:title withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:16] iconOffsetY:0];
    
    // TODO: colors are likely to change
    _followingButton.bgColor = DARK_BLUE_COLOR;
    _followingButton.borderColor = DARK_BLUE_COLOR;
    _followingButton.titleColor = [UIColor whiteColor];
    
    _followingButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _followingButton.cornerRadius = 10.0;
    [backgroundView addSubview:_followingButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferencesButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (_isViewingMyProfile)
    {
        CGFloat const kButtonWidth = WINSIZE.width * (6/7.0 - 2/3.6);
        CGFloat const kButtonHeight = 60;
        CGFloat const kButtonXPos = 3 * WINSIZE.width / 28.0 + 2 * WINSIZE.width / 3.6;
        CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
        
        _preferencesButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonTopMargin, kButtonWidth, kButtonHeight)];
        [_preferencesButton createTitle:NSLocalizedString(@"Preferences", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:16] iconOffsetY:0];
        
        // TODO: colors are likely to change
        _preferencesButton.bgColor = DARK_BLUE_COLOR;
        _preferencesButton.borderColor = DARK_BLUE_COLOR;
        _preferencesButton.titleColor = [UIColor whiteColor];
        
        _preferencesButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _preferencesButton.cornerRadius = 10.0;
        [_preferencesButton addTarget:self action:@selector(preferencesButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:_preferencesButton];
    }
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
    leftLine.backgroundColor = LIGHT_GRAY_COLOR;
    [_scrollView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(kSecondLineXPos, kLineYPos, kLineWidth, 1)];
    rightLine.backgroundColor = LIGHT_GRAY_COLOR;
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
    joiningDateLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
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
    verifiedLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
    verifiedLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [verifiedLabel sizeToFit];
    [backgroundView addSubview:verifiedLabel];
    
    BOOL facebookVerified = (BOOL) _profileOwner[PF_USER_FACEBOOK_VERIFIED];
    if (facebookVerified)
    {
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
    _userDescriptionLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:17];
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
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(kControlLeftMargin, kYPos, kControlWidth, kControlHeight)];
    segmentedControl.sectionTitles = @[NSLocalizedString(@"Buying", nil), NSLocalizedString(@"Selling", nil)];
    
    segmentedControl.selectedSegmentIndex = 0;
    
    /// TODO: colors are likely to change
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:17], NSForegroundColorAttributeName : TEXT_COLOR_DARK_GRAY};
    segmentedControl.backgroundColor = DARK_BLUE_COLOR;
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = MAIN_BLUE_COLOR;
    
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    [segmentedControl addTarget:self action:@selector(segmentedControlSwitchEventHandler:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.layer.cornerRadius = 5.0f;
    
    [_scrollView addSubview:segmentedControl];
    
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
    _leftHorizontalLine.backgroundColor = LIGHT_GRAY_COLOR;
    [_scrollView addSubview:_leftHorizontalLine];
    
    _rightHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(kSecondLineXPos, kLineYPos, kLineWidth, 1)];
    _rightHorizontalLine.backgroundColor = LIGHT_GRAY_COLOR;
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
    _historyCollectionView.backgroundColor  =   LIGHTEST_GRAY_COLOR;
    _historyCollectionView.scrollEnabled    =   NO;
    [_historyCollectionView registerClass:[HistoryCollectionViewCell class] forCellWithReuseIdentifier:@"HistoryCollectionViewCell"];
    [_historyCollectionView registerClass:[MarketplaceCollectionViewCell class] forCellWithReuseIdentifier:@"MarketplaceCollectionViewCell"];
    
    [_scrollView addSubview:_historyCollectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) updateTotalListingNumLabel: (NSInteger) listingsNum
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSString *text = [NSString  stringWithFormat:@"%ld %@", listingsNum, [self getListingTextBasedOnNum:listingsNum]];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        [self.navigationController pushViewController:itemDetailsVC animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        [self updateTotalListingNumLabel:_myWantDataList.count];
    }
    else
    {
        _curViewMode = HistoryCollectionViewModeSelling;
        
        if (!_mySellDataList)
            [self retrieveMySellList];
        else
            [self updateTotalListingNumLabel:_mySellDataList.count];
    }
    
    [_historyCollectionView reloadData];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) resizeHistoryCollectionView
//-------------------------------------------------------------------------------------------------------------------------------
{
    _currHeight -= _collectionViewCurrHeight;
    
    CGFloat const kYDistanceBetweenCell     =   16.0f;
    CGFloat const kCellWidth                =   [Utilities sizeOfFullCollectionCell].width;
    
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
    settingsVC.delegate = self;
    [self.navigationController pushViewController:settingsVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) ratingViewTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    [query whereKey:PF_FEEDBACK_RECEIVER_ID equalTo:_profileOwner.objectId];
    [query orderByAscending:PF_UPDATED_AT];
    [query findObjectsInBackgroundWithBlock:^(NSArray * array, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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


#pragma mark - SettingsTableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) didUpdateProfileInfo
//------------------------------------------------------------------------------------------------------------------------------
{
    [self updateUserData];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateUserData
//------------------------------------------------------------------------------------------------------------------------------
{
//    [_profileImageView setImage:profileImage];
    
    _userFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", _profileOwner[PF_USER_FIRSTNAME], _profileOwner[PF_USER_LASTNAME]];
    
    _countryLabel.text = _profileOwner[PF_USER_COUNTRY];
    
    _userDescriptionLabel.text = _profileOwner[PF_USER_DESCRIPTION];
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
    [posQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (error)
            NSLog(@"%@ %@", error, [error userInfo]);
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
    [neuQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (error)
            NSLog(@"%@ %@", error, [error userInfo]);
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
    [negQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (error)
            NSLog(@"%@ %@", error, [error userInfo]);
        else
        {
            _negativeFeedbackLabel.text = [NSString stringWithFormat:@"%d", count];
            [_ratingDict setValue:[NSNumber numberWithInt:count] forKey:FEEDBACK_RATING_NEGATIVE];
        }
    }];
}

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
            
            [self updateTotalListingNumLabel:_myWantDataList.count];
            
            [_historyCollectionView reloadData];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveMySellList
//-------------------------------------------------------------------------------------------------------------------------------
{
    _mySellDataList = [[NSMutableArray alloc] init];
    
    // retrieve TransactionData from ongoing table
    [self retrieveSellingTransactionDataFromTable:PF_ONGOING_TRANSACTION_CLASS];
    
    // retrieve TransactionData from completed table
    [self retrieveSellingTransactionDataFromTable:PF_ACCEPTED_TRANSACTION_CLASS];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveSellingTransactionDataFromTable: (NSString *) tableName
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
            for (int i=0; i<[offerObjects count]; i++)
            {
                PFObject *object = [offerObjects objectAtIndex:i];
                NSString *itemID = object[@"itemID"];
                PFQuery *sQuery = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
                [sQuery getObjectInBackgroundWithId:itemID block:^(PFObject *wantPFObj, NSError *error)
                {
                    WantData *wantData = [[WantData alloc] initWithPFObject:wantPFObj];
                    [_mySellDataList addObject:wantData];
                    [_historyCollectionView reloadData];
                    
                    if (i == offerObjects.count-1)
                        [self updateTotalListingNumLabel:_mySellDataList.count];
                }];
            }
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

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
            [sQuery getObjectInBackgroundWithId:itemID block:^(PFObject *wantPFObj, NSError *error) {
                WantData *wantData = [[WantData alloc] initWithPFObject:wantPFObj];
                [_mySellDataList insertObject:wantData atIndex:0];
                [_historyCollectionView reloadData];
            }];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

@end
