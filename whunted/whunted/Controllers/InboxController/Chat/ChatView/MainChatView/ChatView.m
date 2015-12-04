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

#import <MediaPlayer/MediaPlayer.h>
#import <JTImageButton.h>

#import <Parse/Parse.h>
#import <Firebase/Firebase.h>
#import "IDMPhotoBrowser.h"
#import "RNGridMenu.h"

#import "camera.h"
#import "common.h"
#import "recent.h"
#import "ProfileImageCache.h"
#import "Utilities.h"
#import "converter.h"

#import "Incoming.h"
#import "Outgoing.h"

#import "PhotoMediaItem.h"
#import "VideoMediaItem.h"

#import "ChatView.h"

#import "TransactionData.h"
#import "UserProfileViewController.h"
#import "ChatViewUIHelper.h"

//------------------------------------------------------------------------------------------------------------------------------
@implementation ChatView
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString                        *groupId;
    
    BOOL                            initialized;
    
    Firebase                        *firebase1;
    
    NSMutableArray                  *items;
    NSMutableArray                  *messages;
    NSMutableDictionary             *avatars;
    NSMutableDictionary             *messageStatusDict;
    
    JSQMessagesBubbleImage          *_bubbleImageOutgoing;
    JSQMessagesBubbleImage          *_bubbleImageOutgoingSending;
    JSQMessagesBubbleImage          *_bubbleImageIncoming;
    
    UIView                          *_background;
    
    JTImageButton                   *_makingOfferButton;
    JTImageButton                   *_leavingFeedbackButton;
    JTImageButton                   *_makingAnotherOfferButton;
    JTImageButton                   *_acceptingButton;
    JTImageButton                   *_decliningButton;
    JTImageButton                   *_editingOfferButton;
    JTImageButton                   *_cancelingOfferButton;
}

@synthesize delegate        =   _delegate;
@synthesize user2Username   =   _user2Username;
@synthesize offerData       =   _offerData;
@synthesize isUnread        =   _isUnread;


#pragma mark - Initialization

//------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)groupId_
//------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	groupId = groupId_;
	return self;
}


#pragma mark - UIViewController methods

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self initUI];
    [self addTopButtons];
    
    [self registerNotification];
    
	[self loadMessages];
    
    [self updateUnreadChatNotification];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
    
    [self removeObserver];
}


#pragma mark - Setup

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    items = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    messageStatusDict = [[NSMutableDictionary alloc] init];
    
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[PF_USER_USERNAME];
    
    firebase1 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Message/%@", FIREBASE, groupId]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) registerNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWillUploadMessageNotification:) name:NOTIFICATION_WILL_UPLOAD_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUploadMessageSuccessfullyNotification:) name:NOTIFICATION_UPLOAD_MESSAGE_SUCCESSFULLY object:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) removeObserver
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.isMovingFromParentViewController)
    {
        [firebase1 removeAllObservers];
    }
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:_user2Username forViewController:self];
    [Utilities customizeBackButtonForViewController:self withAction:@selector(backButtonTapEventHandler)];
    
    // table is displayed below top buttons
    self.topContentAdditionalInset = FLAT_BUTTON_HEIGHT + 10;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
    self.showLoadEarlierMessagesHeader = YES;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    _bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING];
    _bubbleImageOutgoingSending = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING_SENDING];
    _bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:COLOR_INCOMING];
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(actionCopy:)];
    
    UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(actionCopy:)];
    [UIMenuController sharedMenuController].menuItems = @[menuItemCopy];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTopButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addBackgroundForTopButtons];
    [self addMakingOfferButton];
    [self addLeavingFeedbackButton];
    [self addMakingAnotherOfferButton];
    [self addDecliningButton];
    [self addAcceptingButton];
    [self addEdittingOfferButton];
    [self addCancellingButton];
    
    [self adjustVisibilityOfTopFunctionalButtons];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBackgroundForTopButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    _background = [ChatViewUIHelper addBackgroundForTopButtonsToViewController:self];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addMakingOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _makingOfferButton = [ChatViewUIHelper addMakingOfferButtonToView:_background];
    [_makingOfferButton addTarget:self action:@selector(makingOfferButtonTapEventHanlder) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addMakingAnotherOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _makingAnotherOfferButton = [ChatViewUIHelper addMakingAnotherOfferButtonToView:_background currentOffer:_offerData];
    [_makingAnotherOfferButton addTarget:self action:@selector(makingAnotherOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addEdittingOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _editingOfferButton = [ChatViewUIHelper addEditingOfferButtonToView:_background];
    [_editingOfferButton addTarget:self action:@selector(edittingOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addCancellingButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _cancelingOfferButton = [ChatViewUIHelper addCancelingOfferButtonToView:_background];
    [_cancelingOfferButton addTarget:self action:@selector(cancellingOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addAcceptingButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _acceptingButton = [ChatViewUIHelper addAcceptingOfferButtonToView:_background];
    [_acceptingButton addTarget:self action:@selector(acceptingOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDecliningButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _decliningButton = [ChatViewUIHelper addDecliningOfferButtonToView:_background];
    [_decliningButton addTarget:self action:@selector(decliningOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLeavingFeedbackButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _leavingFeedbackButton = [ChatViewUIHelper addLeavingFeedbackButtonToView:_background];
    [_leavingFeedbackButton addTarget:self action:@selector(leavingFeedbackButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) adjustVisibilityOfTopFunctionalButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    [ChatViewUIHelper adjustVisibilityOfTopFunctionalButtonsStartWithMakingOfferButton:_makingOfferButton makingAnotherOfferButton:_makingAnotherOfferButton editingOfferButton:_editingOfferButton cancelingOfferButton:_cancelingOfferButton acceptingOfferButton:_acceptingButton decliningButton:_decliningButton leavingFeedbackButton:_leavingFeedbackButton currentOffer:_offerData];
}


#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) receiveWillUploadMessageNotification: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    // if message is still being sent, its status is 'sending'.
    // use messageStatusDict dictionary to see if the message is sent successfully or not
    NSString *messageID = (NSString *) notification.object;
    messageStatusDict[messageID] = @NO;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) receiveUploadMessageSuccessfullyNotification: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    // update messageStatusDict when message is sent successfully. Reload the collection view after that.
    NSString *messageID = (NSString *) notification.object;
    messageStatusDict[messageID] = @YES;
    [self.collectionView reloadData];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) backButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    DeleteRecentItems(groupId);
    
    NSInteger viewControllersNum = [self.navigationController.viewControllers count];
    if (viewControllersNum >= 3)
    {
        if ([[self.navigationController.viewControllers objectAtIndex:viewControllersNum-2] isKindOfClass:[BuyersOrSellersOfferViewController class]])
        {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:viewControllersNum-3];
            [self.navigationController popToViewController:viewController animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) makingOfferButtonTapEventHanlder
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"MakeOfferFromChatEvent" label:@"MakeOfferButton" value:nil];
    
    BuyersOrSellersOfferViewController *offerVC = [[BuyersOrSellersOfferViewController alloc] init];
    offerVC.offerData = _offerData;
    offerVC.offerFrom = OFFER_FROM_CHAT_VIEW;
    offerVC.delegate = self;
    
    if ([[PFUser currentUser].objectId isEqualToString:_offerData.sellerID])
    {
        // current user is the seller
        [offerVC setBuyerName:_user2Username];
    }
    else
    {
        // current user is the buyer
        [offerVC setBuyerName:[PFUser currentUser][PF_USER_USERNAME]];
    }
    
    [self.navigationController pushViewController:offerVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) edittingOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"EditOfferFromChatEvent" label:@"EditOfferButton" value:nil];
    
    BuyersOrSellersOfferViewController *offerVC = [[BuyersOrSellersOfferViewController alloc] init];
    offerVC.offerData = _offerData;
    offerVC.offerFrom = OFFER_FROM_CHAT_VIEW;
    offerVC.delegate = self;
    
    if ([[PFUser currentUser].objectId isEqualToString:_offerData.sellerID])
    {
        // current user is the seller
        [offerVC setBuyerName:_user2Username];
    }
    else
    {
        // current user is the buyer
        [offerVC setBuyerName:[PFUser currentUser][PF_USER_USERNAME]];
    }
    
    [self.navigationController pushViewController:offerVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancellingOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"CancelOfferFromChatEvent" label:@"CancelOfferButton" value:nil];
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFObject *offerObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [offerObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            [Utilities displayErrorAlertView];
            
            [offerObj deleteEventually];
        }
        else
        {
            _offerData.objectID = @"";
            _offerData.initiatorID = @"";
            _offerData.offeredPrice = @"";
            _offerData.deliveryTime = @"";
            _offerData.transactionStatus = TRANSACTION_STATUS_CANCELLED;
            
            [self adjustVisibilityOfTopFunctionalButtons];
            
            // Update recent message
            NSString *message = [NSString stringWithFormat:@"\n %@ \n", NSLocalizedString(@"Cancel Offer", nil)];
            NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:_offerData.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_offerData.objectID, FB_CURRENT_OFFERED_PRICE:_offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:_offerData.deliveryTime};
            
            [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeCancellingOffer TransactionDetails:transDetails CompletionBlock:nil];
            
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) makingAnotherOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"MakeAnotherOfferFromChatEvent" label:@"MakeAnotherOfferButton" value:nil];
    
    BuyersOrSellersOfferViewController *offerVC = [[BuyersOrSellersOfferViewController alloc] init];
    [offerVC setOfferData:_offerData];
    [offerVC setDelegate:self];
    
    if ([[PFUser currentUser].objectId isEqualToString:_offerData.sellerID])
    {
        // current user is the seller
        [offerVC setBuyerName:_user2Username];
    }
    else
    {
        // current user is the buyer
        [offerVC setBuyerName:[PFUser currentUser][PF_USER_USERNAME]];
    }
    
    [self.navigationController pushViewController:offerVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) decliningOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"DeclineOfferFromChatEvent" label:@"DeclineOfferButton" value:nil];
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFObject *offerObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [offerObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            [Utilities displayErrorAlertView];
            
            [offerObj deleteEventually];
        }
        else
        {
            _offerData.objectID = @"";
            _offerData.initiatorID = @"";
            _offerData.offeredPrice = @"";
            _offerData.deliveryTime = @"";
            _offerData.transactionStatus = TRANSACTION_STATUS_DECLINED;
            
            [self adjustVisibilityOfTopFunctionalButtons];
            
            // Update recent message
            NSString *message = [NSString stringWithFormat:@"\n %@ \n", NSLocalizedString(@"Decline Offer", nil)];
            NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:_offerData.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_offerData.objectID, FB_CURRENT_OFFERED_PRICE:_offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:_offerData.deliveryTime};
            
            [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeDecliningOffer TransactionDetails:transDetails CompletionBlock:nil];
            
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) acceptingOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"AcceptOfferFromChatEvent" label:@"AcceptOfferButton" value:nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to accept this offer?", nil) message:NSLocalizedString(@"Once accepted, offer cannot be cancelled!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    alertView.delegate = self;
    [alertView show];
}

/*
 * Update UI and Backend after accepting offer from a seller.
 * 1. Add a new record to table AcceptedTransactionTable
 * 2. Delete a record from OngoingTransactionData
 * 3. Update table OngoingWantData
 * 4. Update UI
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) acceptOffer
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    // update transactional data
    _offerData.transactionStatus = TRANSACTION_STATUS_ACCEPTED;
    PFObject *offerObj = [_offerData createPFObjectWithClassName:PF_ACCEPTED_TRANSACTION_CLASS];
    [offerObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             [self adjustVisibilityOfTopFunctionalButtons];
             
             // Update recent message
             NSString *message = [NSString stringWithFormat:@"\n %@ \n", NSLocalizedString(@"Accept Offer", nil)];
             NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:_offerData.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_offerData.objectID, FB_CURRENT_OFFERED_PRICE:_offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:_offerData.deliveryTime};
             
             [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeAcceptingOffer TransactionDetails:transDetails CompletionBlock:nil];
             
             PFObject *pfObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
             [pfObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  if (!succeeded)
                  {
                      [pfObj deleteEventually];
                  }
              }];
             
             [Utilities hideIndeterminateProgressIndicatorInView:self.view];
         }
         else
         {
             [Utilities handleError:error];
             [Utilities hideIndeterminateProgressIndicatorInView:self.view];
             [Utilities displayErrorAlertView];
             
             [offerObj saveEventually];
             
             PFObject *pfObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
             [pfObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  if (!succeeded)
                  {
                      [pfObj deleteEventually];
                  }
              }];
         }
     }];
    
    // update wantData
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_OBJECT_ID equalTo:_offerData.itemID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             [Utilities handleError:error];
         }
         else
         {
             if (objects.count > 1)
             {
                 [Utilities logOutMessage:@"Error in acceptingOfferButtonTapEventHandler"];
             }
             else
             {
                 PFObject *object = [objects objectAtIndex:0];
                 object[PF_ITEM_IS_FULFILLED] = STRING_OF_YES;
                 [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (!succeeded)
                      {
                          [Utilities handleError:error];
                      }
                  }];
             }
         }
     }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) leavingFeedbackButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"LeaveOfferFromChatEvent" label:@"LeaveOfferButton" value:nil];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    [query whereKey:PF_FEEDBACK_WRITER_ID equalTo:[PFUser currentUser].objectId];
    [query whereKey:PF_FEEDBACK_RECEIVER_ID equalTo:[Utilities idOfDealerDealingWithMe:_offerData]];
    [query whereKey:PF_FEEDBACK_IS_WRITER_THE_BUYER equalTo:[Utilities stringFromBoolean:[Utilities amITheBuyer:_offerData]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        }
        else
        {
            LeaveFeedbackVC *leaveFeedbackVC = [[LeaveFeedbackVC alloc] initWithOfferData:_offerData];
            leaveFeedbackVC.delegate = self;
            leaveFeedbackVC.receiverUsername = _user2Username;
            
            if ([objects count] > 0)
            {
                if ([objects count] > 1)
                {
                    [Utilities logOutMessage:@"leavingFeedbackButtonTapEventHandler duplicate feedback"];
                }
                else
                {
                    PFObject *obj = [objects objectAtIndex:0];
                    FeedbackData *feedback = [[FeedbackData alloc] initWithPFObject:obj];
                    [leaveFeedbackVC setFeedbackData:feedback];
                }
            }
            
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            
            [self.navigationController pushViewController:leaveFeedbackVC animated:YES];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateOfferStatus: (NSString *) lastMessageType messageFromSender:  (NSString *) senderID andCurrOfferID: (NSString *) offerID
//------------------------------------------------------------------------------------------------------------------------------
{
    ChatMessageType messageType = [Utilities chatMessageTypeFromString:lastMessageType];
    if (messageType == ChatMessageTypeMakingOffer)
    {
        _offerData = [_offerData createNewDataObject];
        _offerData.objectID = offerID;        
        _offerData.transactionStatus = TRANSACTION_STATUS_ONGOING;
        _offerData.initiatorID = senderID;
    }
    else if (messageType == ChatMessageTypeCancellingOffer)
    {
        _offerData = [_offerData createNewDataObject];
        _offerData.transactionStatus = TRANSACTION_STATUS_CANCELLED;
        
        // post notification to notify ItemDetails
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OFFER_CANCELLED object:nil];
    }
    else if (messageType == ChatMessageTypeDecliningOffer)
    {
        _offerData = [_offerData createNewDataObject];
        _offerData.transactionStatus = TRANSACTION_STATUS_DECLINED;
        
        // post notification to notify ItemDetails
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OFFER_DECLINED object:nil];
    }
    else if (messageType == ChatMessageTypeAcceptingOffer)
    {
        _offerData.transactionStatus = TRANSACTION_STATUS_ACCEPTED;
        
        // post notification to notify ItemDetails
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OFFER_ACCEPTED object:_offerData.itemID];
    }
    
    // update visibility of top functional button if a transactional event happens.
    if (messageType != ChatMessageTypeNormal && messageType != ChatMessageTypeNone)
    {
        [self adjustVisibilityOfTopFunctionalButtons];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateUnreadChatNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    ClearRecentCounter1(groupId);
    
    [_delegate chatView:self didSeeAnUnreadConversation:_isUnread];
    
    _isUnread = NO;
}


#pragma mark - Backend methods

//------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages
//------------------------------------------------------------------------------------------------------------------------------
{
	initialized = NO;
	self.automaticallyScrollsToMostRecentMessage = NO;
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    Firebase *queryForLatestMessages = (Firebase *) [[firebase1 queryOrderedByKey] queryLimitedToLast:NUM_OF_MESSAGES_IN_EACH_LOADING_TIME];
	
	[queryForLatestMessages observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)
	{
		BOOL incoming = [self addMessage:snapshot.value];

		if (initialized)
		{
            // initialized is set to YES after all messages have been retrieved when ChatView is first displayed
			if (incoming)
            {
                [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
            }
			[self finishReceivingMessage];
            
            NSDictionary *item = snapshot.value;
            [self updateOfferStatus:item[CHAT_MESSAGE_TYPE] messageFromSender:item[@"userId"] andCurrOfferID:item[FB_CURRENT_OFFER_ID]];
            [self updateUnreadChatNotification];
		}
	}];
	
    // Event Value is only observed once.
	[firebase1 observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		[self finishReceivingMessage];
		[self scrollToBottomAnimated:NO];
		self.automaticallyScrollsToMostRecentMessage = YES;
		initialized	= YES;
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
	}];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) loadEarlierMessages
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL)addMessage:(NSDictionary *)item
//------------------------------------------------------------------------------------------------------------------------------
{
	Incoming *incoming = [[Incoming alloc] initWith:self.senderId ChatView:self];
	JSQMessage *message = [incoming create:item];
	
	if (message == nil) return NO;
	
	[items addObject:item];
	[messages addObject:message];
	
	return [self incoming:message];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)loadAvatar:(NSString *)senderId
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *imageKey = [NSString stringWithFormat:@"%@%@", senderId, USER_PROFILE_IMAGE];
    UIImage *image = [[ProfileImageCache sharedCache] objectForKey:imageKey];
    
    if (image)
        avatars[senderId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
    else
        [self downloadImageFromRemoteServer:senderId];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) downloadImageFromRemoteServer: (NSString *) senderId
//-------------------------------------------------------------------------------------------------------------------------------
{
    FetchedUserHandler successHandler = ^(PFUser *user, UIImage *image)
    {
        avatars[senderId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
        [self.collectionView reloadData];
        
        NSString *imageKey = [NSString stringWithFormat:@"%@%@", senderId, USER_PROFILE_IMAGE];
        [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
    };
    
    [Utilities getUserWithID:senderId imageNeeded:YES andRunBlock:successHandler];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)messageSend:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture Audio:(NSString *)audio ChatMessageType: (ChatMessageType) type TransactionDetails: (NSDictionary *) details CompletionBlock: (CompletionHandler) completionBlock
//-------------------------------------------------------------------------------------------------------------------------------
{
	Outgoing *outgoing = [[Outgoing alloc] initWith:groupId View:self.navigationController.view];
	[outgoing send:text Video:video Picture:picture Audio:audio ChatMessageType:type TransactionDetails:details CompletionBlock:completionBlock];
	
	[JSQSystemSoundPlayer jsq_playMessageSentSound];
	[self finishSendingMessage];
}


#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)name date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------
{
	[self messageSend:text Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeNormal TransactionDetails:nil CompletionBlock:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------
{
	[self actionAttach];
}


#pragma mark - JSQMessagesCollectionViewDataSource

//-------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	return messages[indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
			 messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	if ([self outgoing:messages[indexPath.item]])
	{
        NSString *key = (NSString *) items[indexPath.item][@"key"];
        if ([messageStatusDict objectForKey:key])
        {
            BOOL isSuccessful = [messageStatusDict[key] boolValue];
            if (!isSuccessful)
                return _bubbleImageOutgoingSending;
            else
                return _bubbleImageOutgoing;
        }
        else
            return _bubbleImageOutgoing;
	}
    else
    {
        return _bubbleImageIncoming;
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
					avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if (avatars[message.senderId] == nil)
	{
		[self loadAvatar:message.senderId];
		return avatars[message.senderId];
	}
	else
        return avatars[message.senderId];
}

/*
 * Return an attributed string or nil for Cell top label.
 * Here, Cell top label is either timestamp or nil
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item == 0)
	{
		JSQMessage *message = messages[indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    else
    {
        NSDate *currMessageDate = String2Date(items[indexPath.item][@"date"]);
        NSDate *prevMessageDate = String2Date(items[indexPath.item - 1][@"date"]);
        NSDate *currMessageRoundDate = [Utilities getRoundMinuteDateFromDate:currMessageDate];
        NSDate *prevMessageRoundDate = [Utilities getRoundMinuteDateFromDate:prevMessageDate];
        int timePeriod = [currMessageRoundDate timeIntervalSinceDate:prevMessageRoundDate];
        
        if (timePeriod > 0)
        {
            // if current message and previous message are of different minutes, then display timestamp for current message
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:currMessageDate];
        }
        else
            return nil;
    }
}

/*
 * Display sender name on top of the message bubble if necessary
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if ([self incoming:message])
	{
		if (indexPath.item > 0)
		{
			JSQMessage *previous = messages[indexPath.item-1];
			if ([previous.senderId isEqualToString:message.senderId])
			{
				return nil;
			}
		}
		return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
	}
	else
        return nil;
}

/*
 * Display status of an outgoing message. The status can be either 'Sending...' or 'Delivered'
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	if ([self outgoing:messages[indexPath.item]])
	{
		NSDictionary *item = items[indexPath.item];
        if ([messageStatusDict objectForKey:item[@"key"]]) {
            BOOL isSuccessful = [messageStatusDict[item[@"key"]] boolValue];
            if (!isSuccessful)
                return [[NSAttributedString alloc] initWithString:@"Sending..."];
        }
        
		return [[NSAttributedString alloc] initWithString:item[@"status"]];
	}
	else
        return nil;
}


#pragma mark - UICollectionViewDataSource

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------
{
	return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

	if ([self outgoing:messages[indexPath.item]])
    {
		cell.textView.textColor = [UIColor whiteColor];
        
        ChatMessageType messageType = [Utilities chatMessageTypeFromString:items[indexPath.item][CHAT_MESSAGE_TYPE]];
        if (messageType == ChatMessageTypeNormal)
            cell.textView.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:16.5];
        else
            cell.textView.font = [UIFont fontWithName:BOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
	}
    else
    {
		cell.textView.textColor = TEXT_COLOR_LESS_DARK;
        
        ChatMessageType messageType = [Utilities chatMessageTypeFromString:items[indexPath.item][CHAT_MESSAGE_TYPE]];
        if (messageType == ChatMessageTypeNormal)
            cell.textView.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:16.5];
        else
            cell.textView.font = [UIFont fontWithName:BOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
	}
    
	return cell;
}


#pragma mark - UICollectionViewDelegate

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
			withSender:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------
{
	if (action == @selector(actionCopy:))
	{
		NSDictionary *item = items[indexPath.item];
		if ([item[@"type"] isEqualToString:@"text"])
            return YES;
	}

	return NO;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
			withSender:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------
{
	if (action == @selector(actionCopy:))
        [self actionCopy:indexPath];
}


#pragma mark - JSQMessagesCollectionViewDelegateFlowLayout

/*
 * Return height for timestamp label
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.item == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else
    {
        NSDate *currMessageDate = String2Date(items[indexPath.item][@"date"]);
        NSDate *prevMessageDate = String2Date(items[indexPath.item - 1][@"date"]);
        NSDate *currMessageRoundDate = [Utilities getRoundMinuteDateFromDate:currMessageDate];
        NSDate *prevMessageRoundDate = [Utilities getRoundMinuteDateFromDate:prevMessageDate];
        int timePeriod = [currMessageRoundDate timeIntervalSinceDate:prevMessageRoundDate];
        
        if (timePeriod > 0)
        {
            // timestamp label is displayed
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        else
            // timestamp label is not displayed
            return 0;
    }
}

/*
 * Return height for sender's name label
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if ([self incoming:message])
	{
		if (indexPath.item > 0)
		{
			JSQMessage *previous = messages[indexPath.item-1];
			if ([previous.senderId isEqualToString:message.senderId])
			{
                // sender's name label is not displayed
				return 0;
			}
		}
        
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else
        // sender's name label is not displayed
        return 0;
}

/*
 * Return height for message status label
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	if ([self outgoing:messages[indexPath.item]])
	{
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else
        return 0;
}


#pragma mark - Responding to collection view tap events

//-------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities logOutMessage:@"didTapLoadEarlierMessagesButton"];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	
	if (message.isMediaMessage)
	{
		if ([message.media isKindOfClass:[PhotoMediaItem class]])
		{
			PhotoMediaItem *mediaItem = (PhotoMediaItem *)message.media;
			NSArray *photos = [IDMPhoto photosWithImages:@[mediaItem.image]];
			IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
			[self presentViewController:browser animated:YES completion:nil];
		}
        
		if ([message.media isKindOfClass:[VideoMediaItem class]])
		{
			VideoMediaItem *mediaItem = (VideoMediaItem *)message.media;
			MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaItem.fileURL];
			[self presentMoviePlayerViewControllerAnimated:moviePlayer];
			[moviePlayer.moviePlayer play];
		}
	}
}

/*
 * When avatar is tapped, user profile of corresponding user is presented.
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void) collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    UserHandler handler = ^(PFUser *user)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    JSQMessage *message = messages[indexPath.item];
    [Utilities retrieveUserInfoByUserID:message.senderId andRunBlock:handler];
}

////------------------------------------------------------------------------------------------------------------------------------
//- (void) scrollViewDidScroll:(UIScrollView *)scrollView
////------------------------------------------------------------------------------------------------------------------------------
//{
//    CGFloat const yPosOfLoadEarlierMessageButton = -80.0f;
//    
//    if (scrollView.contentOffset.y < yPosOfLoadEarlierMessageButton)
//    {
//        NSLog(@"dispatch_once dispatch_once dispatch_once");
//        JSQMessagesLoadEarlierHeaderView *headerView = [self.collectionView dequeueLoadEarlierMessagesViewHeaderForIndexPath:0];
//        [Utilities showSmallIndeterminateProgressIndicatorInView:headerView];
//    }
//}


#pragma mark - User actions

/*
 * Show Camera and Pictures options when user chooses to attach media content.
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void)actionAttach
//-------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
	NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_camera.png"] title:@"Camera"],
						   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_pictures.png"] title:@"Pictures"]];
	RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
	gridMenu.delegate = self;
	[gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

/*
 * User chooses to copy some text
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void)actionCopy:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	NSDictionary *item = items[indexPath.item];
	[[UIPasteboard generalPasteboard] setString:item[@"text"]];
}


#pragma mark - RNGridMenuDelegate

//-------------------------------------------------------------------------------------------------------------------------------
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
	[gridMenu dismissAnimated:NO];
    
	if ([item.title isEqualToString:@"Camera"])
        PresentMultiCamera(self, YES);
    
	if ([item.title isEqualToString:@"Pictures"])
        PresentPhotoLibrary(self, YES);
}


#pragma mark - UIImagePickerControllerDelegate

/*
 * This function gets called after user chose an image or video from library
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
	NSURL *video = info[UIImagePickerControllerMediaURL];
	UIImage *picture = info[UIImagePickerControllerEditedImage];
	
	[self messageSend:nil Video:video Picture:picture Audio:nil ChatMessageType:ChatMessageTypeNone TransactionDetails:nil CompletionBlock:nil];
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)incoming:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------
{
	return ([message.senderId isEqualToString:self.senderId] == NO);
}

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)outgoing:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------
{
	return ([message.senderId isEqualToString:self.senderId] == YES);
}


#pragma mark - BuyersOrSellerOfferDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) buyersOrSellersOfferViewController:(BuyersOrSellersOfferViewController *)controller didOffer:(TransactionData *)offer
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self adjustVisibilityOfTopFunctionalButtons];
    _offerData = offer;
    
    NSString *message = [Utilities makingOfferMessageFromOfferedPrice:offer.offeredPrice andDeliveryTime:offer.deliveryTime];
    NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:_offerData.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_offerData.objectID, FB_CURRENT_OFFERED_PRICE:_offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:_offerData.deliveryTime};
    
    [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeMakingOffer TransactionDetails:transDetails CompletionBlock:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - LeaveFeedbackViewDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) leaveFeedBackViewController:(UIViewController *)controller didCompleteGivingFeedBack:(FeedbackData *)feedbackData
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSString *action = NSLocalizedString(@"Given a feedback", nil);
    NSString *message = action;
    [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeLeavingFeeback TransactionDetails:nil CompletionBlock:nil];
}


#pragma mark - UIAlertViewDelegate methods

/*
 * AlertView upon accepting offer
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 1) // Accept Offer
    {
        [self acceptOffer];
    }
}

@end
