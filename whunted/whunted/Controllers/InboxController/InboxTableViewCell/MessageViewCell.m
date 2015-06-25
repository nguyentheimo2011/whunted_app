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

#import "AppConstant.h"
#import "converter.h"

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
    
    [labelDescription setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:15]];
    [labelItemName setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:17]];
    
    [labelLastMessage setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:15]];
    [labelLastMessage setTextColor:[UIColor blackColor]];
    
    [labelElapsed setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:12]];
    
    [labelTransactionStatus setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [labelTransactionStatus setBackgroundColor:ACCEPTED_BUTTON_BACKGROUND_COLOR];
    [labelTransactionStatus setTextColor:[UIColor whiteColor]];
    [labelTransactionStatus setTextAlignment:NSTextAlignmentCenter];
    labelTransactionStatus.layer.cornerRadius = 2;
    labelTransactionStatus.layer.masksToBounds = YES;
    [labelTransactionStatus setHidden:NO];
    
    [labelOfferedPrice setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:14]];
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
    
	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID equalTo:_message[@"profileId"]];
    [query fromLocalDatastore];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (!error)
		{
			PFUser *user = [objects firstObject];
			PFFile *userPicture = user[PF_USER_PICTURE];
            NSData *data = [userPicture getData];
            if (data) {
                [imageUser setImage:[UIImage imageWithData:data]];
            } else {
                [self getProfileImageFromRemoteServer];
            }
		}
	}];
	
	labelDescription.text = _message[@"description"];
	labelLastMessage.text = _message[@"lastMessage"];
	
	NSDate *date = String2Date(_message[@"date"]);
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
	labelElapsed.text = TimeElapsed(seconds);
	
	int counter = [_message[@"counter"] intValue];
    if (counter == 0) {
        [labelLastMessage setTextColor:[UIColor grayColor]];
    } else {
        [labelLastMessage setTextColor:[UIColor blackColor]];
    }
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
                     [imageUser setImage:[UIImage imageWithData:data]];
                     [user pinInBackground];
                 }
             }];
         }
     }];
}

@end
