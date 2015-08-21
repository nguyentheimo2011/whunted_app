//
//  InboxAllViewController.m
//  whunted
//
//  Created by thomas nguyen on 17/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "InboxAllViewController.h"
#import "MessageViewCell.h"
#import "ChatView.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "converter.h"
#import <Firebase/Firebase.h>
#import <MBProgressHUD.h>

@interface InboxAllViewController ()

@property (nonatomic, strong) UITableView       *_inboxTableView;
@property (nonatomic, strong) Firebase          *_firebase;
@property (nonatomic, strong) NSMutableArray    *_recentMessages;

@end

@implementation InboxAllViewController

@synthesize _inboxTableView;
@synthesize _firebase;
@synthesize _recentMessages;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        [self addInboxTableView];
        _recentMessages = [NSMutableArray array];
        [self loadRecents];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Inbox", nil) forViewController:self];
    
    [_inboxTableView registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"MessageViewCell"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addInboxTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    _inboxTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
                 for (NSDictionary *recent in sorted)
                 {
                     [_recentMessages addObject:recent];
                 }
             }
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

@end
