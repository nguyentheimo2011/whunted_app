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
#import "Utilities.h"
#import "AppConstant.h"

#define kControlContainerHeight     60.0f
#define kFeedbackCellIdentifier     @"FeedbackTableViewCell"

@implementation FeedbackReviewVC
{
    UITableView         *_feedbackTableView;
    
    UISegmentedControl  *_categorySegmentedControl;
}

@synthesize feedbackList = _feedbackList;

//-----------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self customizeUI];
    [self addTableView];
    [self addSegmentedControl];
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
    NSMutableArray *array = [NSMutableArray array];
    
    FeedbackData *feedback_1 = [[FeedbackData alloc] init];
    feedback_1.writerID = @"TvXZJZLPd8";
    feedback_1.rating = FeedbackRatingPositive;
    feedback_1.comment = @"One of the best buyer ever. Hope to deal with you again!";
    feedback_1.buyerID = @"jqHLAimRS6";
    feedback_1.sellerID = @"TvXZJZLPd8";
    feedback_1.createdDate = [Utilities dateFromCommonlyFormattedString:@"20/7/2015"];
    feedback_1.modifiedDate = feedback_1.createdDate;
    [array addObject:feedback_1];
    
    FeedbackData *feedback_2 = [[FeedbackData alloc] init];
    feedback_2.writerID = @"jqHLAimRS6";
    feedback_2.rating = FeedbackRatingPositive;
    feedback_2.comment = @"Excellent seller! Definitely will deal again!";
    feedback_2.buyerID = @"jqHLAimRS6";
    feedback_2.sellerID = @"TvXZJZLPd8";
    feedback_2.createdDate = [Utilities dateFromCommonlyFormattedString:@"21/7/2015"];
    feedback_2.modifiedDate = feedback_2.createdDate;
    [array addObject:feedback_2];
    
    FeedbackData *feedback_3 = [[FeedbackData alloc] init];
    feedback_3.writerID = @"TvXZJZLPd8";
    feedback_3.rating = FeedbackRatingNeutral;
    feedback_3.comment = @"Normal seller! May not put on priority!";
    feedback_3.buyerID = @"TvXZJZLPd8";
    feedback_3.sellerID = @"jqHLAimRS6";
    feedback_3.createdDate = [Utilities dateFromCommonlyFormattedString:@"22/7/2015"];
    feedback_3.modifiedDate = feedback_3.createdDate;
    [array addObject:feedback_3];
    
    FeedbackData *feedback_4 = [[FeedbackData alloc] init];
    feedback_4.writerID = @"jqHLAimRS6";
    feedback_4.rating = FeedbackRatingNegative;
    feedback_4.comment = @"worst buyer ever. Never show up until I called him!";
    feedback_4.buyerID = @"TvXZJZLPd8";
    feedback_4.sellerID = @"jqHLAimRS6";
    feedback_4.createdDate = [Utilities dateFromCommonlyFormattedString:@"23/7/2015"];
    feedback_4.modifiedDate = feedback_4.createdDate;
    [array addObject:feedback_4];
    
    _feedbackList = [NSArray arrayWithArray:array];
}

#pragma mark - UI Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:@"+10 / 0 / -0" forViewController:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    NSArray *categories = @[@"All", @"As Seller", @"As Buyer"];
    _categorySegmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    _categorySegmentedControl.frame = CGRectMake(kControlLeftMargin, kControlTopMargin, kControlWidth, kControlHeight);
    [_categorySegmentedControl setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_FONT} forState:UIControlStateNormal];
    _categorySegmentedControl.selectedSegmentIndex = 0;
    [segmentContainer addSubview:_categorySegmentedControl];
    
    CGFloat const kSeparatorLineLeftMargin = 15.0f;
    CGFloat const kSeparatorLineHeight = 0.75f;
    CGFloat const kSeparatorLineWidth = WINSIZE.width - kSeparatorLineLeftMargin;
    CGFloat const kSeparatorLineYPos = kControlContainerHeight - kSeparatorLineHeight;
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kSeparatorLineLeftMargin, kSeparatorLineYPos, kSeparatorLineWidth, kSeparatorLineHeight)];
    [separatorLine setBackgroundColor:CELL_SEPARATOR_GRAY_COLOR];
    [segmentContainer addSubview:separatorLine];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableHeight = WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self];

    _feedbackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kControlContainerHeight, WINSIZE.width, kTableHeight)];
    _feedbackTableView.backgroundColor = LIGHTEST_GRAY_COLOR;
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
    return [_feedbackList count];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    FeedbackTableViewCell *cell = (FeedbackTableViewCell *) [_feedbackTableView dequeueReusableCellWithIdentifier:kFeedbackCellIdentifier];
    
    if (!cell) {
        cell = [[FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFeedbackCellIdentifier];
        [cell setFeedbackData:[_feedbackList objectAtIndex:indexPath.row]];
    }
    
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
    static FeedbackTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [_feedbackTableView dequeueReusableCellWithIdentifier:kFeedbackCellIdentifier];
        [cell setFeedbackData:[_feedbackList objectAtIndex:indexPath.row]];
    });
    
    return cell.cellHeight;
}

@end
