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

#import <SZTextView.h>

#define kRatingCellHeight       95.0f
#define kSecondCellHeight       50.0f
#define kFeedbackCommentHeight  150.0f
#define kFourthCellHeight       32.0f

#define kHeaderHeight           10.0f
#define kFooterHeight           0.01f;

#define kMaxNumOfChars          500

@implementation LeaveFeedbackVC
{
    UITableViewCell     *_ratingCell;
    UITableViewCell     *_secondCell;
    UITableViewCell     *_feedbackCommentCell;
    UITableViewCell     *_numOfCharsLeftCell;
    
    SZTextView          *_feedbackCommentTextView;
    
    NSInteger           _numOfCharsLeft;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self initCells];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data Init

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _numOfCharsLeft = kMaxNumOfChars;
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
    
    // remove cell separator
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
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
    _ratingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.text = NSLocalizedString(@"How was your experience?", nil);
    questionLabel.font = DEFAULT_FONT;
    [questionLabel sizeToFit];
    
    CGFloat const kLabelTopMargin = 10.0f;
    CGFloat const kLabelWidth = questionLabel.frame.size.width;
    CGFloat const kLabelHeight = questionLabel.frame.size.height;
    CGFloat const kLabelLeftMargin = WINSIZE.width/2.0 - kLabelWidth/2.0;
    questionLabel.frame = CGRectMake(kLabelLeftMargin, kLabelTopMargin, kLabelWidth, kLabelHeight);
    [_ratingCell addSubview:questionLabel];
    
    CGFloat const kControlLeftMargin = 10.0f;
    CGFloat const kControlTopMargin = 15.0f;
    CGFloat const kControlYPos = kLabelTopMargin + kLabelHeight + kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width - 2 * kControlLeftMargin;
    CGFloat const kControlHeight = 30.0f;
    NSArray *ratings = @[@"Positive", @"Neutral", @"Negative"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:ratings];
    segmentedControl.frame = CGRectMake(kControlLeftMargin, kControlYPos, kControlWidth, kControlHeight);
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_FONT} forState:UIControlStateNormal];
    segmentedControl.selectedSegmentIndex = 0;
    [_ratingCell addSubview:segmentedControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSecondCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _secondCell = [[UITableViewCell alloc] init];
    _secondCell.textLabel.text = NSLocalizedString(@"Describe your experience with nguyentheimo2011 as a seller", nil);
    _secondCell.textLabel.font = DEFAULT_FONT;
    _secondCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _secondCell.textLabel.numberOfLines = 2;
    _secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initFeedbackCommentCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _feedbackCommentCell = [[UITableViewCell alloc] init];
    _feedbackCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _feedbackCommentTextView = [[SZTextView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 35, kFeedbackCommentHeight - 10)];
    _feedbackCommentTextView.layer.borderWidth = 1.0f;
    _feedbackCommentTextView.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    _feedbackCommentTextView.layer.cornerRadius = 10.0f;
    _feedbackCommentTextView.font = DEFAULT_FONT;
    _feedbackCommentTextView.placeholder = NSLocalizedString(@"Example:\n Item was in great condition, very prompt delivery. Will deal again!\n\n kudos!:D", nil);
    _feedbackCommentTextView.delegate = self;
    
    _feedbackCommentCell.accessoryView = _feedbackCommentTextView;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initNumOfWordsLeftCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _numOfCharsLeftCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"numOfCharsCell"];
    _numOfCharsLeftCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)_numOfCharsLeft];
    _numOfCharsLeftCell.detailTextLabel.font = DEFAULT_FONT;
    _numOfCharsLeftCell.detailTextLabel.textColor = [UIColor blackColor];
    _numOfCharsLeftCell.selectionStyle = UITableViewCellSelectionStyleNone;
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [_feedbackCommentTextView resignFirstResponder];
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) submitBarButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) skipBarButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//------------------------------------------------------------------------------------------------------------------------------
{
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (newLength <= kMaxNumOfChars) {
        _numOfCharsLeft = kMaxNumOfChars - newLength;
        _numOfCharsLeftCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)_numOfCharsLeft];
        return YES;
    } else {
        NSUInteger maxAddedLen = kMaxNumOfChars - (textView.text.length - range.length);
        NSString *subText = [text substringToIndex:maxAddedLen];
        NSString *newText = [NSString stringWithFormat:@"%@%@", textView.text, subText];
        textView.text = newText;
        _numOfCharsLeft = 0;
        _numOfCharsLeftCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)_numOfCharsLeft];
        return NO;
    }
}

@end