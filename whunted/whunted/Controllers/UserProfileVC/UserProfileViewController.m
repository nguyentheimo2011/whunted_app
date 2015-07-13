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

#import <Parse/Parse.h>
#import <JTImageButton.h>

#define kTopMargin      WINSIZE.width / 30.0

//-------------------------------------------------------------------------------------------------------------------------------
@interface UserProfileViewController ()
//-------------------------------------------------------------------------------------------------------------------------------

@end

//-------------------------------------------------------------------------------------------------------------------------------
@implementation UserProfileViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIScrollView    *_scrollView;
    UIView          *_topRightView;
    
    UILabel         *_positiveFeedbackLabel;
    UILabel         *_mehFeedbackLabel;
    UILabel         *_negativeFeedbackLabel;
    
    JTImageButton   *_followerButton;
    JTImageButton   *_followingButton;
    JTImageButton   *_preferencesButton;
    
    CGFloat         _statusAndNavBarHeight;
    CGFloat         _tabBarHeight;
    CGFloat         _currHeight;
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
    [self.view setBackgroundColor:LIGHTEST_GRAY_COLOR];
    
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
    CGFloat const kButtonWidth = WINSIZE.width / 3.5;
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonLeftMargin = WINSIZE.width / 28.0;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    _followerButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonLeftMargin, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_followerButton createTitle:@"0\n follower" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:17] iconOffsetY:0];
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
    CGFloat const kButtonWidth = WINSIZE.width / 3.5;
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonXPos = 2 * WINSIZE.width / 28.0 + WINSIZE.width / 3.5;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    _followingButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_followingButton createTitle:@"0\n following" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:17] iconOffsetY:0];
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
    CGFloat const kButtonWidth = WINSIZE.width / 3.5;
    CGFloat const kButtonHeight = 60;
    CGFloat const kButtonXPos = 3 * WINSIZE.width / 28.0 + 2 * WINSIZE.width / 3.5;
    CGFloat const kButtonTopMargin = (backgroundView.frame.size.height - kButtonHeight)/2.0;
    
    _preferencesButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonTopMargin, kButtonWidth, kButtonHeight)];
    [_preferencesButton createTitle:@"Preferences" withIcon:nil font:[UIFont fontWithName:LIGHT_FONT_NAME size:17] iconOffsetY:0];
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
    
    _currHeight += kBackgroundTopMargin + kBackgroundHeight;
}

#pragma mark - Event Handlers



@end
