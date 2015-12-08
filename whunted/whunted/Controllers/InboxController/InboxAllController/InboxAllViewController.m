//
//  InboxAllViewController.m
//  whunted
//  This class is to display all chat conversations that involves the current user
//  in the app. It is called by MainViewController when the app starts.
//  When the object of this class is initiated, only 10 latest messages are loaded.
//  If the user scrolls down to bottom, older messages will be retrieved.
//
//  Created by thomas nguyen on 17/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "InboxAllViewController.h"
#import "UserProfileViewController.h"
#import "ItemDetailsViewController.h"
#import "MarketplaceBackend.h"
#import "MessageViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "converter.h"

#import <Firebase/Firebase.h>

#define     kControlContainerHeight         60.0f


@implementation InboxAllViewController
{
    UITableView             *_inboxTableView;
    Firebase                *_firebase;
    
    UISegmentedControl      *_categorySegmentedControl;
    
    NSMutableArray          *_recentMessages;
    NSMutableArray          *_categorizedMessages;
}

@synthesize delegate                    =   _delegate;
@synthesize numOfUnreadConversations    =   _numOfUnreadConversations;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil)
    {
        [self customizeUI];
        [self addSegmentedControl];
        [self addInboxTableView];
        
        [self loadRecents];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self addNotificationListener];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationListener
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameButtonTapEventHandler:) name:NOTIFICATION_USERNAME_BUTTON_CHAT_TAP_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openItemDetailsViewController:) name:NOTIFICATION_ITEM_IMAGE_BUTTON_TAP_EVENT object:nil];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Chat", nil) forViewController:self];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *segmentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WINSIZE.width, kControlContainerHeight)];
    [segmentContainer setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_1];
    [self.view addSubview:segmentContainer];
    
    CGFloat const kControlTopMargin = 15.0f;
    CGFloat const kControlLeftMargin = 30.0f;
    CGFloat const kControlHeight = kControlContainerHeight - 2 * kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width - 2 * kControlLeftMargin;
    
    NSArray *categories = @[NSLocalizedString(@"All", nil), NSLocalizedString(@"As Seller", nil), NSLocalizedString(@"As Buyer", nil)];
    _categorySegmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    _categorySegmentedControl.frame = CGRectMake(kControlLeftMargin, kControlTopMargin, kControlWidth, kControlHeight);
    _categorySegmentedControl.tintColor = MAIN_BLUE_COLOR;
    [_categorySegmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE]} forState:UIControlStateNormal];
    _categorySegmentedControl.selectedSegmentIndex = 0;
    [_categorySegmentedControl addTarget:self action:@selector(categorySegmentedControlSelectedIndexChange) forControlEvents:UIControlEventValueChanged];
    [segmentContainer addSubview:_categorySegmentedControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addInboxTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableYPos = kControlContainerHeight + STATUS_BAR_AND_NAV_BAR_HEIGHT;
    CGFloat const kTableHeight = WINSIZE.height - kTableYPos;
    
    _inboxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableYPos, WINSIZE.width, kTableHeight)];
    [_inboxTableView setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_2];
    _inboxTableView.delegate = self;
    _inboxTableView.dataSource = self;
    _inboxTableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_TAB_BAR_HEIGHT, 0);
    [self.view addSubview:_inboxTableView];    
}


#pragma mark - Backend methods

//------------------------------------------------------------------------------------------------------------------------------
- (void)loadRecents
//------------------------------------------------------------------------------------------------------------------------------
{
    _recentMessages = [NSMutableArray array];
    
    PFUser *user = [PFUser currentUser];
    if ((user != nil) && (_firebase == nil))
    {
        [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
        
        _firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
        FQuery *query = [[_firebase queryOrderedByChild:FB_SELF_USER_ID] queryEqualToValue:user.objectId];
        [query observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
         {
             [_recentMessages removeAllObjects];
             if (snapshot.value != [NSNull null])
             {
                 NSArray *sorted = [[snapshot.value allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                    {
                                        NSDictionary *recent1 = (NSDictionary *)obj1;
                                        NSDictionary *recent2 = (NSDictionary *)obj2;
                                        NSDate *date1 = String2Date(recent1[FB_TIMESTAMP]);
                                        NSDate *date2 = String2Date(recent2[FB_TIMESTAMP]);
                                        return [date2 compare:date1];
                                    }];
                 
                 _numOfUnreadConversations = 0;
                 
                 for (NSDictionary *recent in sorted)
                 {
                     [_recentMessages addObject:recent];
                     
                     if ([recent[FB_UNREAD_MESSAGES_COUNTER] integerValue] > 0)
                         _numOfUnreadConversations++;
                 }
                 
                 [self updateCategorizedMessages];
             }
             
             [_delegate inboxAllViewController:self didRetrieveNumOfUnreadConversations:_numOfUnreadConversations];
             
             [_inboxTableView reloadData];
             [Utilities hideIndeterminateProgressIndicatorInView:self.view];
         }];
    }
}


#pragma mark - UITableView Datasource Delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_categorizedMessages count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    MessageViewCell *cell = (MessageViewCell *) [_inboxTableView dequeueReusableCellWithIdentifier:@"MessageViewCell"];
    
    if (cell)
    {
        [cell clearUI];
    }
    else
    {
        cell = [[MessageViewCell alloc] init];
        [cell initCell];
    }
    
    cell.cellIndex = indexPath.row;
    [cell bindData:_categorizedMessages[indexPath.row]];
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    return 118.0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return 1.0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [_inboxTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *recent = _categorizedMessages[indexPath.row];
    [self navigateToChatConversation:recent];
}


#pragma mark - ChatViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) chatView:(ChatView *)chatView didSeeAnUnreadConversation:(BOOL)isUnread
//------------------------------------------------------------------------------------------------------------------------------
{
    if (isUnread) {
        _numOfUnreadConversations--;
        [_delegate inboxAllViewController:self didRetrieveNumOfUnreadConversations:_numOfUnreadConversations];
    }
}


#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) categorySegmentedControlSelectedIndexChange
//------------------------------------------------------------------------------------------------------------------------------
{
    [self updateCategorizedMessages];
    
    [_inboxTableView reloadData];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateCategorizedMessages
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_categorySegmentedControl.selectedSegmentIndex == 0)
    {
        // Display all messages
        _categorizedMessages = [NSMutableArray arrayWithArray:_recentMessages];
    }
    else if (_categorySegmentedControl.selectedSegmentIndex == 1)
    {
        // Display messages that acted as a seller
        _categorizedMessages = [NSMutableArray array];
        
        for (NSDictionary *recent in _recentMessages) {
            if ([[PFUser currentUser].objectId isEqualToString:recent[FB_ITEM_SELLER_ID]])
                [_categorizedMessages addObject:recent];
        }
    }
    else if (_categorySegmentedControl.selectedSegmentIndex == 2)
    {
        // Display message that acted as a buyer
        _categorizedMessages = [NSMutableArray array];
        
        for (NSDictionary *recent in _recentMessages)
        {
            if ([[PFUser currentUser].objectId isEqualToString:recent[FB_ITEM_BUYER_ID]])
                [_categorizedMessages addObject:recent];
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) openItemDetailsViewController: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *itemID = notification.object;
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_OBJECT_ID equalTo:itemID];
    
    WhuntsHandler succHandler = ^(NSArray *whunts)
    {
        if (whunts.count == 1)
        {
            ItemDetailsViewController *itemDetailsVC = [[ItemDetailsViewController alloc] init];
            itemDetailsVC.wantData = whunts[0];
            itemDetailsVC.itemImagesNum = itemDetailsVC.wantData.itemPicturesNum;
            itemDetailsVC.bottomButtonsNotNeeded = YES;
            
            TransactionHandler tranHandler = ^(TransactionData *offer)
            {
                if (offer)
                {
                    itemDetailsVC.currOffer = offer;
                }
                
                [self.navigationController pushViewController:itemDetailsVC animated:YES];
                [Utilities hideIndeterminateProgressIndicatorInView:self.view];
            };
            
            [MarketplaceBackend retrieveOfferByUser:[PFUser currentUser].objectId forItem:itemDetailsVC.wantData.itemID completionHandler:tranHandler];
        }
    };
    
    FailureHandler failHandler = ^(NSError *error)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        [Utilities displayErrorAlertView];
    };
    
    [MarketplaceBackend retrieveWhuntsWithQuery:query successHandler:succHandler failureHandler:failHandler];
    
    
}

/*
 * Open ChatView of a conversation
 */
 
//------------------------------------------------------------------------------------------------------------------------------
- (void) navigateToChatConversation: (NSDictionary *) chatDict
//------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:chatDict[FB_GROUP_ID]];
    [chatView setUser2Username:chatDict[FB_OPPOSING_USER_USERNAME]];
    chatView.delegate = self;
    chatView.isUnread = [chatDict[FB_UNREAD_MESSAGES_COUNTER] integerValue] > 0;
    
    // re-create offerData from recent chat conversation
    TransactionData *offerData      =   [[TransactionData alloc] init];
    offerData.objectID              =   chatDict[FB_CURRENT_OFFER_ID];
    offerData.itemID                =   chatDict[FB_ITEM_ID];
    offerData.itemName              =   chatDict[FB_ITEM_NAME];
    offerData.sellerID              =   [(NSArray *) chatDict[FB_GROUP_MEMBERS] objectAtIndex:0];
    offerData.buyerID               =   [(NSArray *) chatDict[FB_GROUP_MEMBERS] objectAtIndex:1];
    offerData.initiatorID           =   chatDict[FB_TRANSACTION_LAST_USER];
    offerData.originalDemandedPrice =   chatDict[FB_ORIGINAL_DEMANDED_PRICE];
    offerData.offeredPrice          =   chatDict[FB_CURRENT_OFFERED_PRICE];
    offerData.deliveryTime          =   chatDict[FB_CURRENT_OFFERED_DELIVERY_TIME];
    offerData.transactionStatus     =   chatDict[FB_TRANSACTION_STATUS];
    
    [chatView setOfferData:offerData];
    
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}


#pragma mark - Puclic methods

/*
 * Called when user enters app by swiping notification from log screen
 * 1. switch to "All" tab to show all chat conversations  2. find chat conversation with groupID  3. Navigate to the appropriate
 * chat conversation
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) openChatConversationWithGroupID:(NSString *)groupID
//------------------------------------------------------------------------------------------------------------------------------
{
    // switch to "All" tab
    [_categorySegmentedControl setSelectedSegmentIndex:0];
    _categorizedMessages = [NSMutableArray arrayWithArray:_recentMessages];
    
    // find chat conversation
    NSDictionary *targetedChatDict;
    for (int i=0; i<_categorizedMessages.count; i++)
    {
        NSDictionary *chatDict = [_categorizedMessages objectAtIndex:i];
        if ([[chatDict objectForKey:FB_GROUP_ID] isEqualToString:groupID])
            targetedChatDict = chatDict;
    }
    
    if (targetedChatDict)
        [self navigateToChatConversation:targetedChatDict];
}


/*
 * Display user's profile.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) usernameButtonTapEventHandler: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewUserProfileEvent" label:@"BuyerUsernameButton" value:nil];
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    UserHandler handler = ^(PFUser *user)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    NSString *userID = notification.object;
    [Utilities retrieveUserInfoByUserID:userID andRunBlock:handler];
}

@end
