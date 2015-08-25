//
//  InboxAllViewController.m
//  whunted
//
//  Created by thomas nguyen on 17/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "InboxAllViewController.h"
#import "MessageViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "converter.h"
#import <Firebase/Firebase.h>
#import <MBProgressHUD.h>

#define     kControlContainerHeight         60.0f

@implementation InboxAllViewController
{
    UITableView             *_inboxTableView;
    Firebase                *_firebase;
    
    UISegmentedControl      *_categorySegmentedControl;
    
    NSMutableArray          *_recentMessages;
}

@synthesize delegate                    =   _delegate;
@synthesize numOfUnreadConversations    =   _numOfUnreadConversations;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        _recentMessages = [NSMutableArray array];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Inbox", nil) forViewController:self];
    
    [self addSegmentedControl];
    [self addInboxTableView];

    [self loadRecents];
    
    [_inboxTableView registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"MessageViewCell"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kContainerYPos = [Utilities getHeightOfNavigationAndStatusBars:self];
    UIView *segmentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kContainerYPos, WINSIZE.width, kControlContainerHeight)];
    [segmentContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:segmentContainer];
    
    CGFloat const kControlTopMargin = 15.0f;
    CGFloat const kControlLeftMargin = 30.0f;
    CGFloat const kControlHeight = kControlContainerHeight - 2 * kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width - 2 * kControlLeftMargin;
    
    NSArray *categories = @[NSLocalizedString(@"All", nil), NSLocalizedString(@"As Seller", nil), NSLocalizedString(@"As Buyer", nil)];
    _categorySegmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    _categorySegmentedControl.frame = CGRectMake(kControlLeftMargin, kControlTopMargin, kControlWidth, kControlHeight);
    _categorySegmentedControl.tintColor = MAIN_BLUE_COLOR;
    [_categorySegmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE]} forState:UIControlStateNormal];
    _categorySegmentedControl.selectedSegmentIndex = 0;
    [_categorySegmentedControl addTarget:self action:@selector(categorySegmentedControlSelectedIndexChange) forControlEvents:UIControlEventValueChanged];
    [segmentContainer addSubview:_categorySegmentedControl];
    
    CGFloat const kSeparatorLineLeftMargin = 15.0f;
    CGFloat const kSeparatorLineHeight = 0.75f;
    CGFloat const kSeparatorLineWidth = WINSIZE.width - kSeparatorLineLeftMargin;
    CGFloat const kSeparatorLineYPos = kControlContainerHeight - kSeparatorLineHeight;
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kSeparatorLineLeftMargin, kSeparatorLineYPos, kSeparatorLineWidth, kSeparatorLineHeight)];
    [separatorLine setBackgroundColor:CELL_SEPARATOR_GRAY_COLOR];
    [segmentContainer addSubview:separatorLine];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addInboxTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableHeight = WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self] - [Utilities getHeightOfBottomTabBar:self] - kControlContainerHeight;
    
    CGFloat const kTableYPos = kControlContainerHeight + [Utilities getHeightOfNavigationAndStatusBars:self];
    
    _inboxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableYPos, WINSIZE.width, kTableHeight)];
    [_inboxTableView setBackgroundColor:LIGHTEST_GRAY_COLOR];
    _inboxTableView.delegate = self;
    _inboxTableView.dataSource = self;
    [self.view addSubview:_inboxTableView];
}

#pragma mark - Backend methods
//------------------------------------------------------------------------------------------------------------------------------
- (void)loadRecents
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user = [PFUser currentUser];
    if ((user != nil) && (_firebase == nil))
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
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
             }
             
             [_delegate inboxAllViewController:self didRetrieveNumOfUnreadConversations:_numOfUnreadConversations];
             
             [_inboxTableView reloadData];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }
}


#pragma mark - UITableView Datasource Delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_recentMessages count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellIdentifier = @"MessageViewCell";
    MessageViewCell *cell = (MessageViewCell *) [_inboxTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell customizeUI];
    [cell bindData:_recentMessages[indexPath.row]];
    
    return cell;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    return 116.0;
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
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    [_inboxTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *recent = _recentMessages[indexPath.row];
    ChatView *chatView = [[ChatView alloc] initWith:recent[FB_GROUP_ID]];
    [chatView setUser2Username:recent[FB_OPPOSING_USER_USERNAME]];
    chatView.delegate = self;
    
    OfferData *offerData            =   [[OfferData alloc] init];
    offerData.objectID              =   recent[FB_CURRENT_OFFER_ID];
    offerData.itemID                =   recent[FB_ITEM_ID];
    offerData.itemName              =   recent[FB_ITEM_NAME];
    offerData.sellerID              =   [(NSArray *) recent[FB_GROUP_MEMBERS] objectAtIndex:0];
    offerData.buyerID               =   [(NSArray *) recent[FB_GROUP_MEMBERS] objectAtIndex:1];
    offerData.initiatorID           =   recent[FB_TRANSACTION_LAST_USER];
    offerData.originalDemandedPrice =   recent[FB_ORIGINAL_DEMANDED_PRICE];
    offerData.offeredPrice          =   recent[FB_CURRENT_OFFERED_PRICE];
    offerData.deliveryTime          =   recent[FB_CURRENT_OFFERED_DELIVERY_TIME];
    offerData.offerStatus           =   recent[FB_TRANSACTION_STATUS];
    
    [chatView setOfferData:offerData];
    
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}


#pragma mark - ChatViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) chatViewDidSeeAConversation:(ChatView *)chatView
//------------------------------------------------------------------------------------------------------------------------------
{
    _numOfUnreadConversations--;
    [_delegate inboxAllViewController:self didRetrieveNumOfUnreadConversations:_numOfUnreadConversations];
}


#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) categorySegmentedControlSelectedIndexChange
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

@end
