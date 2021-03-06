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
#import "TransactionData.h"
#import "AppConstant.h"

//------------------------------------------------------------------------------------------------------------------------------
NSString*       StartPrivateChat        (PFUser *user1, PFUser *user2, TransactionData *offerData, CompletionHandler handler);
NSString*		StartMultipleChat		(NSMutableArray *users);

void			StartGroupChat			(PFObject *group, NSMutableArray *users);

//------------------------------------------------------------------------------------------------------------------------------
void			CreateRecentItem1		(PFUser *user, NSString *groupId, NSArray *members, NSString *opposingUserUsername,
                                         PFUser *opposingUser, TransactionData *offerData, CompletionHandler handler, NSMutableDictionary *handlerExecuted);

void			CreateRecentItem2		(PFUser *user, NSString *groupId, NSArray *members, NSString *opposingUserUsername,
                                         PFUser *opposingUser, TransactionData *offerData, CompletionHandler handler, NSMutableDictionary *handlerExecuted);

//------------------------------------------------------------------------------------------------------------------------------
void			UpdateRecentCounter1	(NSString *groupId, NSInteger amount, NSString *lastMessage);
void			UpdateRecentCounter2	(NSDictionary *recent, NSInteger amount, NSString *lastMessage);

//------------------------------------------------------------------------------------------------------------------------------
void            UpdateRecentTransaction1 (NSString *groupId, NSString *transactionStatus, NSString *transactionLastUserID,
                                          NSString *offerID, NSString *offeredPrice, NSString *shippingFeeIncluded, NSString *deliveryTime, NSString *message);
void            UpdateRecentTransaction2 (NSDictionary *recent, NSString *transactionStatus, NSString *transactionLastUserID,
                                          NSString *offerID, NSString *offeredPrice, NSString *shippingFeeIncluded, NSString *deliveryTime, NSString *message);

//------------------------------------------------------------------------------------------------------------------------------
void			ClearRecentCounter1		(NSString *groupId);
void			ClearRecentCounter2		(NSDictionary *recent);

//------------------------------------------------------------------------------------------------------------------------------
void			DeleteRecentItems		(NSString *groupId);
void			DeleteRecentItem		(NSDictionary *recent);
