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

#import "AppConstant.h"
#import "camera.h"
#import "common.h"
#import "recent.h"
#import "PersistedCache.h"
#import "TemporaryCache.h"
#import "Utilities.h"
#import "converter.h"

#import "Incoming.h"
#import "Outgoing.h"

#import "PhotoMediaItem.h"
#import "VideoMediaItem.h"

#import "ChatView.h"

#import "OfferData.h"

//------------------------------------------------------------------------------------------------------------------------------
@interface ChatView()
{
	NSString *groupId;

	BOOL initialized;
	int typingCounter;

	Firebase *firebase1;
	Firebase *firebase2;

	NSMutableArray *items;
	NSMutableArray *messages;
	NSMutableDictionary *avatars;
    NSMutableDictionary *messageStatusDict;

	JSQMessagesBubbleImage *bubbleImageOutgoing;
    JSQMessagesBubbleImage *bubbleImageOutgoingSending;
	JSQMessagesBubbleImage *bubbleImageIncoming;
	JSQMessagesAvatarImage *avatarImageBlank;
    
    UIView *background;
}
@end
//------------------------------------------------------------------------------------------------------------------------------

@implementation ChatView

@synthesize user2Username;
@synthesize offerData = _offerData;

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
	self.navigationItem.title = user2Username;
    [self customizeNavigationBar];
	
	items = [[NSMutableArray alloc] init];
	messages = [[NSMutableArray alloc] init];
	avatars = [[NSMutableDictionary alloc] init];
    messageStatusDict = [[NSMutableDictionary alloc] init];
	
	PFUser *user = [PFUser currentUser];
	self.senderId = user.objectId;
	self.senderDisplayName = user[PF_USER_USERNAME];
    
    [self addMakeOfferButton];
	
	JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
	bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING];
    bubbleImageOutgoingSending = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING_SENDING];
	bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:COLOR_INCOMING];
    
    avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"user_profile_circle.png"] diameter:30.0];
    
	[JSQMessagesCollectionViewCell registerMenuAction:@selector(actionCopy:)];
	
	UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(actionCopy:)];
	[UIMenuController sharedMenuController].menuItems = @[menuItemCopy];
	
	firebase1 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Message/%@", FIREBASE, groupId]];
	firebase2 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Typing/%@", FIREBASE, groupId]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWillUploadMessageNotification:) name:NOTIFICATION_WILL_UPLOAD_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUploadMessageSuccessfullyNotification:) name:NOTIFICATION_UPLOAD_MESSAGE_SUCCESSFULLY object:nil];
	
	[self loadMessages];
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
    
    DeleteRecentItems(groupId);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	if (self.isMovingFromParentViewController)
	{
		[firebase1 removeAllObservers];
		[firebase2 removeAllObservers];
	}
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBackGroundForButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat statusAndNavigationBarHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    background = [[UIView alloc] initWithFrame:CGRectMake(0, statusAndNavigationBarHeight, WINSIZE.width, 50)];
    [background setBackgroundColor:LIGHTEST_GRAY_COLOR];
    [background setAlpha:0.98];
    [self.view addSubview:background];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addMakeOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addBackGroundForButtons];
    
    JTImageButton *makingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, 10, WINSIZE.width * 0.8, 30)];
    [makingOfferButton createTitle:@"Make Offer" withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconHeight:0 iconOffsetY:0];
    makingOfferButton.cornerRadius = 6.0;
    makingOfferButton.borderWidth = 2.0;
    makingOfferButton.borderColor = FLAT_BLUE_COLOR;
    makingOfferButton.bgColor = FLAT_BLUE_COLOR;
    makingOfferButton.titleColor = [UIColor whiteColor];
    [makingOfferButton addTarget:self action:@selector(makingOfferButtonTapEventHanlder) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:makingOfferButton];
    
    // Only seller can offer at the beginning
    if ([[PFUser currentUser].objectId isEqualToString:_offerData.buyerID])
        [background setHidden:YES];
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
- (void) makingOfferButtonTapEventHanlder
//------------------------------------------------------------------------------------------------------------------------------
{
    OfferData *offerData = [[OfferData alloc] init];
     
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
		}
	}];
	//--------------------------------------------------------------------------------------------------------------------------
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
	//--------------------------------------------------------------------------------------------------------------------------
	if (message == nil) return NO;
	//--------------------------------------------------------------------------------------------------------------------------
	[items addObject:item];
	[messages addObject:message];
	//--------------------------------------------------------------------------------------------------------------------------
	return [self incoming:message];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)loadAvatar:(NSString *)senderId
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([senderId isEqualToString:[PFUser currentUser].objectId]) {
        UIImage *image = [[PersistedCache sharedCache] imageForKey:senderId];
        avatars[senderId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
    } else {
        UIImage *image = [[TemporaryCache sharedCache] objectForKey:senderId];
        if (image)
            avatars[senderId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
        else
            [self downloadImageFromRemoteServer:senderId];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)messageSend:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture Audio:(NSString *)audio
//-------------------------------------------------------------------------------------------------------------------------------
{
	Outgoing *outgoing = [[Outgoing alloc] initWith:groupId View:self.navigationController.view];
	[outgoing send:text Video:video Picture:picture Audio:audio];
	
	[JSQSystemSoundPlayer jsq_playMessageSentSound];
	[self finishSendingMessage];
}

#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)name date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------
{
	[self messageSend:text Video:nil Picture:nil Audio:nil];
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
        if ([messageStatusDict objectForKey:key]) {
            BOOL isSuccessful = [messageStatusDict[key] boolValue];
            if (!isSuccessful)
                return bubbleImageOutgoingSending;
            else
                return bubbleImageOutgoing;
        } else
            return bubbleImageOutgoing;
	}
	else return bubbleImageIncoming;
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
	else return avatars[message.senderId];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item == 0)
	{
		JSQMessage *message = messages[indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    } else {
        NSDate *currMessageDate = String2Date(items[indexPath.item][@"date"]);
        NSDate *prevMessageDate = String2Date(items[indexPath.item - 1][@"date"]);
        NSDate *currMessageRoundDate = [Utilities getRoundMinuteDateFromDate:currMessageDate];
        NSDate *prevMessageRoundDate = [Utilities getRoundMinuteDateFromDate:prevMessageDate];
        int timePeriod = [currMessageRoundDate timeIntervalSinceDate:prevMessageRoundDate];
        if (timePeriod > 0) {
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:currMessageDate];
        } else
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
	else return nil;
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
	else return nil;
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
	}
	else
	{
		cell.textView.textColor = [UIColor blackColor];
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
	if (action == @selector(actionCopy:))		[self actionCopy:indexPath];
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
    } else {
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
	if ([item.title isEqualToString:@"Camera"])		PresentMultiCamera(self, YES);
	if ([item.title isEqualToString:@"Pictures"])	PresentPhotoLibrary(self, YES);
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
	NSURL *video = info[UIImagePickerControllerMediaURL];
	UIImage *picture = info[UIImagePickerControllerEditedImage];
	//---------------------------------------------------------------------------------------------------------------------------
	[self messageSend:nil Video:video Picture:picture Audio:nil];
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
                      }
                  }];
             }
         }
         else NSLog(@"ChatView loadAvatar query error.");
     }];
}

@end
