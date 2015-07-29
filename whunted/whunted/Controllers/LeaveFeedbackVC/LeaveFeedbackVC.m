//
//  LeaveFeedbackVC.m
//  whunted
//
//  Created by thomas nguyen on 29/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "LeaveFeedbackVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#define kRatingCellHeight       100.0f
#define kSecondCellHeight       80.0f
#define kFeedbackCommentHeight  80.0f
#define kFourthCellHeight       40.0f

#define kHeaderHeight           30.0f
#define kFooterHeight           0.01f;

@implementation LeaveFeedbackVC
{
    UITableViewCell     *_ratingCell;
    UITableViewCell     *_secondCell;
    UITableViewCell     *_feedbackCommentCell;
    UITableViewCell     *_numOfCharsLeftCell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self initCells];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    // customize title
    NSString *title = NSLocalizedString(@"Leave Feedback", nil);
    [Utilities customizeTitleLabel:title forViewController:self];
    
    [self.view setBackgroundColor:LIGHTEST_GRAY_COLOR];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Skip", nil) style:UIBarButtonItemStylePlain target:self action:@selector(skipBarButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submitBarButtonTapEventHandler)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//------------------------------------------------------------------------------------------------------------------------------
{
    [self initRatingCell];
    [self initSecondCell];
    [self initFeedbackCommentCell];
    [self initNumOfWordsLeftCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initRatingCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _ratingCell = [[UITableViewCell alloc] init];
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSecondCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _secondCell = [[UITableViewCell alloc] init];
    _secondCell.textLabel.text = NSLocalizedString(@"Describe your experience with ABC as a seller", nil);
    _secondCell.textLabel.font = DEFAULT_FONT;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initFeedbackCommentCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _feedbackCommentCell = [[UITableViewCell alloc] init];
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initNumOfWordsLeftCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _numOfCharsLeftCell = [[UITableViewCell alloc] init];
    _numOfCharsLeftCell.detailTextLabel.text = @"500";
    _numOfCharsLeftCell.detailTextLabel.font = DEFAULT_FONT;
}

#pragma mark - Table view data source

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 4;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0)
        return _ratingCell;
    else if (indexPath.row == 1)
        return _secondCell;
    else if (indexPath.row == 2)
        return _feedbackCommentCell;
    else
        return _numOfCharsLeftCell;
}

#pragma mark - UITableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0)
        return kRatingCellHeight;
    else if (indexPath.row == 1)
        return kSecondCellHeight;
    else if (indexPath.row == 2)
        return kFeedbackCommentHeight;
    else
        return kFourthCellHeight;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return kHeaderHeight;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return kFooterHeight;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) submitBarButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) skipBarButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

@end
