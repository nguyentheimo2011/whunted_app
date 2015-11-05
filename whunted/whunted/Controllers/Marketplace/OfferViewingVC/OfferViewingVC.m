//
//  OfferViewingVC.m
//  whunted
//
//  Created by thomas nguyen on 7/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "OfferViewingVC.h"
#import "MessageViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "converter.h"

#import <Firebase/Firebase.h>

#define     kControlContainerHeight         60.0f

@implementation OfferViewingVC
{
    UITableView             *_offersTableView;
    
    Firebase                *_firebase;
    
    NSMutableArray          *_recentTransactionalMessages;
}

@synthesize itemImage    =   _itemImage;
@synthesize wantData     =   _wantData;


//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil)
    {
        self.hidesBottomBarWhenPushed = YES;
        
        _recentTransactionalMessages = [NSMutableArray array];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self addItemInfoUI];
    [self addOffersTableView];
    
    [self loadRecents];
    
    [_offersTableView registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"MessageViewCell"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"ViewingOfferScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Offers", nil) forViewController:self];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemInfoUI
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kContainerYPos    =   [Utilities getHeightOfNavigationAndStatusBars:self];
    UIView *itemInfoContainer       =   [[UIView alloc] initWithFrame:CGRectMake(0, kContainerYPos, WINSIZE.width, kControlContainerHeight)];
    itemInfoContainer.backgroundColor   =   [UIColor whiteColor];
    [self.view addSubview:itemInfoContainer];
    
    [self addItemImageView:itemInfoContainer];
    [self addItemNameLabel:itemInfoContainer];
    [self addItemPriceLabel:itemInfoContainer];
    
    CGFloat const kSeparatorLineLeftMargin  =   15.0f;
    CGFloat const kSeparatorLineHeight      =   0.5f;
    CGFloat const kSeparatorLineWidth       =   WINSIZE.width - kSeparatorLineLeftMargin;
    CGFloat const kSeparatorLineYPos        =   kControlContainerHeight - kSeparatorLineHeight;
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kSeparatorLineLeftMargin, kSeparatorLineYPos, kSeparatorLineWidth, kSeparatorLineHeight)];
    separatorLine.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_5;
    [itemInfoContainer addSubview:separatorLine];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView: (UIView *) viewContainer
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewOriginX     =   15.0f;
    CGFloat const kImageViewOriginY     =   5.0f;
    CGFloat const kImageViewWidth       =   50.0f;
    CGFloat const kImageViewHeight      =   50.0f;
    
    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    itemImageView.image = _itemImage;
    itemImageView.layer.cornerRadius = 5.0f;
    itemImageView.clipsToBounds = YES;
    [viewContainer addSubview:itemImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel: (UIView *) viewContainer
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX     =   75.0f;
    CGFloat const kLabelOriginY     =   8.0f;
    CGFloat const kLabelWidth       =   WINSIZE.width - kLabelOriginX - 30.0f;
    CGFloat const kLabelHeight      =   20.0f;
    
    UILabel *itemNameLabel  =   [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    itemNameLabel.text = _wantData.itemName;
    itemNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    itemNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [viewContainer addSubview:itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemPriceLabel: (UIView *) viewContainer
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX     =   75.0f;
    CGFloat const kLabelOriginY     =   30.0f;
    CGFloat const kLabelWidth       =   WINSIZE.width - kLabelOriginX - 30.0f;
    CGFloat const kLabelHeight      =   20.0f;
    
    UILabel *itemPriceLabel =   [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    itemPriceLabel.text = _wantData.demandedPrice;
    itemPriceLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    itemPriceLabel.textColor = TEXT_COLOR_GRAY;
    [viewContainer addSubview:itemPriceLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOffersTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableHeight  =  WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self] - kControlContainerHeight;
    CGFloat const kTableYPos    =  kControlContainerHeight + [Utilities getHeightOfNavigationAndStatusBars:self];
    
    _offersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableYPos, WINSIZE.width, kTableHeight)];
    _offersTableView.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
    _offersTableView.delegate = self;
    _offersTableView.dataSource = self;
    [self.view addSubview:_offersTableView];
}


#pragma mark - UITableView Datasource Delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return [_recentTransactionalMessages count];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *cellIdentifier = @"MessageViewCell";
    MessageViewCell *cell = (MessageViewCell *) [_offersTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell initCell];
    [cell bindData:_recentTransactionalMessages[indexPath.row]];
    
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
    [_offersTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *recent    =   _recentTransactionalMessages[indexPath.row];
    ChatView *chatView      =   [[ChatView alloc] initWith:recent[FB_GROUP_ID]];
    chatView.user2Username  =   recent[FB_OPPOSING_USER_USERNAME];
    chatView.isUnread       =   [recent[FB_UNREAD_MESSAGES_COUNTER] integerValue] > 0;
    
    TransactionData *offerData      =   [[TransactionData alloc] init];
    offerData.objectID              =   recent[FB_CURRENT_OFFER_ID];
    offerData.itemID                =   recent[FB_ITEM_ID];
    offerData.itemName              =   recent[FB_ITEM_NAME];
    offerData.sellerID              =   [(NSArray *) recent[FB_GROUP_MEMBERS] objectAtIndex:0];
    offerData.buyerID               =   [(NSArray *) recent[FB_GROUP_MEMBERS] objectAtIndex:1];
    offerData.initiatorID           =   recent[FB_TRANSACTION_LAST_USER];
    offerData.originalDemandedPrice =   recent[FB_ORIGINAL_DEMANDED_PRICE];
    offerData.offeredPrice          =   recent[FB_CURRENT_OFFERED_PRICE];
    offerData.deliveryTime          =   recent[FB_CURRENT_OFFERED_DELIVERY_TIME];
    offerData.transactionStatus     =   recent[FB_TRANSACTION_STATUS];
    
    [chatView setOfferData:offerData];
    
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}


#pragma mark - Backend methods

//------------------------------------------------------------------------------------------------------------------------------
- (void)loadRecents
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user = [PFUser currentUser];
    if ((user != nil) && (_firebase == nil))
    {
        [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
        
        _firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
        FQuery *query = [[_firebase queryOrderedByChild:FB_ITEM_ID] queryEqualToValue:_wantData.itemID];
        [query observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
         {
             [_recentTransactionalMessages removeAllObjects];
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
                     if ([recent[FB_SELF_USER_ID] isEqualToString:user.objectId])
                     {
                         // if the want is fulfilled, then display only 1 seller
                         if (_wantData.isFulfilled && [recent[FB_TRANSACTION_STATUS] isEqualToString:TRANSACTION_STATUS_ACCEPTED])
                         {
                             [_recentTransactionalMessages addObject:recent];
                         }
                         else if (!_wantData.isFulfilled && [recent[FB_TRANSACTION_STATUS] isEqualToString:TRANSACTION_STATUS_ONGOING])
                         {
                             [_recentTransactionalMessages addObject:recent];
                         }
                     }
                     
                 }
             }
             
             [_offersTableView reloadData];
             [Utilities hideIndeterminateProgressIndicatorInView:self.view];
         }];
    }
}


@end

