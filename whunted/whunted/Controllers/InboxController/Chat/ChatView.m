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
#import <MBProgressHUD.h>

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

//------------------------------------------------------------------------------------------------------------------------------
@interface ChatView()
{
	NSString                *groupId;

	BOOL                    initialized;
	int                     typingCounter;

	Firebase                *firebase1;
	Firebase                *firebase2;

	NSMutableArray          *items;
	NSMutableArray          *messages;
	NSMutableDictionary     *avatars;
    NSMutableDictionary     *messageStatusDict;

	JSQMessagesBubbleImage  *_bubbleImageOutgoing;
    JSQMessagesBubbleImage  *_bubbleImageOutgoingSending;
	JSQMessagesBubbleImage  *_bubbleImageIncoming;

	JSQMessagesAvatarImage  *_avatarImageBlank;
    
    UIView                  *_background;
    
    JTImageButton           *_makingOfferButton;
    JTImageButton           *_leavingFeedbackButton;
    JTImageButton           *_makingAnotherOfferButton;
    JTImageButton           *_acceptingButton;
    JTImageButton           *_decliningButton;
    JTImageButton           *_edittingOfferButton;
    JTImageButton           *_cancellingOfferButton;
}
@end
//------------------------------------------------------------------------------------------------------------------------------

@implementation ChatView

@synthesize delegate        =   _delegate;
@synthesize user2Username   =   _user2Username;
@synthesize offerData       =   _offerData;
@synthesize isUnread        =   _isUnread;

//------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)groupId_
//------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	groupId = groupId_;
	return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
    
    [self initData];
    
    [self customizeNavigationBar];
    [self initUI];
    [self addTopButtons];
    [self adjustButtonsVisibility];
    
    [self registerNotification];
	
	[self loadMessages];
    
    [self updateUnreadChatNotification];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"ChatViewScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	if (self.isMovingFromParentViewController)
	{
		[firebase1 removeAllObservers];
		[firebase2 removeAllObservers];
	}
}

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
    firebase2 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Typing/%@", FIREBASE, groupId]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) registerNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWillUploadMessageNotification:) name:NOTIFICATION_WILL_UPLOAD_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUploadMessageSuccessfullyNotification:) name:NOTIFICATION_UPLOAD_MESSAGE_SUCCESSFULLY object:nil];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:_user2Username forViewController:self];
    [Utilities customizeBackButtonForViewController:self withAction:@selector(backButtonTapEventHandler)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    _bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING];
    _bubbleImageOutgoingSending = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING_SENDING];
    _bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:COLOR_INCOMING];
    
    _avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"user_profile_image_placeholder_small.png"] diameter:30.0];
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(actionCopy:)];
    
    UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(actionCopy:)];
    [UIMenuController sharedMenuController].menuItems = @[menuItemCopy];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBackgroundForButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat statusAndNavigationBarHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    _background = [[UIView alloc] initWithFrame:CGRectMake(0, statusAndNavigationBarHeight, WINSIZE.width, FLAT_BUTTON_HEIGHT + 10)];
    [_background setBackgroundColor:LIGHTEST_GRAY_COLOR];
    [_background setAlpha:0.98];
    [self.view addSubview:_background];
    
    // table is displayed below top buttons
    self.topContentAdditionalInset = FLAT_BUTTON_HEIGHT + 10;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTopButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addBackgroundForButtons];
    [self addMakingOfferButton];
    [self addLeavingFeedbackButton];
    [self addMakingAnotherOfferButton];
    [self addDecliningButton];
    [self addAcceptingButton];
    [self addEdittingOfferButton];
    [self addCancellingButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) adjustButtonsVisibility
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_offerData.initiatorID.length > 0) {
        if ([_offerData.transactionStatus isEqualToString:TRANSACTION_STATUS_ACCEPTED]) {
            // Offer was accepted
            [_makingOfferButton setHidden:YES];
            
            [_leavingFeedbackButton setHidden:NO];
            
            [_makingAnotherOfferButton setHidden:YES];
            [_decliningButton setHidden:YES];
            [_acceptingButton setHidden:YES];
            
            [_edittingOfferButton setHidden:YES];
            [_cancellingOfferButton setHidden:YES];
        } else if ([_offerData.transactionStatus isEqualToString:TRANSACTION_STATUS_ONGOING]) {
            if ([_offerData.initiatorID isEqualToString:[PFUser currentUser].objectId]) {
                // Offer is made by me
                [_makingOfferButton setHidden:YES];
                
                [_leavingFeedbackButton setHidden:YES];
                
                [_makingAnotherOfferButton setHidden:YES];
                [_decliningButton setHidden:YES];
                [_acceptingButton setHidden:YES];
                
                [_edittingOfferButton setHidden:NO];
                [_cancellingOfferButton setHidden:NO];
            } else {
                [_makingOfferButton setHidden:YES];
                
                [_leavingFeedbackButton setHidden:YES];
                
                [_makingAnotherOfferButton setHidden:NO];
                [_decliningButton setHidden:NO];
                [_acceptingButton setHidden:NO];
                
                [_edittingOfferButton setHidden:YES];
                [_cancellingOfferButton setHidden:YES];
            }
        } else if ([_offerData.transactionStatus isEqualToString:TRANSACTION_STATUS_CANCELLED] || [_offerData.transactionStatus isEqualToString:TRANSACTION_STATUS_DECLINED]) {
            [_makingOfferButton setHidden:NO];
            
            [_leavingFeedbackButton setHidden:YES];
            
            [_makingAnotherOfferButton setHidden:YES];
            [_decliningButton setHidden:YES];
            [_acceptingButton setHidden:YES];
            
            [_edittingOfferButton setHidden:YES];
            [_cancellingOfferButton setHidden:YES];
        }
    } else {
        // No one has made any offers yet
        [_makingOfferButton setHidden:NO];
        
        [_leavingFeedbackButton setHidden:YES];
        
        [_makingAnotherOfferButton setHidden:YES];
        [_decliningButton setHidden:YES];
        [_acceptingButton setHidden:YES];
        
        [_edittingOfferButton setHidden:YES];
        [_cancellingOfferButton setHidden:YES];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addMakingOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _makingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, 5, WINSIZE.width * 0.8, FLAT_BUTTON_HEIGHT)];
    [_makingOfferButton createTitle:NSLocalizedString(@"Make Offer", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _makingOfferButton.cornerRadius = 6.0;
    _makingOfferButton.borderColor = FLAT_FRESH_RED_COLOR;
    _makingOfferButton.bgColor = FLAT_BLUR_RED_COLOR;
    _makingOfferButton.titleColor = [UIColor whiteColor];
    [_makingOfferButton addTarget:self action:@selector(makingOfferButtonTapEventHanlder) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_makingOfferButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLeavingFeedbackButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _leavingFeedbackButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, 5, WINSIZE.width * 0.8, FLAT_BUTTON_HEIGHT)];
    [_leavingFeedbackButton createTitle:NSLocalizedString(@"Leave Feedback", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _leavingFeedbackButton.cornerRadius = 6.0;
    _leavingFeedbackButton.borderColor = FLAT_GRAY_COLOR;
    _leavingFeedbackButton.bgColor = FLAT_GRAY_COLOR;
    _leavingFeedbackButton.titleColor = [UIColor whiteColor];
    [_leavingFeedbackButton addTarget:self action:@selector(leavingFeedbackButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_leavingFeedbackButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addMakingAnotherOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _makingAnotherOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.03, 5, WINSIZE.width * 0.46, FLAT_BUTTON_HEIGHT)];
    if ([Utilities amITheBuyer:_offerData])
        [_makingAnotherOfferButton createTitle:NSLocalizedString(@"Make another offer buyer", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    else
        [_makingAnotherOfferButton createTitle:NSLocalizedString(@"Make another offer seller", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
        
    _makingAnotherOfferButton.cornerRadius = 6.0;
    _makingAnotherOfferButton.borderColor = FLAT_BLUE_COLOR;
    _makingAnotherOfferButton.bgColor = FLAT_BLUE_COLOR;
    _makingAnotherOfferButton.titleColor = [UIColor whiteColor];
    [_makingAnotherOfferButton addTarget:self action:@selector(makingAnotherOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_makingAnotherOfferButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDecliningButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _decliningButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.52, 5, WINSIZE.width * 0.21, FLAT_BUTTON_HEIGHT)];
    [_decliningButton createTitle:NSLocalizedString(@"Decline", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _decliningButton.cornerRadius = 6.0;
    _decliningButton.borderColor = FLAT_GRAY_COLOR;
    _decliningButton.bgColor = FLAT_GRAY_COLOR;
    _decliningButton.titleColor = [UIColor whiteColor];
    [_decliningButton addTarget:self action:@selector(decliningOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_decliningButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addAcceptingButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _acceptingButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.76, 5, WINSIZE.width * 0.21, FLAT_BUTTON_HEIGHT)];
    [_acceptingButton createTitle:NSLocalizedString(@"Accept", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _acceptingButton.cornerRadius = 6.0;
    _acceptingButton.borderColor = FLAT_BLUR_RED_COLOR;
    _acceptingButton.bgColor = FLAT_BLUR_RED_COLOR;
    _acceptingButton.titleColor = [UIColor whiteColor];
    [_acceptingButton addTarget:self action:@selector(acceptingOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_acceptingButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addEdittingOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _edittingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.05, 5, WINSIZE.width * 0.425, FLAT_BUTTON_HEIGHT)];
    [_edittingOfferButton createTitle:NSLocalizedString(@"Edit Offer", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _edittingOfferButton.cornerRadius = 6.0;
    _edittingOfferButton.borderColor = FLAT_BLUE_COLOR;
    _edittingOfferButton.bgColor = FLAT_BLUE_COLOR;
    _edittingOfferButton.titleColor = [UIColor whiteColor];
    [_edittingOfferButton addTarget:self action:@selector(edittingOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_edittingOfferButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addCancellingButton
//------------------------------------------------------------------------------------------------------------------------------
{
    _cancellingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.525, 5, WINSIZE.width * 0.425, FLAT_BUTTON_HEIGHT)];
    [_cancellingOfferButton createTitle:NSLocalizedString(@"Cancel Offer", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _cancellingOfferButton.cornerRadius = 6.0;
    _cancellingOfferButton.borderColor = FLAT_GRAY_COLOR;
    _cancellingOfferButton.bgColor = FLAT_GRAY_COLOR;
    _cancellingOfferButton.titleColor = [UIColor whiteColor];
    [_cancellingOfferButton addTarget:self action:@selector(cancellingOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_cancellingOfferButton];
}

#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) receiveWillUploadMessageNotification: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *messageID = (NSString *) notification.object;
    messageStatusDict[messageID] = @NO;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) receiveUploadMessageSuccessfullyNotification: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
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
    
    PFObject *offerObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [offerObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
            [offerObj deleteEventually];
        }
        else
        {
            _offerData.objectID = @"";
            _offerData.initiatorID = @"";
            _offerData.offeredPrice = @"";
            _offerData.deliveryTime = @"";
            _offerData.transactionStatus = TRANSACTION_STATUS_CANCELLED;
            
            [self adjustButtonsVisibility];
            
            // Update recent message
            NSString *message = [NSString stringWithFormat:@"\n %@ \n", NSLocalizedString(@"Cancel Offer", nil)];
            NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:_offerData.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_offerData.objectID, FB_CURRENT_OFFERED_PRICE:_offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:_offerData.deliveryTime};
            
            [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeCancellingOffer TransactionDetails:transDetails CompletionBlock:nil];
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
    
    PFObject *offerObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [offerObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
            [offerObj deleteEventually];
        }
        else
        {
            _offerData.objectID = @"";
            _offerData.initiatorID = @"";
            _offerData.offeredPrice = @"";
            _offerData.deliveryTime = @"";
            _offerData.transactionStatus = TRANSACTION_STATUS_DECLINED;
            
            [self adjustButtonsVisibility];
            
            // Update recent message
            NSString *message = [NSString stringWithFormat:@"\n %@ \n", NSLocalizedString(@"Decline Offer", nil)];
            NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:_offerData.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_offerData.objectID, FB_CURRENT_OFFERED_PRICE:_offerData.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:_offerData.deliveryTime};
            
            [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeDecliningOffer TransactionDetails:transDetails CompletionBlock:nil];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) acceptingOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"AcceptOfferFromChatEvent" label:@"AcceptOfferButton" value:nil];
    
    // update transactional data
    _offerData.transactionStatus = TRANSACTION_STATUS_ACCEPTED;
    PFObject *offerObj = [_offerData createPFObjectWithClassName:PF_ACCEPTED_TRANSACTION_CLASS];
    [offerObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [self adjustButtonsVisibility];
            
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
        }
        else
        {
            [Utilities handleError:error];
            [offerObj saveEventually];
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
                NSLog(@"Error in acceptingOfferButtonTapEventHandler");
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                    NSLog(@"leavingFeedbackButtonTapEventHandler duplicate feedback");
                }
                else
                {
                    PFObject *obj = [objects objectAtIndex:0];
                    FeedbackData *feedback = [[FeedbackData alloc] initWithPFObject:obj];
                    [leaveFeedbackVC setFeedbackData:feedback];
                }
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
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
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OFFER_ACCEPTED object:nil];
    }
    
    if (messageType != ChatMessageTypeNormal && messageType != ChatMessageTypeNone)
        [self adjustButtonsVisibility];
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
	
	[firebase1 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)
	{
		BOOL incoming = [self addMessage:snapshot.value];

		if (initialized)
		{
			if (incoming) [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
			[self finishReceivingMessage];
            
            NSDictionary *item = snapshot.value;
            [self updateOfferStatus:item[CHAT_MESSAGE_TYPE] messageFromSender:item[@"userId"] andCurrOfferID:item[FB_CURRENT_OFFER_ID]];
		}
	}];
	
	[firebase1 observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
	{
		[self finishReceivingMessage];
		[self scrollToBottomAnimated:NO];
		self.automaticallyScrollsToMostRecentMessage = YES;
		initialized	= YES;
	}];
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


#pragma mark - JSQMessages CollectionView DataSource

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
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:currMessageDate];
        }
        else
            return nil;
    }
}

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


#pragma mark - UICollectionView DataSource

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
            cell.textView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
        else
            cell.textView.font = [UIFont fontWithName:BOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
	}
    else
    {
		cell.textView.textColor = [UIColor blackColor];
        
        ChatMessageType messageType = [Utilities chatMessageTypeFromString:items[indexPath.item][CHAT_MESSAGE_TYPE]];
        if (messageType == ChatMessageTypeNormal)
            cell.textView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
        else
            cell.textView.font = [UIFont fontWithName:BOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
	}
	return cell;
}


#pragma mark - UICollectionView Delegate

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
			withSender:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------
{
	if (action == @selector(actionCopy:))
	{
		NSDictionary *item = items[indexPath.item];
		if ([item[@"type"] isEqualToString:@"text"]) return YES;
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


#pragma mark - JSQMessages collection view flow layout delegate

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
        if (timePeriod > 0) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        } else
            return 0;
    }
}

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
				return 0;
			}
		}
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	if ([self outgoing:messages[indexPath.item]])
	{
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else return 0;
}


#pragma mark - Responding to collection view tap events

//-------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapLoadEarlierMessagesButton");
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	//---------------------------------------------------------------------------------------------------------------------------
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

//-------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
//-------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}


#pragma mark - User actions

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

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
	NSURL *video = info[UIImagePickerControllerMediaURL];
	UIImage *picture = info[UIImagePickerControllerEditedImage];
	//---------------------------------------------------------------------------------------------------------------------------
	[self messageSend:nil Video:video Picture:picture Audio:nil ChatMessageType:ChatMessageTypeNone TransactionDetails:nil CompletionBlock:nil];
	//---------------------------------------------------------------------------------------------------------------------------
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
    [self adjustButtonsVisibility];
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
    NSString *action = NSLocalizedString(@"has left a feedback", nil);
    NSString *message = [NSString stringWithFormat:@"%@\n %@", [PFUser currentUser][PF_USER_USERNAME], action];
    [self messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeLeavingFeeback TransactionDetails:nil CompletionBlock:nil];
}


#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) downloadImageFromRemoteServer: (NSString *) senderId
//-------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:senderId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             if ([objects count] != 0)
             {
                 PFUser *user = [objects firstObject];
                 PFFile *file = user[PF_USER_PICTURE];
                 [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
                  {
                      if (error == nil)
                      {
                          UIImage *image = [UIImage imageWithData:imageData];
                          avatars[senderId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
                          [self.collectionView reloadData];
                          
                          NSString *imageKey = [NSString stringWithFormat:@"%@%@", senderId, USER_PROFILE_IMAGE];
                          [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
                      }
                  }];
             }
         }
         else
             [Utilities handleError:error];
     }];
}

@end
