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

@property (strong, nonatomic) IBOutlet PFImageView  *imageUser;
@property (strong, nonatomic) IBOutlet UILabel      *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel      *labelItemName;
@property (strong, nonatomic) IBOutlet UILabel      *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel      *labelElapsed;
@property (strong, nonatomic) IBOutlet UIImageView  *itemImage;
@property (strong, nonatomic) IBOutlet UILabel      *labelTransactionStatus;
@property (strong, nonatomic) IBOutlet UILabel      *labelOfferedPrice;

@end
//------------------------------------------------------------------------------------------------------------------------------

@implementation MessageViewCell

@synthesize imageUser;
@synthesize labelDescription, labelItemName, labelLastMessage;
@synthesize labelElapsed;
@synthesize itemImage;
@synthesize labelTransactionStatus, labelOfferedPrice;

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [imageUser setImage:[UIImage imageNamed:@"user_profile_circle.png"]];
    imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
    imageUser.layer.masksToBounds = YES;
    
    [labelDescription setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [labelItemName setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    
    [labelLastMessage setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [labelLastMessage setTextColor:[UIColor blackColor]];
    
    [labelElapsed setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:12]];
    
    [labelTransactionStatus setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [labelTransactionStatus setBackgroundColor:ACCEPTED_BUTTON_BACKGROUND_COLOR];
    [labelTransactionStatus setTextColor:[UIColor whiteColor]];
    [labelTransactionStatus setTextAlignment:NSTextAlignmentCenter];
    labelTransactionStatus.layer.cornerRadius = 2;
    labelTransactionStatus.layer.masksToBounds = YES;
    [labelTransactionStatus setHidden:NO];
    
    [labelOfferedPrice setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [labelOfferedPrice setHidden:NO];
    
    [itemImage setImage:[UIImage imageNamed:@"placeholder.png"]];
    itemImage.layer.cornerRadius = 3;
    itemImage.layer.masksToBounds = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) bindData:(NSDictionary *)message
//------------------------------------------------------------------------------------------------------------------------------
{
	_message = message;
    
    if ([[TemporaryCache sharedCache] objectForKey:_message[@"profileId"]]) {
        UIImage *image = [[TemporaryCache sharedCache] objectForKey:_message[@"profileId"]];
        [imageUser setImage:image];
    } else {
        [self getProfileImageFromRemoteServer];
    }
	
	labelDescription.text = _message[@"description"];
    labelItemName.text = _message[PF_ITEM_NAME];
	labelLastMessage.text = _message[@"lastMessage"];
    
    [self setItemPicture:_message[PF_ITEM_ID]];
	
	NSDate *date = String2Date(_message[@"date"]);
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
	labelElapsed.text = TimeElapsed(seconds);
	
	int counter = [_message[@"counter"] intValue];
    if (counter == 0) {
        [labelLastMessage setTextColor:[UIColor grayColor]];
        [labelLastMessage setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    } else {
        [labelLastMessage setTextColor:[UIColor blackColor]];
        [labelLastMessage setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setItemPicture: (NSString *) itemID
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *image = (UIImage *) [[PersistedCache sharedCache] imageForKey:itemID];
    if (image)
        [itemImage setImage:image];
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
                     [imageUser setImage:image];
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
                            [itemImage setImage:image];
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
