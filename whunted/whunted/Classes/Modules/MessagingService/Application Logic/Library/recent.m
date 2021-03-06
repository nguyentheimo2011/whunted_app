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

#import "Utilities.h"
#import "converter.h"

#import "recent.h"

#define     HANDLER_EXECUTED            @"handlerExecuted"

//------------------------------------------------------------------------------------------------------------------------------
NSString* StartPrivateChat(PFUser *user1, PFUser *user2, TransactionData *offerData, CompletionHandler handler)
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *groupId = [Utilities generateChatGroupIDFromItemID:offerData.itemID user1:user1 user2:user2];
	
	NSArray *members = @[user1.objectId, user2.objectId];
    NSMutableDictionary *handlerExecuted = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], HANDLER_EXECUTED, nil];
	
	CreateRecentItem1(user1, groupId, members, user2[PF_USER_USERNAME], user2, offerData, handler, handlerExecuted);
	CreateRecentItem1(user2, groupId, members, user1[PF_USER_USERNAME], user1, offerData, handler, handlerExecuted);
	
	return groupId;
}

//------------------------------------------------------------------------------------------------------------------------------
void CreateRecentItem1(PFUser *user, NSString *groupId, NSArray *members, NSString *opposingUserUsername, PFUser *opposingUser, TransactionData *offerData, CompletionHandler handler, NSMutableDictionary *handlerExecuted)
//------------------------------------------------------------------------------------------------------------------------------
{    
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:FB_GROUP_ID] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		BOOL create = YES;
		if (snapshot.value != [NSNull null])
		{
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				if ([recent[FB_SELF_USER_ID] isEqualToString:user.objectId])
                    create = NO;
			}
		}
        
		if (create)
            CreateRecentItem2(user, groupId, members, opposingUserUsername, opposingUser, offerData, handler, handlerExecuted);
        else
        {
            NSNumber *num = [handlerExecuted objectForKey:HANDLER_EXECUTED];
            NSNumber *newNum = [NSNumber numberWithInt:num.intValue + 1];
            [handlerExecuted setObject:newNum forKey:HANDLER_EXECUTED];
            
            if (handler && newNum.intValue == 2) { // Only run handler when both CreateRecentItem1s finish
                handler();
            }
        }
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void CreateRecentItem2(PFUser *user, NSString *groupId, NSArray *members, NSString *opposingUserUsername, PFUser *opposingUser, TransactionData *offerData, CompletionHandler handler, NSMutableDictionary *handlerExecuted)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	Firebase *reference = [firebase childByAutoId];
	
	NSString    *recentId               =   reference.key;
	PFUser      *lastUser               =   [PFUser currentUser];
	NSString    *timestamp              =   Date2String([NSDate date]);
    NSString    *message                =   @"";
    NSString    *transactionLastUser    =   @"";
    NSString    *offerID                =   @"";
    
    // first message can only be either normal message or making offer message
    if (offerData.offeredPrice && offerData.offeredPrice.length > 0)
    {
        message = [Utilities makingOfferMessageFromOfferedPrice:offerData.offeredPrice deliveryTime:offerData.deliveryTime shippingFeeIncluded:offerData.shippingFeeIncluded];
        transactionLastUser = lastUser.objectId;
    }
    
    if (offerData.objectID.length > 0)
        offerID = offerData.objectID;
	
    NSDictionary *recent = @{FB_RECENT_CHAT_ID:recentId, FB_GROUP_ID:groupId, FB_GROUP_MEMBERS:members,
                             FB_CHAT_INITIATOR:user.objectId, FB_SELF_USER_ID:user.objectId,
                             FB_OPPOSING_USER_ID:opposingUser.objectId, FB_OPPOSING_USER_USERNAME:opposingUserUsername,
                             FB_LAST_USER:lastUser.objectId, FB_LAST_MESSAGE:message, FB_UNREAD_MESSAGES_COUNTER:@0,
                             FB_TIMESTAMP:timestamp, FB_CURRENT_OFFER_ID:offerID, FB_ITEM_ID:offerData.itemID,
                             FB_ITEM_NAME:offerData.itemName, FB_ITEM_BUYER_ID:offerData.buyerID, FB_ITEM_SELLER_ID:offerData.sellerID,
                             FB_TRANSACTION_STATUS:offerData.transactionStatus, FB_TRANSACTION_LAST_USER:transactionLastUser,
                             FB_ORIGINAL_DEMANDED_PRICE:offerData.originalDemandedPrice, FB_CURRENT_OFFERED_PRICE:offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:offerData.deliveryTime};
	
	[reference setValue:recent withCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error)
        {
            [Utilities handleError:error];
        }
        else
        {
            NSNumber *num = [handlerExecuted objectForKey:HANDLER_EXECUTED];
            NSNumber *newNum = [NSNumber numberWithInt:(int)num.integerValue + 1];
            [handlerExecuted setObject:newNum forKey:HANDLER_EXECUTED];
            
            if (handler && newNum.intValue == 2) { // Only run handler when both CreateRecentItem1s finish
                handler();
            }
        }
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void UpdateRecentTransaction1 (NSString *groupId, NSString *transactionStatus, NSString *transactionLastUserID,
                               NSString *offerID, NSString *offeredPrice, NSString *shippingFeeIncluded, NSString *deliveryTime, NSString *message)
//------------------------------------------------------------------------------------------------------------------------------
{
    Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
    FQuery *query = [[firebase queryOrderedByChild:FB_GROUP_ID] queryEqualToValue:groupId];
    [query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
     {
         if (snapshot.value != [NSNull null])
         {
             for (NSDictionary *recent in [snapshot.value allValues])
             {
                 UpdateRecentTransaction2(recent, transactionStatus, transactionLastUserID, offerID, offeredPrice, shippingFeeIncluded, deliveryTime, message);
             }
         }
     }];
}

//------------------------------------------------------------------------------------------------------------------------------
void UpdateRecentTransaction2 (NSDictionary *recent, NSString *transactionStatus, NSString *transactionLastUserID,
                               NSString *offerID, NSString *offeredPrice, NSString *shippingFeeIncluded, NSString *deliveryTime, NSString *message)
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *date = Date2String([NSDate date]);
    NSInteger counter = [recent[FB_UNREAD_MESSAGES_COUNTER] integerValue];
    if ([recent[FB_SELF_USER_ID] isEqualToString:[PFUser currentUser].objectId] == NO) counter += 1;
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent/%@", FIREBASE, recent[FB_RECENT_CHAT_ID]]];
    NSDictionary *values;
    if (transactionStatus.length > 0)
        values = @{FB_TRANSACTION_STATUS:transactionStatus, FB_LAST_USER:transactionLastUserID, FB_LAST_MESSAGE:message, FB_TRANSACTION_LAST_USER:transactionLastUserID, FB_CURRENT_OFFERED_PRICE:offeredPrice, FB_CURRENT_SHIPPING_FEE_INCLUDED:shippingFeeIncluded, FB_CURRENT_OFFERED_DELIVERY_TIME:deliveryTime, FB_TIMESTAMP:date, FB_CURRENT_OFFER_ID:offerID, FB_UNREAD_MESSAGES_COUNTER:@(counter)};
    else
        values = @{FB_LAST_USER:[PFUser currentUser].objectId, FB_LAST_MESSAGE:message, FB_UNREAD_MESSAGES_COUNTER:@(counter), FB_TIMESTAMP:date};
    
    [firebase updateChildValues:values withCompletionBlock:^(NSError *error, Firebase *ref)
     {
         if (error != nil)
         {
             [Utilities handleError:error];
         }
     }];
}


//------------------------------------------------------------------------------------------------------------------------------
void ClearRecentCounter1(NSString *groupId)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:FB_GROUP_ID] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		if (snapshot.value != [NSNull null])
		{
			PFUser *user = [PFUser currentUser];
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				if ([recent[FB_SELF_USER_ID] isEqualToString:user.objectId])
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
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent/%@", FIREBASE, recent[FB_RECENT_CHAT_ID]]];
	[firebase updateChildValues:@{FB_UNREAD_MESSAGES_COUNTER:@0} withCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error != nil)
        {
            [Utilities handleError:error];
        }
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void DeleteRecentItems(NSString *groupId)
//------------------------------------------------------------------------------------------------------------------------------
{    
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
	FQuery *query = [[firebase queryOrderedByChild:FB_GROUP_ID] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		if (snapshot.value != [NSNull null])
		{
			for (NSDictionary *recent in [snapshot.value allValues])
			{
				if ([recent[FB_LAST_MESSAGE] length] == 0)
				{
					DeleteRecentItem(recent);
                }
			}
		}
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
void DeleteRecentItem(NSDictionary *recent)
//------------------------------------------------------------------------------------------------------------------------------
{
	Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent/%@", FIREBASE, recent[FB_RECENT_CHAT_ID]]];
	[firebase removeValueWithCompletionBlock:^(NSError *error, Firebase *ref)
	{
		if (error != nil)
        {
            [Utilities handleError:error];
        }
	}];
}
