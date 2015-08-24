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

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

#import "JSQMessages.h"
#import "RNGridMenu.h"

#import "OfferData.h"
#import "BuyersOrSellersOfferViewController.h"
#import "AppConstant.h"

@class BuyersOrSellersOfferViewController;
@class ChatView;

//-------------------------------------------------------------------------------------------------------------------------------
@protocol ChatViewDelegate <NSObject>

- (void) chatViewDidSeeAConversation: (ChatView *) chatView;

@end

//-------------------------------------------------------------------------------------------------------------------------------
@interface ChatView : JSQMessagesViewController <RNGridMenuDelegate, UIImagePickerControllerDelegate, BuyersOrSellerOfferDelegate>
//-------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic)           id<ChatViewDelegate>    delegate;

@property (nonatomic, strong)   NSString                *user2Username;
@property (nonatomic, strong)   OfferData               *offerData;


- (id) initWith: (NSString *) groupId_;

- (void) messageSend:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture Audio:(NSString *)audio ChatMessageType: (ChatMessageType) type TransactionDetails: (NSDictionary *) details CompletionBlock: (CompletionHandler) completionBlock;

@end
