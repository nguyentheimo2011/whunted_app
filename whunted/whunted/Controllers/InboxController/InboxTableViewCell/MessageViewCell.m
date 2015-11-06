//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <JTImageButton.h>

#import "converter.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "ProfileImageCache.h"
#import "ItemImageCache.h"

#import "MessageViewCell.h"

//------------------------------------------------------------------------------------------------------------------------------
@interface MessageViewCell ()
//------------------------------------------------------------------------------------------------------------------------------
{
	NSDictionary *_message;
}

@end



//------------------------------------------------------------------------------------------------------------------------------
@implementation MessageViewCell
//------------------------------------------------------------------------------------------------------------------------------
{
    UIButton                    *_userProfileImageButton;
    JTImageButton               *_usernameButton;
    UILabel                     *_itemNameLabel;
    UILabel                     *_lastMessageLabel;
    UILabel                     *_transactionStatusLabel;
    UILabel                     *_timestampLabel;
    UIButton                    *_itemImageButton;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCell
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addUserProfileImageButton];
    [self addUsernameButton];
    [self addItemNameLabel];
    [self addLastMessageLabel];
    [self addTransactionStatusLabel];
    [self addTimestampLabel];
    [self addItemImageButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addUserProfileImageButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth  = 50.0f;
    CGFloat const kButtonHeight = 50.0f;
    CGFloat const kButtonOriginX = 10.0f;
    CGFloat const kButtonOriginY = 30.0f;
    
    _userProfileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_userProfileImageButton setBackgroundImage:[UIImage imageNamed:@"user_profile_image_placeholder_big.png"] forState:UIControlStateNormal];
    _userProfileImageButton.layer.cornerRadius = kButtonHeight/2;
    _userProfileImageButton.clipsToBounds = YES;
    [_userProfileImageButton addTarget:self action:@selector(userProfilePicButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userProfileImageButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addUsernameButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonOriginX = 75.0f;
    CGFloat const kButtonOriginY = 7.0f;
    CGFloat const kButtonRightMargin = 92.0f;
    CGFloat const kButtonWidth = WINSIZE.width - kButtonOriginX - kButtonRightMargin;
    CGFloat const kButtonHeight = 18.0f;
    
    _usernameButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_usernameButton createTitle:NSLocalizedString(@"username", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
    _usernameButton.titleColor = TEXT_COLOR_GRAY;
    _usernameButton.bgColor = [UIColor whiteColor];
    _usernameButton.borderWidth = 0;
    _usernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_usernameButton addTarget:self action:@selector(usernameButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_usernameButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX = _usernameButton.frame.origin.x;
    CGFloat const kLabelOriginY = _usernameButton.frame.origin.y + _usernameButton.frame.size.height;
    CGFloat const kLabelWidth = _usernameButton.frame.size.width + 27.0f;
    CGFloat const kLabelHeight = 20.0f;
    
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _itemNameLabel.text = NSLocalizedString(@"Item name", nil);
    _itemNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _itemNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [self addSubview:_itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLastMessageLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX = _usernameButton.frame.origin.x;
    CGFloat const kLabelOriginY = _itemNameLabel.frame.origin.y + _itemNameLabel.frame.size.height;
    CGFloat const kLabelWidth = _usernameButton.frame.size.width + 27.0f;
    CGFloat const kLabelHeight = 40.0f;
    
    _lastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _lastMessageLabel.text = NSLocalizedString(@"Last message\nAgree ya", nil);
    _lastMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE];
    _lastMessageLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _lastMessageLabel.numberOfLines = 2;
    _lastMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_lastMessageLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTransactionStatusLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX = _usernameButton.frame.origin.x;
    CGFloat const kLabelOriginY = _lastMessageLabel.frame.origin.y + _lastMessageLabel.frame.size.height + 5.0f;
    CGFloat const kLabelWidth = 75.0f;
    CGFloat const kLabelHeight = 22.0f;
    
    _transactionStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DISPLAY_NEGOTIATING, nil);
    _transactionStatusLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:13];
    _transactionStatusLabel.textColor = [UIColor whiteColor];
    _transactionStatusLabel.textAlignment = NSTextAlignmentCenter;
    _transactionStatusLabel.backgroundColor = MAIN_BLUE_COLOR;
    _transactionStatusLabel.layer.cornerRadius = 4.0f;
    _transactionStatusLabel.layer.masksToBounds = YES;
    [self addSubview:_transactionStatusLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX = WINSIZE.width - 90.0f;
    CGFloat const kLabelOriginY = _usernameButton.frame.origin.y;
    CGFloat const kLabelWidth = 80.0f;
    CGFloat const kLabelHeight = 15.0f;
    
    _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _timestampLabel.text = NSLocalizedString(@"Just now", nil);
    _timestampLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:12];
    _timestampLabel.textColor = MAIN_BLUE_COLOR_WITH_DARK_2;
    _timestampLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timestampLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonOriginX = WINSIZE.width - 58.0f;
    CGFloat const kButtonOriginY = _timestampLabel.frame.origin.y + _timestampLabel.frame.size.height + 5;
    CGFloat const kButtonWidth = 48.0f;
    CGFloat const kButtonHeight = 48.0f;
    
    _itemImageButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_itemImageButton setBackgroundImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
    _itemImageButton.layer.cornerRadius = 3.0f;
    _itemImageButton.clipsToBounds = YES;
    [_itemImageButton addTarget:self action:@selector(itemImageButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_itemImageButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) clearUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [_userProfileImageButton setBackgroundImage:nil forState:UIControlStateNormal];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) bindData:(NSDictionary *)message
//------------------------------------------------------------------------------------------------------------------------------
{
	_message = message;
    
    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
    UIImage *image = [[ProfileImageCache sharedCache] objectForKey:imageKey];
    
    if (image)
    {
        [_userProfileImageButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        [self getProfileImageFromRemoteServer];
    }
	
	[_usernameButton createTitle:_message[FB_OPPOSING_USER_USERNAME] withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
    _usernameButton.titleColor = TEXT_COLOR_GRAY;
    _usernameButton.bgColor = [UIColor whiteColor];
    _usernameButton.borderWidth = 0;
    _usernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _itemNameLabel.text     =   _message[PF_ITEM_NAME];
	_lastMessageLabel.text  =   _message[FB_LAST_MESSAGE];
    
    [self setItemPicture];
	
	NSDate *date = String2Date(_message[FB_TIMESTAMP]);
	_timestampLabel.text = [Utilities timestampStringFromDate:date];
	
	int counter = [_message[FB_UNREAD_MESSAGES_COUNTER] intValue];
    if (counter == 0)
    {
        _lastMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
        _lastMessageLabel.textColor = TEXT_COLOR_GRAY;
        self.backgroundColor = [UIColor whiteColor];
        _usernameButton.bgColor = [UIColor whiteColor];
    }
    else
    {
        _lastMessageLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
        _lastMessageLabel.textColor = TEXT_COLOR_DARK_GRAY;
        self.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
        _usernameButton.bgColor = GRAY_COLOR_WITH_WHITE_COLOR_3;
    }
    
    [self updateTransactionStatus:_message[FB_TRANSACTION_STATUS]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setItemPicture
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_ITEM_ID], ITEM_FIRST_IMAGE];
    UIImage *itemImage = [[ItemImageCache sharedCache] objectForKey:imageKey];
    
    if (itemImage)
    {
        [_itemImageButton setBackgroundImage:itemImage forState:UIControlStateNormal];
    }
    else
    {
        [self downloadItemImageFromRemoteServer];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateTransactionStatus: (NSString *) transactionStatus
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([transactionStatus isEqualToString:TRANSACTION_STATUS_ACCEPTED])
        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_ACCEPTED, nil);
    else if ([transactionStatus isEqualToString:TRANSACTION_STATUS_CANCELLED])
        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_CANCELLED, nil);
    else if ([transactionStatus isEqualToString:TRANSACTION_STATUS_DECLINED])
        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DECLINED, nil);
    else if ([transactionStatus isEqualToString:TRANSACTION_STATUS_NONE])
        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DISPLAY_NEGOTIATING, nil);
    else
        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DISPLAY_OFFERED, nil);
        
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) getProfileImageFromRemoteServer
//------------------------------------------------------------------------------------------------------------------------------
{
    __block NSInteger cellIndex = _cellIndex;
    
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:_message[FB_OPPOSING_USER_ID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            PFUser *user = [objects firstObject];
            PFFile *userPicture = user[PF_USER_PICTURE];
             
            if (userPicture)
            {
                [userPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                 {
                     if (!error)
                     {
                         if (_cellIndex == cellIndex)
                         {
                             UIImage *image = [UIImage imageWithData:data];
                             [_userProfileImageButton setBackgroundImage:image forState:UIControlStateNormal];
                             
                             NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
                             [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
                         }
                     }
                     else
                     {
                         [Utilities handleError:error];
                     }
                 }];
            }
            else
            {
                if (_cellIndex == cellIndex)
                {
                    UIImage *image = [UIImage imageNamed:@"user_profile_image_placeholder_big.png"];
                    [_userProfileImageButton setBackgroundImage:image forState:UIControlStateNormal];
                
                    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
                    [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
                }
            }
         }
         else
         {
             
             [Utilities handleError:error];
         }
     }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) downloadItemImageFromRemoteServer
//------------------------------------------------------------------------------------------------------------------------------
{
    __block NSInteger cellIndex = _cellIndex;
    
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_USER_OBJECTID equalTo:_message[FB_ITEM_ID]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error)
    {
        if (!error)
        {
            PFRelation *picRelation = obj[PF_ITEM_PICTURE_LIST];
            PFQuery *query = [picRelation query];
            [query orderByAscending:PF_CREATED_AT];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error)
            {
                if (!error)
                {
                    PFFile *firstPicture = firstObject[PF_ITEM_PICTURE];
                    [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2)
                    {
                        if (!error_2)
                        {
                            if (_cellIndex == cellIndex)
                            {
                                UIImage *image = [UIImage imageWithData:data];
                                [_itemImageButton setBackgroundImage:image forState:UIControlStateNormal];
                                
                                NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_ITEM_ID], ITEM_FIRST_IMAGE];
                                [[ItemImageCache sharedCache] setObject:image forKey:imageKey];
                            }
                        }
                        else
                        {
                            [Utilities handleError:error_2];
                        }
                    }];
                }
                else
                {
                    [Utilities handleError:error];
                }
            }];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) userProfilePicButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_CHAT_TAP_EVENT object:_message[FB_OPPOSING_USER_ID]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_CHAT_TAP_EVENT object:_message[FB_OPPOSING_USER_ID]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) itemImageButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_IMAGE_BUTTON_TAP_EVENT object:_message[FB_ITEM_ID]];
}


@end
