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
    
    CGFloat         _statusAndNavBarHeight;
    CGFloat         _tabBarHeight;
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
    countryLabel.textColor = [UIColor grayColor];
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
    _positiveFeedbackLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
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
    _mehFeedbackLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
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
    _negativeFeedbackLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
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

#pragma mark - Event Handlers



@end
