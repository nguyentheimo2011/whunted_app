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

#import "Outgoing.h"

#import <Parse/Parse.h>
#import <Firebase/Firebase.h>
#import "MBProgressHUD.h"

#import "AppDelegate.h"
#import "converter.h"
#import "emoji.h"
#import "image.h"
#import "push.h"
#import "recent.h"
#import "video.h"
#import "Utilities.h"

//--------------------------------------------------------------------------------------------------------------------------------
@interface Outgoing()
{
	NSString *groupId;
	UIView *view;
}
@end
//--------------------------------------------------------------------------------------------------------------------------------

@implementation Outgoing

//--------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)groupId_ View:(UIView *)view_
//--------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	groupId = groupId_;
	view = view_;
	return self;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)send:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture Audio:(NSString *)audio ChatMessageType: (ChatMessageType) type TransactionDetails: (NSDictionary *) details CompletionBlock: (CompletionHandler) completionBlock
//--------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user = [PFUser currentUser];
	
	NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
	
	item[@"userId"]             =   user.objectId;
	item[@"name"]               =   user[PF_USER_USERNAME];
	item[@"date"]               =   Date2String([NSDate date]);
	item[@"status"]             =   @"Delivered";
    item[CHAT_MESSAGE_TYPE]     =   [Utilities stringFromChatMessageType:type];
    
    if ([[details allKeys] containsObject:FB_CURRENT_OFFER_ID])
        item[FB_CURRENT_OFFER_ID]   =   details[FB_CURRENT_OFFER_ID];
    else
        item[FB_CURRENT_OFFER_ID]   =   @"";
	
	item[@"video"] = item[@"thumbnail"] = item[@"picture"] = item[@"audio"] = item[@"latitude"] = item[@"longitude"] = @"";
	item[@"video_duration"] = item[@"audio_duration"] = @0;
	item[@"picture_width"] = item[@"picture_height"] = @0;
	
	if (text != nil) [self sendTextMessage:item Text:text TransactionDetails:details CompletionBlock:completionBlock];
	else if (video != nil) [self sendVideoMessage:item Video:video];
	else if (picture != nil) [self sendPictureMessage:item Picture:picture];
	else if (audio != nil) [self sendAudioMessage:item Audio:audio];
	else [self sendLoactionMessage:item];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)sendTextMessage:(NSMutableDictionary *)item Text:(NSString *)text TransactionDetails: (NSDictionary *) details CompletionBlock: (CompletionHandler) completionBlock
//--------------------------------------------------------------------------------------------------------------------------------
{
	item[@"text"] = text;
	item[@"type"] = IsEmoji(text) ? @"emoji" : @"text";
	[self sendMessage:item TransactionDetails:details CompletionBlock:completionBlock];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)sendVideoMessage:(NSMutableDictionary *)item Video:(NSURL *)video
//--------------------------------------------------------------------------------------------------------------------------------
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
	
	UIImage *picture = VideoThumbnail(video);
	UIImage *squared = SquareImage(picture, 320);
	NSNumber *duration = VideoDuration(video);
	PFFile *fileThumbnail = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(squared, 0.6)];
	[fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error == nil)
		{
			PFFile *fileVideo = [PFFile fileWithName:@"video.mp4" data:[[NSFileManager defaultManager] contentsAtPath:video.path]];
			[fileVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
			{
				[hud hide:YES];
				if (error == nil)
				{
					item[@"video"] = fileVideo.url;
					item[@"video_duration"] = duration;
					item[@"thumbnail"] = fileThumbnail.url;
					item[@"text"] = @"[Video message]";
					item[@"type"] = @"video";
					[self sendMessage:item TransactionDetails:nil CompletionBlock:nil];
				}
				else NSLog(@"Outgoing sendVideoMessage video save error.");
			}
			progressBlock:^(int percentDone)
			{
				hud.progress = (float) percentDone/100;
			}];
		}
		else NSLog(@"Outgoing sendVideoMessage picture save error.");
	}];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)sendPictureMessage:(NSMutableDictionary *)item Picture:(UIImage *)picture
//--------------------------------------------------------------------------------------------------------------------------------
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
	
	int width = (int) picture.size.width;
	int height = (int) picture.size.height;
	PFFile *file = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
	[file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		[hud hide:YES];
		if (error == nil)
		{
			item[@"picture"] = file.url;
			item[@"picture_width"] = [NSNumber numberWithInt:width];
			item[@"picture_height"] = [NSNumber numberWithInt:height];
			item[@"text"] = @"[Picture message]";
			item[@"type"] = @"picture";
			[self sendMessage:item TransactionDetails:nil CompletionBlock:nil];
		}
		else NSLog(@"Outgoing sendPictureMessage picture save error.");
	}
	progressBlock:^(int percentDone)
	{
		hud.progress = (float) percentDone/100;
	}];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)sendAudioMessage:(NSMutableDictionary *)item Audio:(NSString *)audio
//--------------------------------------------------------------------------------------------------------------------------------
{

}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)sendLoactionMessage:(NSMutableDictionary *)item
//--------------------------------------------------------------------------------------------------------------------------------
{

}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessage:(NSMutableDictionary *)item TransactionDetails: (NSDictionary *) details CompletionBlock: (CompletionHandler) completionBlock
//-------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase1 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Message/%@", FIREBASE, groupId]];
	Firebase *reference = [firebase1 childByAutoId];
	item[@"key"] = reference.key;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WILL_UPLOAD_MESSAGE object:item[@"key"]];
    
	[reference setValue:item withCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error)
            NSLog(@"Outgoing sendMessage network error.");
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPLOAD_MESSAGE_SUCCESSFULLY object:item[@"key"]];
            if (completionBlock)
                completionBlock();
        }
	}];
    
    SendPushNotification1(groupId, item[@"text"]);
	
    UpdateRecentTransaction1(groupId, details[FB_TRANSACTION_STATUS], details[FB_TRANSACTION_LAST_USER], details[FB_CURRENT_OFFER_ID], details[FB_CURRENT_OFFERED_PRICE], details[FB_CURRENT_OFFERED_DELIVERY_TIME], item[@"text"]);
}

@end
