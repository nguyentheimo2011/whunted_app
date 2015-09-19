//
//  FeedbackTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "ProfileImageCache.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <JTImageButton.h>

#define kProfilePictureWidth                    40.0f
#define kProfilePictureMargin                   10.0f
#define kProfilePictureContainerWidth           60.0f

#define kRatingContainerWidth                   40.0f

#define kClockImageWidth                        12.0f
#define kClockImageHeight                       12.0f


//----------------------------------------------------------------------------------------------------------------------------
@implementation FeedbackTableViewCell
//----------------------------------------------------------------------------------------------------------------------------
{
    UIImageView             *_userProfilePicture;
    UIImageView             *_ratingImageView;
    UIImageView             *_clockImageView;
    UITextView              *_commentTextView;
    UIButton                *_writerUsernameButton;
    UILabel                 *_timestampLabel;
    UILabel                 *_purchasingRoleLabel;
}

@synthesize cellHeight      =   _cellHeight;
@synthesize feedbackData    =   _feedbackData;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) setFeedbackData:(FeedbackData *)feedbackData
//-------------------------------------------------------------------------------------------------------------------------------
{
    _feedbackData = feedbackData;
    
    [self initUI];
}


#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self clearUI];
    
    [self addUserProfilePicture];
    [self addWriterUsernameLabel];
    [self addFeedbackCommentTextView];
    [self addRatingImageView];
    [self addClockImageView];
    [self addTimestampLabel];
    [self addPurchasingRoleLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserProfilePicture
//-------------------------------------------------------------------------------------------------------------------------------
{
    _userProfilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(kProfilePictureMargin, kProfilePictureMargin, kProfilePictureWidth, kProfilePictureWidth)];
    _userProfilePicture.layer.cornerRadius = kProfilePictureWidth / 2.0;
    _userProfilePicture.clipsToBounds = YES;
    _userProfilePicture.backgroundColor = MAIN_BLUE_COLOR;
    [self addSubview:_userProfilePicture];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", _feedbackData.writerID, USER_PROFILE_IMAGE];
    UIImage *image = [[ProfileImageCache sharedCache] objectForKey:key];
    if (image)
    {
        _userProfilePicture.image = image;
    }
    else
    {
        _userProfilePicture.image = [UIImage imageNamed:@"user_profile_image_placeholder_small@.png"];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addWriterUsernameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kUsernameLabelTopMargin = 0.0f;
    
    _writerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(kProfilePictureContainerWidth, kUsernameLabelTopMargin, 0, 0)];
    _writerUsernameButton.titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    [_writerUsernameButton setTitle:@" " forState:UIControlStateNormal];
    [_writerUsernameButton setTitle:@" " forState:UIControlStateHighlighted];
    [_writerUsernameButton setTitleColor:TEA_ROSE_COLOR forState:UIControlStateNormal];
    [_writerUsernameButton setTitleColor:LIGHTEST_GRAY_COLOR forState:UIControlStateHighlighted];
    [_writerUsernameButton sizeToFit];
    [_writerUsernameButton addTarget:self action:@selector(usernameButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_writerUsernameButton];
    
    FetchedUserHandler handler = ^(PFUser *user, UIImage *image)
    {
        [_writerUsernameButton setTitle:user[PF_USER_USERNAME] forState:UIControlStateNormal];
        [_writerUsernameButton setTitle:user[PF_USER_USERNAME] forState:UIControlStateHighlighted];
        [_writerUsernameButton sizeToFit];
        
        [_userProfilePicture setImage:image];
    };
    
    [Utilities getUserWithID:_feedbackData.writerID andRunBlock:handler];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addFeedbackCommentTextView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextViewTopMargin = _writerUsernameButton.frame.size.height - 5;
    CGFloat const kTextViewWidth = WINSIZE.width - kProfilePictureContainerWidth - kRatingContainerWidth;
    CGFloat const kTextViewTopInset = -10.0f;
    CGFloat const KTextViewBottomInset = -5.0f;
    CGFloat const kTextViewLeftInset = -5.0f;
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(kProfilePictureContainerWidth, kTextViewTopMargin, kTextViewWidth, 0)];
    _commentTextView.text = _feedbackData.comment;
    _commentTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _commentTextView.contentInset = UIEdgeInsetsMake(kTextViewTopInset, kTextViewLeftInset, KTextViewBottomInset, 0);
    [_commentTextView sizeToFit];
    _commentTextView.editable = NO;
    _commentTextView.frame = CGRectMake(kProfilePictureContainerWidth, kTextViewTopMargin, kTextViewWidth, _commentTextView.frame.size.height + kTextViewTopInset);
    [_commentTextView setContentSize:_commentTextView.frame.size];
    [self addSubview:_commentTextView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addRatingImageView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kRatingImageViewMargin = 10.0f;
    CGFloat const kRatingImageViewXPos = WINSIZE.width - (kRatingContainerWidth - kRatingImageViewMargin);
    CGFloat const kRatingImageViewWidth = kRatingContainerWidth - 2 * kRatingImageViewMargin;
    
    _ratingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kRatingImageViewXPos, kProfilePictureMargin, kRatingImageViewWidth, kRatingImageViewWidth)];
    UIImage *ratingImage;
    if (_feedbackData.rating == FeedbackRatingPositive)
    {
        ratingImage = [UIImage imageNamed:@"smiling_face.png"];
    }
    else if (_feedbackData.rating == FeedbackRatingNeutral)
    {
        ratingImage = [UIImage imageNamed:@"meh_face.png"];
    }
    else
    {
        ratingImage = [UIImage imageNamed:@"sad_face.png"];
    }
    
    [_ratingImageView setImage:ratingImage];
    [self addSubview:_ratingImageView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addClockImageView
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kClockImageViewTopMargin = 0.0f;
    CGFloat const kClockImageViewBottomMargin = 5.0f;
    CGFloat const kClockImageViewYPos = _commentTextView.frame.origin.y + _commentTextView.frame.size.height + kClockImageViewTopMargin;
    _clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kProfilePictureContainerWidth, kClockImageViewYPos, kClockImageWidth, kClockImageHeight)];
    UIImage *clockImage = [UIImage imageNamed:@"clock_icon.png"];
    [_clockImageView setImage:clockImage];
    [self addSubview:_clockImageView];
    
    _cellHeight = kClockImageViewYPos + kClockImageHeight + kClockImageViewTopMargin + kClockImageViewBottomMargin;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kTimestampLabelXPos = kProfilePictureContainerWidth + kClockImageWidth + 3;
    CGFloat kTimestampLabelYPos = _clockImageView.frame.origin.y - 5;
    
    _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTimestampLabelXPos, kTimestampLabelYPos, 0, 0)];
    _timestampLabel.text = [Utilities timestampStringFromDate:_feedbackData.updatedDate];
    _timestampLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    _timestampLabel.textColor = LIGHT_GRAY_COLOR;
    [_timestampLabel sizeToFit];
    [self addSubview:_timestampLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPurchasingRoleLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat kPurchasingRoleLabelXPos = _timestampLabel.frame.origin.x + _timestampLabel.frame.size.width + 10.0f;
    
    _purchasingRoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPurchasingRoleLabelXPos, _timestampLabel.frame.origin.y, 0, 0)];
    if (!_feedbackData.isWriterTheBuyer)
        _purchasingRoleLabel.text = NSLocalizedString(@"As Buyer", nil);
    else
        _purchasingRoleLabel.text = NSLocalizedString(@"As Seller", nil);
    _purchasingRoleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    [_purchasingRoleLabel sizeToFit];
    [self addSubview:_purchasingRoleLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) clearUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    [_userProfilePicture removeFromSuperview];
    [_writerUsernameButton removeFromSuperview];
    [_commentTextView removeFromSuperview];
    [_ratingImageView removeFromSuperview];
    [_clockImageView removeFromSuperview];
    [_timestampLabel removeFromSuperview];
    [_purchasingRoleLabel removeFromSuperview];
}


#pragma mark - Event Handler

//-------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_TAP_EVENT object:_feedbackData.writerID];
}

#pragma mark - Backend

@end
