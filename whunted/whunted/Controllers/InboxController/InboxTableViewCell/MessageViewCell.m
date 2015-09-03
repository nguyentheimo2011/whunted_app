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

#import "converter.h"
#import "PersistedCache.h"
#import "TemporaryCache.h"
#import "AppConstant.h"
#import "Utilities.h"

#import "MessageViewCell.h"

//------------------------------------------------------------------------------------------------------------------------------
@interface MessageViewCell ()
//------------------------------------------------------------------------------------------------------------------------------
{
	NSDictionary *_message;
}

@property (strong, nonatomic) IBOutlet UIImageView  *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel      *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel      *itemNameLabel;
@property (strong, nonatomic) IBOutlet UILabel      *lastMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel      *timestampLabel;
@property (strong, nonatomic) IBOutlet UIImageView  *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel      *transactionStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel      *detailedStatusLabel;

@end

//------------------------------------------------------------------------------------------------------------------------------
@implementation MessageViewCell
//------------------------------------------------------------------------------------------------------------------------------

@synthesize userProfileImage        =   _userProfileImage;
@synthesize usernameLabel           =   _usernameLabel;
@synthesize itemNameLabel           =   _itemNameLabel;
@synthesize lastMessageLabel        =   _lastMessageLabel;
@synthesize timestampLabel          =   _timestampLabel;
@synthesize itemImageView           =   _itemImageView;
@synthesize transactionStatusLabel  =   _transactionStatusLabel;
@synthesize detailedStatusLabel     =   _detailedStatusLabel;

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [_userProfileImage setImage:[UIImage imageNamed:@"user_profile_image_placeholder_big.png"]];
    _userProfileImage.layer.cornerRadius = _userProfileImage.frame.size.width/2;
    _userProfileImage.layer.masksToBounds = YES;
    
    _usernameLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:14];
    _usernameLabel.textColor = TEXT_COLOR_GRAY;
    
    _itemNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:16];
    _itemNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    
    _lastMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    _lastMessageLabel.textColor = TEXT_COLOR_DARK_GRAY;
    
    _timestampLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:12];
    _timestampLabel.textColor = DARKEST_BLUE_COLOR;
    
    _transactionStatusLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:13];
    _transactionStatusLabel.backgroundColor = MAIN_BLUE_COLOR;
    _transactionStatusLabel.textColor = [UIColor whiteColor];
    _transactionStatusLabel.textAlignment = NSTextAlignmentCenter;
    _transactionStatusLabel.layer.cornerRadius = 2;
    _transactionStatusLabel.layer.masksToBounds = YES;
    _transactionStatusLabel.hidden = NO;
    
    _detailedStatusLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
    _detailedStatusLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _detailedStatusLabel.text = @"";
    _detailedStatusLabel.hidden = YES;
    
    [_itemImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    _itemImageView.layer.cornerRadius = 3;
    _itemImageView.layer.masksToBounds = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) bindData:(NSDictionary *)message
//------------------------------------------------------------------------------------------------------------------------------
{
	_message = message;
    
    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
    UIImage *image = [[TemporaryCache sharedCache] objectForKey:imageKey];
    
    if (image) {
        [_userProfileImage setImage:image];
    } else {
        [self getProfileImageFromRemoteServer];
    }
	
	_usernameLabel.text = _message[FB_OPPOSING_USER_USERNAME];
    _itemNameLabel.text = _message[PF_ITEM_NAME];
	_lastMessageLabel.text = _message[FB_LAST_MESSAGE];
    
    [self setItemPicture:_message[PF_ITEM_ID]];
	
	NSDate *date = String2Date(_message[FB_TIMESTAMP]);
	_timestampLabel.text = [Utilities timestampStringFromDate:date];
	
	int counter = [_message[FB_UNREAD_MESSAGES_COUNTER] intValue];
    if (counter == 0) {
        _lastMessageLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
        _lastMessageLabel.textColor = TEXT_COLOR_GRAY;
        
    } else {
        _lastMessageLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
        _lastMessageLabel.textColor = TEXT_COLOR_DARK_GRAY;
    }
    
    [self updateTransactionStatus:_message[FB_TRANSACTION_STATUS]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setItemPicture: (NSString *) itemID
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *image = (UIImage *) [[PersistedCache sharedCache] imageForKey:itemID];
    if (image)
        [_itemImageView setImage:image];
    else
        [self downloadItemImageFromRemoteServer];
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
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:_message[FB_OPPOSING_USER_ID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             PFUser *user = [objects firstObject];
             PFFile *userPicture = user[PF_USER_PICTURE];
             
             [userPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                 if (!error) {
                     UIImage *image = [UIImage imageWithData:data];
                     [_userProfileImage setImage:image];
                     
                     NSString *imageKey = [NSString stringWithFormat:@"%@%@", _message[FB_OPPOSING_USER_ID], USER_PROFILE_IMAGE];
                     [[TemporaryCache sharedCache] setObject:image forKey:imageKey];
                 }
             }];
         }
     }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) downloadItemImageFromRemoteServer
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_WANT_DATA_CLASS];
    [query whereKey:PF_USER_OBJECTID equalTo:_message[FB_ITEM_ID]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        if (!error) {
            PFRelation *pictureRelation = obj[PF_ITEM_PICTURE_LIST];
            [[pictureRelation query] getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error) {
                if (!error) {
                    PFFile *firstPicture = firstObject[@"itemPicture"];
                    [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2) {
                        if (!error_2) {
                            UIImage *image = [UIImage imageWithData:data];
                            [_itemImageView setImage:image];
                            [[PersistedCache sharedCache] setImage:image forKey:_message[PF_ITEM_ID]];
                        } else {
                            NSLog(@"Error: %@ %@", error_2, [error_2 userInfo]);
                        }
                    }];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
