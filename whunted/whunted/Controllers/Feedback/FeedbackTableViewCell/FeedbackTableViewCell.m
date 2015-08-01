//
//  FeedbackTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "AppConstant.h"

#import <JTImageButton.h>

#define kProfilePictureWidth        40.0f
#define kProfilePictureMargin       10.0f

#define kRatingContainerWidth       40.0f

@implementation FeedbackTableViewCell
{
    UIImageView     *_userProfilePicture;
    UIImageView     *_ratingImageView;
    UITextView      *_commentTextView;
    UIButton        *_writerUsernameButton;
    
}

@synthesize cellHeight = _cellHeight;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addUserProfilePicture];
        [self addWriterUsernameLabel];
        [self addFeedbackCommentTextView];
        [self addRatingImageView];
    }
    
    return self;
}

#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserProfilePicture
//-------------------------------------------------------------------------------------------------------------------------------
{
    _userProfilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(kProfilePictureMargin, kProfilePictureMargin, kProfilePictureWidth, kProfilePictureWidth)];
    _userProfilePicture.layer.cornerRadius = kProfilePictureWidth / 2.0;
    _userProfilePicture.backgroundColor = MAIN_BLUE_COLOR;
    [self addSubview:_userProfilePicture];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addWriterUsernameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kUsernameLabelLeftMargin = kProfilePictureWidth + 2 * kProfilePictureMargin;
    CGFloat const kUsernameLabelTopMargin = 0.0f;
    
    _writerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(kUsernameLabelLeftMargin, kUsernameLabelTopMargin, 0, 0)];
    _writerUsernameButton.titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    [_writerUsernameButton setTitle:@"nguyentheimo2011" forState:UIControlStateNormal];
    [_writerUsernameButton setTitle:@"nguyentheimo2011" forState:UIControlStateHighlighted];
    [_writerUsernameButton setTitleColor:TEA_ROSE_COLOR forState:UIControlStateNormal];
    [_writerUsernameButton setTitleColor:LIGHTEST_GRAY_COLOR forState:UIControlStateHighlighted];
    [_writerUsernameButton sizeToFit];
    [_writerUsernameButton addTarget:self action:@selector(usernameButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_writerUsernameButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFeedbackCommentTextView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextViewLeftMargin = kProfilePictureWidth + 2 * kProfilePictureMargin;
    CGFloat const kTextViewTopMargin = _writerUsernameButton.frame.size.height - 5;
    CGFloat const kTextViewBottomMargin = 10.0f;
    CGFloat const kTextViewWidth = WINSIZE.width - kTextViewLeftMargin - kRatingContainerWidth;
    CGFloat const kTextViewTopInset = -10.0f;
    CGFloat const KTextViewBottomInset = -5.0f;
    CGFloat const kTextViewLeftInset = -5.0f;
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(kTextViewLeftMargin, kTextViewTopMargin, kTextViewWidth, 0)];
    _commentTextView.text = @"Excellent seller! Will certainly deal again in future.";
    _commentTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _commentTextView.contentInset = UIEdgeInsetsMake(kTextViewTopInset, kTextViewLeftInset, KTextViewBottomInset, 0);
    [_commentTextView sizeToFit];
    _commentTextView.frame = CGRectMake(kTextViewLeftMargin, kTextViewTopMargin, kTextViewWidth, _commentTextView.frame.size.height + kTextViewTopInset + KTextViewBottomInset);
    [self addSubview:_commentTextView];
    
    _cellHeight = kTextViewTopMargin + _commentTextView.frame.size.height + kTextViewBottomMargin;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addRatingImageView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kRatingImageViewMargin = 10.0f;
    CGFloat const kRatingImageViewXPos = WINSIZE.width - (kRatingContainerWidth - kRatingImageViewMargin);
    CGFloat const kRatingImageViewWidth = kRatingContainerWidth - 2 * kRatingImageViewMargin;
    
    _ratingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kRatingImageViewXPos, kProfilePictureMargin, kRatingImageViewWidth, kRatingImageViewWidth)];
    UIImage *ratingImage = [UIImage imageNamed:@"smiling_face.png"];
    [_ratingImageView setImage:ratingImage];
    [self addSubview:_ratingImageView];
}

#pragma mark - Event Handler

//-------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    
}

@end
