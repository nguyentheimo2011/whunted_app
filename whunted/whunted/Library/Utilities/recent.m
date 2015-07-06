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
#import <Firebase/Firebase.h>
#import "PFUser+Util.h"
#import "MBProgressHUD.h"

#import "AppConstant.h"
#import "converter.h"

#import "recent.h"

//------------------------------------------------------------------------------------------------------------------------------
NSString* StartPrivateChat(PFUser *user1, PFUser *user2, OfferData *offerData)
//------------------------------------------------------------------------------------------------------------------------------
{
	NSString *id1 = user1.objectId;
	NSString *id2 = user2.objectId;
	
	NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", offerData.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", offerData.itemID, id2, id1];
	
	NSArray *members = @[user1.objectId, user2.objectId];
	
	CreateRecentItem1(user1, groupId, members, user2[PF_USER_USERNAME], user2, offerData);
	CreateRecentItem1(user2, groupId, members, user1[PF_USER_USERNAME], user1, offerData);
	
	return groupId;
}

//------------------------------------------------------------------------------------------------------------------------------
void CreateRecentItem1(PFUser *user, NSString *groupId, NSArray *members, NSString *description, PFUser *profile, OfferData *offerData)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:@"groupId"] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		BOOL create = YES;
		if (snapshot.value != [NSNull null])
		{
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				if ([recent[@"userId"] isEqualToString:user.objectId]) create = NO;
			}
		}
		if (create) CreateRecentItem2(user, groupId, members, description, profile, offerData);
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void CreateRecentItem2(PFUser *user, NSString *groupId, NSArray *members, NSString *description, PFUser *profile, OfferData *offerData)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	Firebase *reference = [firebase childByAutoId];
	
	NSString *recentId = reference.key;
	PFUser *lastUser = [PFUser currentUser];
	NSString *date = Date2String([NSDate date]);
	
	NSDictionary *recent = @{@"recentId":recentId, @"userId":user.objectId, @"groupId":groupId, @"members":members, @"description":description,
                             @"lastUser":lastUser.objectId, @"lastMessage":@"", @"counter":@0, @"date":date, @"profileId":profile.objectId, PF_ITEM_ID:offerData.itemID, PF_ITEM_NAME:offerData.itemName, PF_ITEM_DEMANDED_PRICE:offerData.originalDemandedPrice};
	
	[reference setValue:recent withCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error != nil) NSLog(@"CreateRecentItem2 save error.");
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void UpdateRecentCounter1(NSString *groupId, NSInteger amount, NSString *lastMessage)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:@"groupId"] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		if (snapshot.value != [NSNull null])
		{
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				UpdateRecentCounter2(recent, amount, lastMessage);
			}
		}
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void UpdateRecentCounter2(NSDictionary *recent, NSInteger amount, NSString *lastMessage)
//------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user = [PFUser currentUser];
	NSString *date = Date2String([NSDate date]);
	NSInteger counter = [recent[@"counter"] integerValue];
	if ([recent[@"userId"] isEqualToString:user.objectId] == NO) counter += amount;
	
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent/%@", FIREBASE, recent[@"recentId"]]];
	NSDictionary *values = @{@"lastUser":user.objectId, @"lastMessage":lastMessage, @"counter":@(counter), @"date":date};
	[firebase updateChildValues:values withCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error != nil) NSLog(@"UpdateRecentCounter2 save error.");
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void ClearRecentCounter1(NSString *groupId)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:@"groupId"] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		if (snapshot.value != [NSNull null])
		{
			PFUser *user = [PFUser currentUser];
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				if ([recent[@"userId"] isEqualToString:user.objectId])
				{
					ClearRecentCounter2(recent);
				}
			}
		}
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void ClearRecentCounter2(NSDictionary *recent)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent/%@", FIREBASE, recent[@"recentId"]]];
	[firebase updateChildValues:@{@"counter":@0} withCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error != nil) NSLog(@"ClearRecentCounter2 save error.");
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void DeleteRecentItems(NSString *groupId)
//------------------------------------------------------------------------------------------------------------------------------
{    
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:@"groupId"] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		if (snapshot.value != [NSNull null])
		{
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				if ([recent[@"lastMessage"] length] == 0)
				{
					DeleteRecentItem(recent);
                } else {
                    ClearRecentCounter1(groupId);
                }
			}
		}
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void DeleteRecentItem(NSDictionary *recent)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent/%@", FIREBASE, recent[@"recentId"]]];
	[firebase removeValueWithCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error != nil) NSLog(@"DeleteRecentItem delete error.");
	}];
}
