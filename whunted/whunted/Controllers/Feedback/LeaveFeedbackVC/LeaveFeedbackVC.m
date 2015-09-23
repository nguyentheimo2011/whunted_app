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
#import <MBProgressHUD.h>

#define     kRatingCellHeight           95.0f
#define     kSecondCellHeight           50.0f
#define     kFeedbackCommentHeight      150.0f
#define     kFourthCellHeight           32.0f

#define     kHeaderHeight               10.0f
#define     kFooterHeight               0.01f;

#define     kMaxNumOfChars              500

//-----------------------------------------------------------------------------------------------------------------------------
@implementation LeaveFeedbackVC
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableViewCell         *_ratingCell;
    UITableViewCell         *_secondCell;
    UITableViewCell         *_feedbackCommentCell;
    UITableViewCell         *_numOfCharsLeftCell;
    
    SZTextView              *_feedbackCommentTextView;
    
    UISegmentedControl      *_ratingSegmentedControl;
    
    NSInteger               _numOfCharsLeft;
}

@synthesize delegate            =   _delegate;
@synthesize offerData           =   _offerData;
@synthesize receiverUsername    =   _receiverUsername;
@synthesize feedbackData        =   _feedbackData;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithOfferData: (TransactionData *) offerData
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self)
    {
        _offerData = offerData;
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self initCells];
    
    if (_feedbackData)
        [self updateUI];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"LeaveFeedbackScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) setFeedbackData:(FeedbackData *)feedbackData
//------------------------------------------------------------------------------------------------------------------------------
{
    _feedbackData = feedbackData;
}


#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    // customize title
    NSString *title = NSLocalizedString(@"Leave Feedback", nil);
    [Utilities customizeTitleLabel:title forViewController:self];
    
    [self.view setBackgroundColor:LIGHTEST_GRAY_COLOR];
    
    [Utilities customizeBackButtonForViewController:self withAction:@selector(skipBarButtonTapEventHandler)];
    
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
    
    CGFloat const kControlLeftMargin = 16.0f;
    CGFloat const kControlTopMargin = 15.0f;
    CGFloat const kControlYPos = kLabelTopMargin + kLabelHeight + kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width - 2 * kControlLeftMargin;
    CGFloat const kControlHeight = 30.0f;
    NSArray *ratings = @[@"Positive", @"Neutral", @"Negative"];
    _ratingSegmentedControl = [[UISegmentedControl alloc] initWithItems:ratings];
    _ratingSegmentedControl.frame = CGRectMake(kControlLeftMargin, kControlYPos, kControlWidth, kControlHeight);
    [_ratingSegmentedControl setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_FONT} forState:UIControlStateNormal];
    _ratingSegmentedControl.selectedSegmentIndex = 0;
    [_ratingSegmentedControl setImage:[UIImage imageNamed:@"smiling_face_small.png"] forSegmentAtIndex:0];
    [_ratingSegmentedControl setImage:[UIImage imageNamed:@"meh_face_small.png"] forSegmentAtIndex:1];
    [_ratingSegmentedControl setImage:[UIImage imageNamed:@"sad_face_small.png"] forSegmentAtIndex:2];
    _ratingSegmentedControl.tintColor = MAIN_BLUE_COLOR;
    [_ratingCell addSubview:_ratingSegmentedControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initSecondCell
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *purchasingRole;
    NSString *description;
    if ([Utilities amITheBuyer:_offerData])
    {
        description = NSLocalizedString(@"Describe your experience with seller", nil);
        purchasingRole = NSLocalizedString(@"as a seller", nil);
    }
    else
    {
        description = NSLocalizedString(@"Describe your experience with buyer", nil);
        purchasingRole = NSLocalizedString(@"as a buyer", nil);
    }
    
    _secondCell = [[UITableViewCell alloc] init];
    _secondCell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", description, _receiverUsername, purchasingRole];
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
    
    
    _feedbackCommentTextView = [[SZTextView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 32, kFeedbackCommentHeight - 10)];
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateUI
//------------------------------------------------------------------------------------------------------------------------------
{
    // update rating segmented control
    if (_feedbackData.rating == FeedbackRatingPositive)
        _ratingSegmentedControl.selectedSegmentIndex = 0;
    else if (_feedbackData.rating == FeedbackRatingNeutral)
        _ratingSegmentedControl.selectedSegmentIndex = 1;
    else
        _ratingSegmentedControl.selectedSegmentIndex = 2;
    
    // update comment text view
    _feedbackCommentTextView.text = _feedbackData.comment;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFUser *currUser = [PFUser currentUser];
    
    if (!_feedbackData)
        _feedbackData = [[FeedbackData alloc] init];
    
    _feedbackData.writerID = currUser.objectId;
    if ([Utilities amITheBuyer:_offerData])
    {
        _feedbackData.receiverID = _offerData.sellerID;
        _feedbackData.isWriterTheBuyer = YES;
    }
    else
    {
        _feedbackData.receiverID = _offerData.buyerID;
        _feedbackData.isWriterTheBuyer = NO;
    }
    
    if (_ratingSegmentedControl.selectedSegmentIndex == 0)
        _feedbackData.rating = FeedbackRatingPositive;
    else if (_ratingSegmentedControl.selectedSegmentIndex == 1)
        _feedbackData.rating = FeedbackRatingNeutral;
    else
        _feedbackData.rating = FeedbackRatingNegative;
    
    if (_feedbackCommentTextView.text)
        _feedbackData.comment = _feedbackCommentTextView.text;
    else
        _feedbackData.comment = @"";
    
    [self saveDataToRemoteServer:_feedbackData];
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
//-------------------------------------------------------------------------------------------------------------------------------
{
    // text view has no more than kMaxNumOfChars chars
    
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (newLength <= kMaxNumOfChars)
    {
        // if the new text has the length of less than kMaxNumOfChars chars, then apply the changes
        _numOfCharsLeft = kMaxNumOfChars - newLength;
        _numOfCharsLeftCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)_numOfCharsLeft];
        return YES;
    } else
    {
        // otherwise, take only part of the text
        NSUInteger maxAddedLen = kMaxNumOfChars - (textView.text.length - range.length);
        NSString *subText = [text substringToIndex:maxAddedLen];
        NSString *newText = [NSString stringWithFormat:@"%@%@", textView.text, subText];
        textView.text = newText;
        
        // update num of chars
        _numOfCharsLeft = 0;
        _numOfCharsLeftCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)_numOfCharsLeft];
        return NO;
    }
}


#pragma mark - Backend

//-------------------------------------------------------------------------------------------------------------------------------
- (void) saveDataToRemoteServer: (FeedbackData *) feedbackData
//----------------------------------------------------------------------------------------------------------------------------
{
    PFObject *obj = [feedbackData pfObjectFromFeedbackData];
    [obj saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (!success)
            NSLog(@"%@ %@", error, [error userInfo]);
        else
            [_delegate leaveFeedBackViewController:self didCompleteGivingFeedBack:feedbackData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
