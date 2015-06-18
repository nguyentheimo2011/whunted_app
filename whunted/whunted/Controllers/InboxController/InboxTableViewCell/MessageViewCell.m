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

@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelElapsed;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation MessageViewCell

@synthesize imageUser;
@synthesize labelDescription, labelLastMessage;
@synthesize labelElapsed, labelCounter;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(NSDictionary *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	_message = message;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
	imageUser.layer.masksToBounds = YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID equalTo:_message[@"profileId"]];
//	[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			PFUser *user = [objects firstObject];
			[imageUser setFile:user[PF_USER_PICTURE]];
			[imageUser loadInBackground];
		}
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	labelDescription.text = _message[@"description"];
	labelLastMessage.text = _message[@"lastMessage"];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSDate *date = String2Date(_message[@"date"]);
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
	labelElapsed.text = TimeElapsed(seconds);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	int counter = [_message[@"counter"] intValue];
	labelCounter.text = (counter == 0) ? @"" : [NSString stringWithFormat:@"%d new", counter];
}

@end
