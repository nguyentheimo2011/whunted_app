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
#import <Haneke/UIImageView+Haneke.h>

#import "AppConstant.h"
#import "converter.h"
#import "PersistedCache.h"
#import "TemporaryCache.h"

#import "MessageViewCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface MessageViewCell ()
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
    
    [_usernameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [_itemNameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    
    [_lastMessageLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [_lastMessageLabel setTextColor:[UIColor blackColor]];
    
    [_timestampLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:12]];
    
    [_transactionStatusLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [_transactionStatusLabel setBackgroundColor:ACCEPTED_BUTTON_BACKGROUND_COLOR];
    [_transactionStatusLabel setTextColor:[UIColor whiteColor]];
    [_transactionStatusLabel setTextAlignment:NSTextAlignmentCenter];
    _transactionStatusLabel.layer.cornerRadius = 2;
    _transactionStatusLabel.layer.masksToBounds = YES;
    [_transactionStatusLabel setHidden:NO];
    
    [_detailedStatusLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [_detailedStatusLabel setHidden:NO];
    
    [_itemImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    _itemImageView.layer.cornerRadius = 3;
    _itemImageView.layer.masksToBounds = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) bindData:(NSDictionary *)message
//------------------------------------------------------------------------------------------------------------------------------
{
	_message = message;
    
    if ([[TemporaryCache sharedCache] objectForKey:_message[@"profileId"]]) {
        UIImage *image = [[TemporaryCache sharedCache] objectForKey:_message[@"profileId"]];
        [_userProfileImage setImage:image];
    } else {
        [self getProfileImageFromRemoteServer];
    }
	
	_usernameLabel.text = _message[@"description"];
    _itemNameLabel.text = _message[PF_ITEM_NAME];
	_lastMessageLabel.text = _message[@"lastMessage"];
    
    [self setItemPicture:_message[PF_ITEM_ID]];
	
	NSDate *date = String2Date(_message[@"date"]);
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
	_timestampLabel.text = TimeElapsed(seconds);
	
	int counter = [_message[@"counter"] intValue];
    if (counter == 0) {
        [_lastMessageLabel setTextColor:[UIColor grayColor]];
        [_lastMessageLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    } else {
        [_lastMessageLabel setTextColor:[UIColor blackColor]];
        [_lastMessageLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    }
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
- (void) getProfileImageFromRemoteServer
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:_message[@"profileId"]];
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
                     [[TemporaryCache sharedCache] setObject:image forKey:_message[@"profileId"]];
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
    [query whereKey:PF_USER_OBJECTID equalTo:_message[PF_ITEM_ID]];
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
