//
//  FeedbackReviewVC.m
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "FeedbackReviewVC.h"
#import "FeedbackTableViewCell.h"
#import "FeedbackData.h"
#import "UserProfileViewController.h"
#import "Utilities.h"
#import "AppConstant.h"

#define     kControlContainerHeight         60.0f
#define     kFeedbackCellIdentifier         @"FeedbackTableViewCell"

//----------------------------------------------------------------------------------------------------------------------------
@implementation FeedbackReviewVC
//----------------------------------------------------------------------------------------------------------------------------
{
    UITableView             *_feedbackTableView;
    
    UISegmentedControl      *_categorySegmentedControl;
    
    NSArray                 *_categorizedFeedbackList;
}

@synthesize feedbackList    =   _feedbackList;
@synthesize ratingDict      =   _ratingDict;

//-----------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    [self addNotificationListener];
    [self customizeUI];
    [self addTableView];
    [self addSegmentedControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"FeedbackTableScreen"];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Data Init

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//-------------------------------------------------------------------------------------------------------------------------------
{    
    _categorizedFeedbackList = [NSMutableArray arrayWithArray:_feedbackList];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationListener
//-------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameButtonTapEventHandler:) name:NOTIFICATION_USERNAME_BUTTON_TAP_EVENT object:nil];
}


#pragma mark - UI Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Utilities customizeTitleLabel:[NSString stringWithFormat:@"+%@ / %@ / -%@", [_ratingDict objectForKey:FEEDBACK_RATING_POSITIVE], [_ratingDict objectForKey:FEEDBACK_RATING_NEUTRAL], [_ratingDict objectForKey:FEEDBACK_RATING_NEGATIVE]] forViewController:self];
    
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kContainerYPos = [Utilities getHeightOfNavigationAndStatusBars:self];
    UIView *segmentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kContainerYPos, WINSIZE.width, kControlContainerHeight)]
    ;
    [segmentContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:segmentContainer];
    
    CGFloat const kControlTopMargin = 15.0f;
    CGFloat const kControlLeftMargin = 30.0f;
    CGFloat const kControlHeight = kControlContainerHeight - 2 * kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width - 2 * kControlLeftMargin;
    
    NSArray *categories = @[NSLocalizedString(@"All", nil), NSLocalizedString(@"As Seller", nil), NSLocalizedString(@"As Buyer", nil)];
    _categorySegmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    _categorySegmentedControl.frame = CGRectMake(kControlLeftMargin, kControlTopMargin, kControlWidth, kControlHeight);
    _categorySegmentedControl.tintColor = MAIN_BLUE_COLOR;
    [_categorySegmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE]} forState:UIControlStateNormal];
    _categorySegmentedControl.selectedSegmentIndex = 0;
    [_categorySegmentedControl addTarget:self action:@selector(categorySegmentedControlSelectedIndexChange) forControlEvents:UIControlEventValueChanged];
    [segmentContainer addSubview:_categorySegmentedControl];
    
    CGFloat const kSeparatorLineLeftMargin = 15.0f;
    CGFloat const kSeparatorLineHeight = 0.75f;
    CGFloat const kSeparatorLineWidth = WINSIZE.width - kSeparatorLineLeftMargin;
    CGFloat const kSeparatorLineYPos = kControlContainerHeight - kSeparatorLineHeight;
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kSeparatorLineLeftMargin, kSeparatorLineYPos, kSeparatorLineWidth, kSeparatorLineHeight)];
    [separatorLine setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_5];
    [segmentContainer addSubview:separatorLine];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableHeight = WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self];

    _feedbackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kControlContainerHeight, WINSIZE.width, kTableHeight)];
    _feedbackTableView.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
    _feedbackTableView.dataSource = self;
    _feedbackTableView.delegate = self;
    [_feedbackTableView registerClass:[FeedbackTableViewCell class] forCellReuseIdentifier:kFeedbackCellIdentifier];
    [self.view addSubview:_feedbackTableView];
}


#pragma mark - UITableViewDataSource methods

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------
{
    return [_categorizedFeedbackList count];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    FeedbackTableViewCell *cell = (FeedbackTableViewCell *) [_feedbackTableView dequeueReusableCellWithIdentifier:kFeedbackCellIdentifier];
    
    if (!cell)
    {
        cell = [[FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFeedbackCellIdentifier];
    }
    
    [cell setFeedbackData:[_categorizedFeedbackList objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------
{
    return 0.01f;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    
    FeedbackTableViewCell *cell = [[FeedbackTableViewCell alloc] init];
    [cell setFeedbackData:[_categorizedFeedbackList objectAtIndex:indexPath.row]];
    
    return cell.cellHeight;
}


#pragma mark - Event Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) categorySegmentedControlSelectedIndexChange
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (_categorySegmentedControl.selectedSegmentIndex == 0)
    {
        _categorizedFeedbackList = [NSArray arrayWithArray:_feedbackList];
        [_feedbackTableView reloadData];
    }
    else if (_categorySegmentedControl.selectedSegmentIndex == 1)
    {
        _categorizedFeedbackList = [NSArray arrayWithArray:[self getFeedbacksAsSeller:_feedbackList]];
        [_feedbackTableView reloadData];
    }
    else
    {
        _categorizedFeedbackList = [NSArray arrayWithArray:[self getFeedbacksAsBuyer:_feedbackList]];
        [_feedbackTableView reloadData];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler: (NSNotification *) notification
//-------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewUserProfileEvent" label:@"BuyerUsernameButton" value:nil];
    
    UserHandler handler = ^(PFUser *user) {
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    NSString *userID = notification.object;
    [Utilities retrieveUserInfoByUserID:userID andRunBlock:handler];
}


#pragma mark - Helpers

//-------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) getFeedbacksAsSeller: (NSArray *) feedbackList
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (FeedbackData *feedback in feedbackList)
    {
        if (feedback.isWriterTheBuyer)
            [array addObject:feedback];
    }
    
    return array;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSArray *) getFeedbacksAsBuyer: (NSArray *) feedbackList
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (FeedbackData *feedback in feedbackList)
    {
        if (!feedback.isWriterTheBuyer)
            [array addObject:feedback];
    }
    
    return array;
}

@end
