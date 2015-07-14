//
//  UserProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AppConstant.h"
#import "PersistedCache.h"
#import "HistoryCollectionViewCell.h"

#import <Parse/Parse.h>
#import <JTImageButton.h>
#import <HMSegmentedControl.h>

#define kTopMargin      WINSIZE.width / 30.0

//-------------------------------------------------------------------------------------------------------------------------------
@interface UserProfileViewController ()
//-------------------------------------------------------------------------------------------------------------------------------

@end

//-------------------------------------------------------------------------------------------------------------------------------
@implementation UserProfileViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIScrollView        *_scrollView;
    UIView              *_topRightView;
    
    UILabel             *_positiveFeedbackLabel;
    UILabel             *_mehFeedbackLabel;
    UILabel             *_negativeFeedbackLabel;
    
    UILabel             *_totalListingsNumLabel;
    
    JTImageButton       *_followerButton;
    JTImageButton       *_followingButton;
    JTImageButton       *_preferencesButton;
    
    UICollectionView    *_historyCollectionView;
    
    CGFloat             _statusAndNavBarHeight;
    CGFloat             _tabBarHeight;
    CGFloat             _currHeight;
}

@synthesize delegate = _delegate;

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    [self customizeView];
    [self addScrollView];
    [self addProfileImage_Name_Country_Rating];
    [self addFollower_Following_PreferencesButtons];
    [self addDate_Verification_DescriptionLabels];
    [self addUserDescription];
    [self addControls];
    [self addTotalListingsNumLabel];
    [self addHistoryCollectionView];
    [self addAllDisplayedLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"UserProfileViewController didReceiveMemoryWarning");
}

#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeView
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"@%@", [PFUser currentUser][PF_USER_USERNAME]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
    
    _currHeight = WINSIZE.width * 0.3;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addProfileImage
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIView *profileBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * 0.3, WINSIZE.width * 0.3)];
    [_scrollView addSubview:profileBg];
    
    UIImage *profileImage = [[PersistedCache sharedCache] imageForKey:[PFUser currentUser].objectId];
    CGFloat const kMarginWidth = WINSIZE.width / 30.0;
    CGFloat const kImageWidth = WINSIZE.width * 0.3 - 2 * kMarginWidth;
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginWidth, kMarginWidth, kImageWidth, kImageWidth)];
    [profileImageView setImage:profileImage];
    profileImageView.layer.cornerRadius = kImageWidth/2;
    profileImageView.clipsToBounds = YES;
    [profileBg addSubview:profileImageView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserFullNameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    _topRightView = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.3, 0, WINSIZE.width * 0.7, WINSIZE.width * 0.3)];
    [_scrollView addSubview:_topRightView];
    
    CGFloat const kLabelHeight = WINSIZE.width / 16.0;
    UILabel *userFullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopMargin, WINSIZE.width * 0.5, kLabelHeight)];
    userFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", [PFUser currentUser][PF_USER_FIRSTNAME], [PFUser currentUser][PF_USER_LASTNAME]];
    userFullNameLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:18];
    userFullNameLabel.textColor = [UIColor blackColor];
    [_topRightView addSubview:userFullNameLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addCountryLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelHeight = WINSIZE.width / 16.0;
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopMargin + kLabelHeight, WINSIZE.width * 0.5, kLabelHeight)];
    countryLabel.text = [PFUser currentUser][PF_USER_COUNTRY];
    countryLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
    countryLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_topRightView addSubview:countryLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addRatingView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelHeight = WINSIZE.width / 16.0;
    CGFloat const kWhiteSpaceWidth = WINSIZE.width / 32.0;
    CGFloat const kBackgroundHeight = WINSIZE.width * 0.3 - 2 * kTopMargin - 2 * kLabelHeight - kWhiteSpaceWidth;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMargin + 2 * kLabelHeight + kWhiteSpaceWidth, WINSIZE.width * 0.6, kBackgroundHeight)];
    [backgroundView setBackgroundColor:BACKGROUND_GRAY_COLOR];
    backgroundView.layer.cornerRadius = 4;
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
    _positiveFeedbackLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:20];
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
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.05;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *mehFaceImage = [UIImage imageNamed:@"meh_face.png"];
    UIImageView *mehFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [mehFaceImageView setImage:mehFaceImage];
    [containerView addSubview:mehFaceImageView];
    
    _mehFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _mehFeedbackLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:20];
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
    CGFloat const kIconLeftMargin = kBackgroundWidth * 0.05;
    CGFloat const kIconTopMargin = kBackgroundHeight * 0.1;
    CGFloat const kSpaceWidth = (kBackgroundWidth - kIconHeight) / 3.0;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kIconLeftMargin + 2 * kSpaceWidth, kIconTopMargin, kIconHeight * 3, kIconHeight)];
    
    UIImage *sadFaceImage = [UIImage imageNamed:@"sad_face.png"];
    UIImageView *sadFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconHeight, kIconHeight)];
    [sadFaceImageView setImage:sadFaceImage];
    [containerView addSubview:sadFaceImageView];
    
    _negativeFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconHeight + 5, 0, kIconHeight * 2 -5, kIconHeight)];
    _negativeFeedbackLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:20];
    _negativeFeedbackLabel.textColor = TEXT_COLOR_DARK_GRAY;
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
    CGFloat const kButtonWidth = WINSIZE.width / 3.6;
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    _followerButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonLeftMargin, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_followerButton createTitle:@"0\n follower" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:16] iconOffsetY:0];
    _followerButton.bgColor = BACKGROUND_GRAY_COLOR;
    _followerButton.borderColor = BACKGROUND_GRAY_COLOR;
    _followerButton.titleColor = TEXT_COLOR_DARK_GRAY;
    _followerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _followerButton.cornerRadius = 10.0;
    [backgroundView addSubview:_followerButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFollowingButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth = WINSIZE.width / 3.6;
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonXPos = 2 * WINSIZE.width / 28.0 + WINSIZE.width / 3.6;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    _followingButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_followingButton createTitle:@"0\n following" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:16] iconOffsetY:0];
    _followingButton.bgColor = BACKGROUND_GRAY_COLOR;
    _followingButton.borderColor = BACKGROUND_GRAY_COLOR;
    _followingButton.titleColor = TEXT_COLOR_DARK_GRAY;
    _followingButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _followingButton.cornerRadius = 10.0;
    [backgroundView addSubview:_followingButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPreferencesButton: (UIView *) backgroundView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth = WINSIZE.width * (6/7.0 - 2/3.6);
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonXPos = 3 * WINSIZE.width / 28.0 + 2 * WINSIZE.width / 3.6;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    _preferencesButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_preferencesButton createTitle:@"Preferences" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:16] iconOffsetY:0];
    _preferencesButton.bgColor = BACKGROUND_GRAY_COLOR;
    _preferencesButton.borderColor = BACKGROUND_GRAY_COLOR;
    _preferencesButton.titleColor = TEXT_COLOR_DARK_GRAY;
    _preferencesButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _preferencesButton.cornerRadius = 10.0;
    [backgroundView addSubview:_preferencesButton];
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
    NSDate *joiningDate = [PFUser currentUser].createdAt;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit  fromDate:joiningDate];
    
    CGFloat const kLabelLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kLabelTopMargin = WINSIZE.height / 48.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLabelLeftMargin;
    CGFloat const kLabelHeight = 20;
    UILabel *joiningDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kYPos, kLabelWidth, kLabelHeight)];
    joiningDateLabel.text = [NSString stringWithFormat:@"Joined on %ld/%ld/%ld", (long)components.day, (long)components.month, (long)components.year];
    joiningDateLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
    joiningDateLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_scrollView addSubview:joiningDateLabel];
    
    _currHeight += kLabelTopMargin + kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addVerificationInfo
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kBackgroundLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kBackgroundTopMargin = WINSIZE.height / 96.0;
    CGFloat const kYPos = _currHeight + kBackgroundTopMargin;
    CGFloat const kBackgroundWidth = WINSIZE.width - 2 * kBackgroundLeftMargin;
    CGFloat const kBackgroundHeight = 20;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kBackgroundLeftMargin, kYPos, kBackgroundWidth, kBackgroundHeight)];
    [_scrollView addSubview:backgroundView];
    
    UILabel *verifiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, kBackgroundHeight)];
    verifiedLabel.text = @"Verified";
    verifiedLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
    verifiedLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [verifiedLabel sizeToFit];
    [backgroundView addSubview:verifiedLabel];
    
    BOOL facebookVerified = (BOOL) [PFUser currentUser][PF_USER_FACEBOOK_VERIFIED];
    if (facebookVerified) {
        UIImage *fbImage = [UIImage imageNamed:@"fb_verification.png"];
        
        CGFloat const kImageWith = 16;
        CGFloat const kImageLeftMargin = verifiedLabel.frame.size.width + 8;
        
        UIImageView *fbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftMargin, 2, kImageWith, kImageWith)];
        [fbImageView setImage:fbImage];
        [backgroundView addSubview:fbImageView];
    }
    
    BOOL emailVerified = (BOOL) [PFUser currentUser][PF_USER_EMAIL_VERIFICATION];
    if (emailVerified) {
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
    CGFloat const kLabelTopMargin = WINSIZE.height / 96.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLabelLeftMargin;
    CGFloat const kMaxNumOfLines = 40;
    
    UILabel *userDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kYPos, kLabelWidth, 0)];
    userDescriptionLabel.text = [PFUser currentUser][PF_USER_DESCRIPTION];
    userDescriptionLabel.textColor = TEXT_COLOR_DARK_GRAY;
    userDescriptionLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
    userDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    userDescriptionLabel.numberOfLines = kMaxNumOfLines;
    [userDescriptionLabel sizeToFit];
    [_scrollView addSubview:userDescriptionLabel];
    
    _currHeight += kLabelTopMargin + userDescriptionLabel.frame.size.height;
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
    CGFloat const kControlTopMargin = WINSIZE.height / 24.0;
    CGFloat const kYPos = _currHeight + kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width / 2.0;
    CGFloat const kControlHeight = 35;
    
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(kControlLeftMargin, kYPos, kControlWidth, kControlHeight)];
    segmentedControl.sectionTitles = @[@"Bought", @"Sold"];
    
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:LIGHT_FONT_NAME size:17], NSForegroundColorAttributeName : TEXT_COLOR_DARK_GRAY};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    [segmentedControl addTarget:self action:@selector(segmentedControlSwitchEventHandler:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:segmentedControl];
    
    _currHeight += kControlTopMargin + kControlHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addTotalListingsNumLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    _totalListingsNumLabel = [[UILabel alloc] init];
    _totalListingsNumLabel.text = @"0 Listings";
    _totalListingsNumLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
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
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(kFirstLineLeftMargin, kLineYPos, kLineWidth, 1)];
    leftLine.backgroundColor = LIGHT_GRAY_COLOR;
    [_scrollView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(kSecondLineXPos, kLineYPos, kLineWidth, 1)];
    rightLine.backgroundColor = LIGHT_GRAY_COLOR;
    [_scrollView addSubview:rightLine];
    
    _currHeight += kLabelTopMargin + kLabelHeight;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addHistoryCollectionView
//-------------------------------------------------------------------------------------------------------------------------------
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat const kCellHeight = WINSIZE.width/2.0 + 70;
    CGFloat const kYDistanceBetweenCell = 20;
    CGFloat const kCollectionViewHeight = 5 * kCellHeight + 4 * kYDistanceBetweenCell;
    CGFloat const kCollectionTopMargin = WINSIZE.height / 48.0;
    CGFloat const kCollectionYPos = _currHeight + kCollectionTopMargin;
    _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kCollectionYPos, WINSIZE.width, kCollectionViewHeight) collectionViewLayout:layout];
    _historyCollectionView.dataSource = self;
    _historyCollectionView.delegate = self;
    _historyCollectionView.backgroundColor = [UIColor whiteColor];
    [_historyCollectionView registerClass:[HistoryCollectionViewCell class] forCellWithReuseIdentifier:@"HistoryCollectionViewCell"];
    [_scrollView addSubview:_historyCollectionView];
    
    _currHeight += kCollectionViewHeight + kCollectionTopMargin;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addAllDisplayedLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *allDisplayedLabel = [[UILabel alloc] init];
    allDisplayedLabel.text = @"All displayed";
    allDisplayedLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    allDisplayedLabel.textColor = LIGHT_GRAY_COLOR;
    [allDisplayedLabel sizeToFit];
    
    CGFloat const kLabelWidth = allDisplayedLabel.frame.size.width;
    CGFloat const kLabelHeight = allDisplayedLabel.frame.size.height;
    CGFloat const kLabelLeftMargin = WINSIZE.width / 2.0 - kLabelWidth / 2.0;
    CGFloat const kLabelTopMargin = WINSIZE.height / 24.0;
    CGFloat const kYPos = _currHeight + kLabelTopMargin;
    allDisplayedLabel.frame = CGRectMake(kLabelLeftMargin, kYPos, kLabelWidth, kLabelHeight);
    [_scrollView addSubview:allDisplayedLabel];
    
    _currHeight +=  2 * kLabelTopMargin + kLabelHeight;
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, _currHeight)];
}

#pragma mark - CollectionView datasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 10;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    HistoryCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionViewCell" forIndexPath:indexPath];
    
    if (cell.itemImageView == nil) {
        [cell initCell];
    }
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellWidth = WINSIZE.width/2.0 - 15;
    CGFloat const kCellHeight = kCellWidth + 85;
    
    return CGSizeMake(kCellWidth, kCellHeight);
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 10.0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 15.0;
}

#pragma mark - Event Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) listGridViewButtonTapEventHandler: (id) sender
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kIconHeight = 25;
    
    JTImageButton *listGridViewControl = (JTImageButton *) sender;
    if (listGridViewControl.tag == 0) {
        [listGridViewControl createTitle:nil withIcon:[UIImage imageNamed:@"list_view_icon.png"] font:nil iconHeight:kIconHeight iconOffsetY:JTImageButtonIconOffsetYNone];
        listGridViewControl.tag = 1;
    } else {
        [listGridViewControl createTitle:@"" withIcon:[UIImage imageNamed:@"grid_view_icon.png"] font:nil iconHeight:kIconHeight iconOffsetY:JTImageButtonIconOffsetYNone];
        listGridViewControl.tag = 0;
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) segmentedControlSwitchEventHandler: (HMSegmentedControl *) segmentedControl
//-------------------------------------------------------------------------------------------------------------------------------
{
//    NSLog(@"segmentedControlSwitchEventHandler %d", segmentedControl.selectedSegmentIndex);
}

@end
