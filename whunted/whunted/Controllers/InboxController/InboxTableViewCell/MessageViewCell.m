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
    JTImageButton               *_userProfileImageButton;
    JTImageButton               *_usernameButton;
    UILabel                     *_itemNameLabel;
    UILabel                     *_lastMessageLabel;
    UILabel                     *_transactionStatusLabel;
    UILabel                     *_timestampLabel;
    JTImageButton               *_itemImageButton;
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
    CGFloat const kButtonOriginX = 2.0f;
    CGFloat const kButtonOriginY = 10.0f;
    
    _userProfileImageButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_userProfileImageButton createTitle:nil withIcon:[UIImage imageNamed:@"user_profile_image_placeholder_big.png"] font:nil iconOffsetY:0];
    _userProfileImageButton.borderWidth = 0;
    _userProfileImageButton.cornerRadius = kButtonHeight/2;
    [self addSubview:_userProfileImageButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addUsernameButton
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLastMessageLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTransactionStatusLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageButton
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

////------------------------------------------------------------------------------------------------------------------------------
//- (void) customizeUI
////------------------------------------------------------------------------------------------------------------------------------
//{
//    [_userProfileImage setImage:[UIImage imageNamed:@"user_profile_image_placeholder_big.png"]];
//    _userProfileImage.layer.cornerRadius = _userProfileImage.frame.size.width/2;
//    _userProfileImage.layer.masksToBounds = YES;
//    
//    _usernameLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:14];
//    _usernameLabel.textColor = TEXT_COLOR_GRAY;
//    
//    _itemNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:16];
//    _itemNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
//    
//    _lastMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
//    _lastMessageLabel.textColor = TEXT_COLOR_DARK_GRAY;
//    
//    _timestampLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:12];
//    _timestampLabel.textColor = MAIN_BLUE_COLOR_WITH_DARK_2;
//    
//    _transactionStatusLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:13];
//    _transactionStatusLabel.backgroundColor = MAIN_BLUE_COLOR;
//    _transactionStatusLabel.textColor = [UIColor whiteColor];
//    _transactionStatusLabel.textAlignment = NSTextAlignmentCenter;
//    _transactionStatusLabel.layer.cornerRadius = 2;
//    _transactionStatusLabel.layer.masksToBounds = YES;
//    _transactionStatusLabel.hidden = NO;
//    
//    _detailedStatusLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
//    _detailedStatusLabel.textColor = TEXT_COLOR_DARK_GRAY;
//    _detailedStatusLabel.text = @"";
//    _detailedStatusLabel.hidden = YES;
//    
//    [_itemImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
//    _itemImageView.layer.cornerRadius = 3;
//    _itemImageView.layer.masksToBounds = YES;
//    
//    [self addUserProfilePicButton];
//    
//    _cellCreated = YES;
//}
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) addUserProfilePicButton
////------------------------------------------------------------------------------------------------------------------------------
//{
//    _userProfilePicButton = [[UIButton alloc] initWithFrame:_userProfileImage.frame];
//    _userProfilePicButton.layer.cornerRadius = _userProfileImage.frame.size.height/2;
//    _userProfilePicButton.clipsToBounds = YES;
//    [_userProfilePicButton addTarget:self action:@selector(userProfilePicButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_userProfilePicButton];
//}
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) clearUI
////------------------------------------------------------------------------------------------------------------------------------
//{
//    [_userProfilePicButton setBackgroundImage:nil forState:UIControlStateNormal];
//}
//
//------------------------------------------------------------------------------------------------------------------------------
- (void) bindData:(NSDictionary *)message
//------------------------------------------------------------------------------------------------------------------------------
{
//	_message = message;
//    
//    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
//    UIImage *image = [[ProfileImageCache sharedCache] objectForKey:imageKey];
//    
//    if (image)
//    {
//        [_userProfilePicButton setBackgroundImage:image forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self getProfileImageFromRemoteServer];
//    }
//	
//	_usernameLabel.text     =   _message[FB_OPPOSING_USER_USERNAME];
//    _itemNameLabel.text     =   _message[PF_ITEM_NAME];
//	_lastMessageLabel.text  =   _message[FB_LAST_MESSAGE];
//    
//    [self setItemPicture];
//	
//	NSDate *date = String2Date(_message[FB_TIMESTAMP]);
//	_timestampLabel.text = [Utilities timestampStringFromDate:date];
//	
//	int counter = [_message[FB_UNREAD_MESSAGES_COUNTER] intValue];
//    if (counter == 0)
//    {
//        _lastMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
//        _lastMessageLabel.textColor = TEXT_COLOR_GRAY;
//    }
//    else
//    {
//        _lastMessageLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
//        _lastMessageLabel.textColor = TEXT_COLOR_DARK_GRAY;
//    }
//    
//    [self updateTransactionStatus:_message[FB_TRANSACTION_STATUS]];
}
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) setItemPicture
////------------------------------------------------------------------------------------------------------------------------------
//{
//    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_ITEM_ID], ITEM_FIRST_IMAGE];
//    UIImage *itemImage = [[ItemImageCache sharedCache] objectForKey:imageKey];
//    
//    if (itemImage)
//    {
//        [_itemImageView setImage:itemImage];
//    }
//    else
//    {
//        [self downloadItemImageFromRemoteServer];
//    }
//}
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) updateTransactionStatus: (NSString *) transactionStatus
////------------------------------------------------------------------------------------------------------------------------------
//{
//    if ([transactionStatus isEqualToString:TRANSACTION_STATUS_ACCEPTED])
//        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_ACCEPTED, nil);
//    else if ([transactionStatus isEqualToString:TRANSACTION_STATUS_CANCELLED])
//        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_CANCELLED, nil);
//    else if ([transactionStatus isEqualToString:TRANSACTION_STATUS_DECLINED])
//        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DECLINED, nil);
//    else if ([transactionStatus isEqualToString:TRANSACTION_STATUS_NONE])
//        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DISPLAY_NEGOTIATING, nil);
//    else
//        _transactionStatusLabel.text = NSLocalizedString(TRANSACTION_STATUS_DISPLAY_OFFERED, nil);
//        
//}
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) getProfileImageFromRemoteServer
////------------------------------------------------------------------------------------------------------------------------------
//{
//    __block NSInteger cellIndex = _cellIndex;
//    
//    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
//    [query whereKey:PF_USER_OBJECTID equalTo:_message[FB_OPPOSING_USER_ID]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//    {
//        if (!error)
//        {
//            PFUser *user = [objects firstObject];
//            PFFile *userPicture = user[PF_USER_PICTURE];
//             
//            if (userPicture)
//            {
//                [userPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
//                 {
//                     if (!error)
//                     {
//                         if (_cellIndex == cellIndex)
//                         {
//                             UIImage *image = [UIImage imageWithData:data];
//                             [_userProfilePicButton setBackgroundImage:image forState:UIControlStateNormal];
//                             
//                             NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
//                             [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
//                         }
//                     }
//                     else
//                     {
//                         [Utilities handleError:error];
//                     }
//                 }];
//            }
//            else
//            {
//                if (_cellIndex == cellIndex)
//                {
//                    UIImage *image = [UIImage imageNamed:@"user_profile_image_placeholder_big.png"];
//                    [_userProfilePicButton setBackgroundImage:image forState:UIControlStateNormal];
//                
//                    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
//                    [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
//                }
//            }
//         }
//         else
//         {
//             
//             [Utilities handleError:error];
//         }
//     }];
//}
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) downloadItemImageFromRemoteServer
////------------------------------------------------------------------------------------------------------------------------------
//{
//    __block NSInteger cellIndex = _cellIndex;
//    
//    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
//    [query whereKey:PF_USER_OBJECTID equalTo:_message[FB_ITEM_ID]];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error)
//    {
//        if (!error)
//        {
//            PFRelation *picRelation = obj[PF_ITEM_PICTURE_LIST];
//            PFQuery *query = [picRelation query];
//            [query orderByAscending:PF_CREATED_AT];
//            [query getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error)
//            {
//                if (!error)
//                {
//                    PFFile *firstPicture = firstObject[PF_ITEM_PICTURE];
//                    [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2)
//                    {
//                        if (!error_2)
//                        {
//                            if (_cellIndex == cellIndex)
//                            {
//                                UIImage *image = [UIImage imageWithData:data];
//                                [_itemImageView setImage:image];
//                                
//                                NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_ITEM_ID], ITEM_FIRST_IMAGE];
//                                [[ItemImageCache sharedCache] setObject:image forKey:imageKey];
//                            }
//                        }
//                        else
//                        {
//                            [Utilities handleError:error_2];
//                        }
//                    }];
//                }
//                else
//                {
//                    [Utilities handleError:error];
//                }
//            }];
//        }
//        else
//        {
//            [Utilities handleError:error];
//        }
//    }];
//}
//
//
//#pragma mark - Event Handler
//
////------------------------------------------------------------------------------------------------------------------------------
//- (void) userProfilePicButtonTapEventHandler
////------------------------------------------------------------------------------------------------------------------------------
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_CHAT_TAP_EVENT object:_message[FB_OPPOSING_USER_ID]];
//}


@end
