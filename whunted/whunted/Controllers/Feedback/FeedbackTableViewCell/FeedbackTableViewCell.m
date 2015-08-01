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
#define kProfilePictureLeftMargin   10.0f

@implementation FeedbackTableViewCell
{
    UIImageView     *_userProfilePicture;
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
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addUserProfilePicture];
//        [self addFeedbackCommentTextView];
        [self addWriterUsernameLabel];
    }
    
    return self;
}

#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserProfilePicture
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kPictureTopMargin = 10.0f;
    
    _userProfilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(kProfilePictureLeftMargin, kPictureTopMargin, kProfilePictureWidth, kProfilePictureWidth)];
    _userProfilePicture.layer.cornerRadius = kProfilePictureWidth / 2.0;
    _userProfilePicture.backgroundColor = MAIN_BLUE_COLOR;
    [self addSubview:_userProfilePicture];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addWriterUsernameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kUsernameLabelLeftMargin = kProfilePictureWidth + 2 * kProfilePictureLeftMargin - 5;
    CGFloat const kUsernameLabelTopMargin = 0.0f;
    
    _writerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(kUsernameLabelLeftMargin, kUsernameLabelTopMargin, 0, 0)];
    _writerUsernameButton.titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    [_writerUsernameButton setTitle:@"nguyentheimo2011" forState:UIControlStateNormal];
    [_writerUsernameButton setTitle:@"2011" forState:UIControlStateHighlighted];
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
    CGFloat const kTextViewLeftMargin = kProfilePictureWidth + 2 * kProfilePictureLeftMargin - 5;
    CGFloat const kTextViewTopMargin = 5.0f;
    CGFloat const kTextViewBottomMargin = 10.0f;
    CGFloat const kTextViewWidth = WINSIZE.width - 2 * kTextViewLeftMargin;
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(kTextViewLeftMargin, kTextViewTopMargin, kTextViewWidth, 0)];
    _commentTextView.text = @"Excellent seller! Will certainly deal again in future.";
    _commentTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    [_commentTextView sizeToFit];
    [self addSubview:_commentTextView];
    
    _cellHeight = kTextViewTopMargin + _commentTextView.frame.size.height + kTextViewBottomMargin;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"usernameButtonTapEventHandler");
}

@end
