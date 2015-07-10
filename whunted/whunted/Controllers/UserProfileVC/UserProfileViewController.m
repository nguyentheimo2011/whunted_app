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
    
    CGFloat         _statusAndNavBarHeight;
    CGFloat         _tabBarHeight;
    
    CGFloat         _kLabelHeight;
    CGFloat         _kTopMargin;
}

@synthesize delegate = _delegate;

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    [self customizeView];
    [self addScrollView];
    [self addProfileImage];
    [self addUserFullNameLabel];
    [self addCountryLabel];
    [self addRatingView];
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
    
    _kLabelHeight = 20;
    _kTopMargin = (WINSIZE.width * 0.3 - 75) / 2;
    UILabel *userFullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _kTopMargin, WINSIZE.width * 0.5, _kLabelHeight)];
    userFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", [PFUser currentUser][PF_USER_FIRSTNAME], [PFUser currentUser][PF_USER_LASTNAME]];
    userFullNameLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:18];
    userFullNameLabel.textColor = [UIColor blackColor];
    [_topRightView addSubview:userFullNameLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addCountryLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _kTopMargin + _kLabelHeight, WINSIZE.width * 0.5, _kLabelHeight)];
    countryLabel.text = [PFUser currentUser][PF_USER_COUNTRY];
    countryLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
    countryLabel.textColor = [UIColor grayColor];
    [_topRightView addSubview:countryLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addRatingView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat backgroundHeight = 25;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _kTopMargin + 2 * _kLabelHeight + 10, WINSIZE.width * 0.6, backgroundHeight)];
    [backgroundView setBackgroundColor:BACKGROUND_GRAY_COLOR];
    backgroundView.layer.cornerRadius = 4;
    backgroundView.clipsToBounds = YES;
    [_topRightView addSubview:backgroundView];
}

#pragma mark - Event Handlers



@end
