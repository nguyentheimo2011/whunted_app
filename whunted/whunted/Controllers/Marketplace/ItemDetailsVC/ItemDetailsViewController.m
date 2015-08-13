//
//  ItemDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 2/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemDetailsViewController.h"
#import "ItemImageViewController.h"
#import "ChatView.h"
#import "recent.h"
#import "PersistedCache.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <MBProgressHUD.h>
#import <JTImageButton.h>

@implementation ItemDetailsViewController
{
    UIPageViewController    *_pageViewController;
    
    UILabel                 *_itemNameLabel;
    UILabel                 *_postedTimestampLabel;
    JTImageButton           *_buyerUsernameButton;
    UILabel                 *_demandedPriceLabel;
    UILabel                 *_locationLabel;
    UILabel                 *_itemDescLabel;
    UILabel                 *_productOriginLabel;
    UILabel                 *_paymentMethodLabel;
    UILabel                 *_sellersLabel;
    JTImageButton           *_secondBottomButton;
    
    UIPageControl           *_pageControl;
    UIScrollView            *_scrollView;
    
    NSMutableArray          *_itemImageList;
    CGFloat                 _nextXPos;
    CGFloat                 _nextYPos;
    NSInteger               _currImageIndex;
}

@synthesize wantData                =   _wantData;
@synthesize itemImagesNum           =   _itemImagesNum;
@synthesize currOffer               =   _currOffer;
@synthesize delegate                =   _delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        [self customizeUI];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self addScrollView];
    [self addPageViewController];
    [self addItemDetails];
    [self addFunctionalButtons];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"ItemDetailsViewController didReceiveMemoryWarning");
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    [self retrieveItemImages];
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.hidesBottomBarWhenPushed = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height)];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_scrollView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPageViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.dataSource = self;
    _pageViewController.view.frame = CGRectMake(0, 0, WINSIZE.width, WINSIZE.width);
    
    ItemImageViewController *itemImageVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [_scrollView addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    [self addPageControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPageControl
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kPageControlWidth         =   80.0f;
    CGFloat const kPageControlHeight        =   30.0f;
    CGFloat const kPageControlLeftMargin    =   (WINSIZE.width - kPageControlWidth) / 2;
    CGFloat const kPageControlTopMargin     =   WINSIZE.width - 45.0f;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kPageControlLeftMargin, kPageControlTopMargin, kPageControlWidth, kPageControlHeight)];
    _pageControl.numberOfPages = 1;
    _pageControl.currentPage = 0;
    [_scrollView addSubview:_pageControl];
    [_scrollView bringSubviewToFront:_pageControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemDetails
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addItemNameLabel];
    [self addPostedTimestampLabel];
    [self addBuyerUsernameButton];
    [self addDemandedPriceLabel];
    [self addLocationLabel];
    [self addItemDescLabel];
    [self addProductOrigin];
    [self addPaymentMethodLabel];
    [self addSellersLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addFunctionalButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    [self addChatButton];
    [self addOfferButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kNameLabelLeftMargin  =   10.0f;
    CGFloat const kNameLabelTopMargin   =   10.0f;
    CGFloat const kNameLabelYPos        =   WINSIZE.width + kNameLabelTopMargin;
    CGFloat const kNameLabelWidth       =   WINSIZE.width - 2 * kNameLabelLeftMargin;
    CGFloat const kNameLabelHeight      =   20.0f;
    
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNameLabelLeftMargin, kNameLabelYPos, kNameLabelWidth, kNameLabelHeight)];
    [_itemNameLabel setText:_wantData.itemName];
    [_itemNameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]];
    [_itemNameLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_scrollView addSubview:_itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPostedTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *timestamp = [Utilities longTimestampStringFromDate:_wantData.createdDate];
    NSString *postedTimestampText = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"listed", nil), timestamp, NSLocalizedString(@"by", nil)];
    
    CGFloat const kLabelLeftMargin  =   10.0f;
    CGFloat const kLabelYPos        =   _itemNameLabel.frame.origin.y + _itemNameLabel.frame.size.height;
    
    _postedTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelYPos, 0, 0)];
    [_postedTimestampLabel setText:postedTimestampText];
    [_postedTimestampLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [_postedTimestampLabel setTextColor:TEXT_COLOR_GRAY];
    [_postedTimestampLabel sizeToFit];
    [_scrollView addSubview:_postedTimestampLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerUsernameButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonLeftMargin =   3.0f;
    CGFloat const kButtonXPos       =   _postedTimestampLabel.frame.origin.x + _postedTimestampLabel.frame.size.width + kButtonLeftMargin;
    CGFloat const kButtonYPos       =   _postedTimestampLabel.frame.origin.y;
    CGFloat const kButtonWidth      =   WINSIZE.width - 20.0f - kButtonXPos;
    CGFloat const kButtonHeight     =   _postedTimestampLabel.frame.size.height;
    
    _buyerUsernameButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonYPos, kButtonWidth, kButtonHeight)];
    [_buyerUsernameButton createTitle:_wantData.buyerUsername withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    _buyerUsernameButton.borderColor = [UIColor clearColor];
    _buyerUsernameButton.cornerRadius = 0;
    _buyerUsernameButton.titleColor = MAIN_BLUE_COLOR;
    _buyerUsernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_scrollView addSubview:_buyerUsernameButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDemandedPriceLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kPriceImageLeftMargin     =   10.0f;
    CGFloat const kPriceImageTopMargin      =   15.0f;
    CGFloat const kPriceImageYPos           =   _postedTimestampLabel.frame.origin.y + _postedTimestampLabel.frame.size.height + kPriceImageTopMargin;
    CGFloat const kPriceImageWidth          =   23.0f;
    
    UIImage *priceTagImage = [UIImage imageNamed:@"pricetag_icon.png"];
    UIImageView *priceTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPriceImageLeftMargin, kPriceImageYPos, kPriceImageWidth, kPriceImageWidth)];
    [priceTagImageView setImage:priceTagImage];
    [_scrollView addSubview:priceTagImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kPriceImageLeftMargin + kPriceImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    
    _demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kPriceImageYPos, kLabelWidth, kPriceImageWidth)];
    [_demandedPriceLabel setText:_wantData.demandedPrice];
    [_demandedPriceLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_demandedPriceLabel setTextColor:TEXT_COLOR_GRAY];
    [_scrollView addSubview:_demandedPriceLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLocationLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLocationImageLeftMargin     =   10.0f;
    CGFloat const kLocationImageTopMargin      =   15.0f;
    CGFloat const kLocationImageYPos           =   _demandedPriceLabel.frame.origin.y + _demandedPriceLabel.frame.size.height + kLocationImageTopMargin;
    CGFloat const kLocationImageWidth          =   23.0f;
    
    UIImage *locationImage = [UIImage imageNamed:@"location_icon.png"];
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLocationImageLeftMargin, kLocationImageYPos, kLocationImageWidth, kLocationImageWidth)];
    [locationImageView setImage:locationImage];
    [_scrollView addSubview:locationImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kLocationImageLeftMargin + kLocationImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLocationImageYPos, kLabelWidth, kLocationImageWidth)];
    [_locationLabel setText:_wantData.meetingLocation];
    [_locationLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_locationLabel setTextColor:TEXT_COLOR_GRAY];
    [_scrollView addSubview:_locationLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemDescLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kDescImageLeftMargin     =   10.0f;
    CGFloat const kDescImageTopMargin      =   15.0f;
    CGFloat const kDescImageYPos           =   _locationLabel.frame.origin.y + _locationLabel.frame.size.height + kDescImageTopMargin;
    CGFloat const kDescImageWidth          =   23.0f;
    
    UIImage *descriptionImage = [UIImage imageNamed:@"info_icon.png"];
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDescImageLeftMargin, kDescImageYPos, kDescImageWidth, kDescImageWidth)];
    [descriptionImageView setImage:descriptionImage];
    [_scrollView addSubview:descriptionImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kDescImageLeftMargin + kDescImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    CGSize expectedSize = [_wantData.itemDesc sizeWithAttributes:@{NSFontAttributeName: DEFAULT_FONT}];
    
    _itemDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kDescImageYPos, kLabelWidth, expectedSize.height)];
    [_itemDescLabel setText:_wantData.itemDesc];
    [_itemDescLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_itemDescLabel setTextColor:TEXT_COLOR_GRAY];
    _itemDescLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _itemDescLabel.numberOfLines = 0;
    [_scrollView addSubview:_itemDescLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addProductOrigin
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *originIconImage = [UIImage imageNamed:@"product_origin_icon.png"];
    UIImageView *originIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, 23, 23)];
    [originIconImageView setImage:originIconImage];
    [_scrollView addSubview:originIconImageView];
    
    _nextXPos = 40;
    _nextYPos += 3;
    
    NSString *productOriginText = [_wantData.productOriginList componentsJoinedByString:@", "];
    CGSize expectedSize = [productOriginText sizeWithAttributes:@{NSFontAttributeName: DEFAULT_FONT}];
    _productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, expectedSize.height)];
    [_productOriginLabel setText:productOriginText];
    [_productOriginLabel setFont:DEFAULT_FONT];
    [_productOriginLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:_productOriginLabel];
    
    _nextXPos = 10;
    _nextYPos += expectedSize.height + 30;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPaymentMethodLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *paymentMethodIconImage = [UIImage imageNamed:@"payment_method_icon.png"];
    UIImageView *paymentMethodIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, 23, 23)];
    [paymentMethodIconImageView setImage:paymentMethodIconImage];
    [_scrollView addSubview:paymentMethodIconImageView];
    
    _nextXPos = 40;
    _nextYPos += 3;
    
    NSString *paymentMethodText;
    if ([_wantData.paymentMethod isEqualToString:ESCROW_PAYMENT_METHOD]) {
        paymentMethodText = @"Request for Escrow";
    } else {
        paymentMethodText = @"Not request for Escrow";
    }
    _paymentMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, 20)];
    [_paymentMethodLabel setText:paymentMethodText];
    [_paymentMethodLabel setFont:DEFAULT_FONT];
    [_paymentMethodLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:_paymentMethodLabel];
    
    _nextXPos = 10;
    _nextYPos += 35;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSellersLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *sellersIconImage = [UIImage imageNamed:@"sellers_icon"];
    UIImageView *sellersIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, 23, 23)];
    [sellersIconImageView setImage:sellersIconImage];
    [_scrollView addSubview:sellersIconImageView];
    
    _nextXPos = 40;
    _nextYPos += 3;
    
    NSString *sellersText = @"2 sellers";
    _sellersLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, 20)];
    [_sellersLabel setText:sellersText];
    [_sellersLabel setFont:DEFAULT_FONT];
    [_sellersLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:_sellersLabel];
    
    _nextYPos += 25;
    
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, _nextYPos += 60)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addChatButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, WINSIZE.height - 45, WINSIZE.width/2, 45)];
    [backgroundView setBackgroundColor:LIGHTEST_GRAY_COLOR];
    [self.view addSubview:backgroundView];
    
    JTImageButton *chatButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/2, 45)];
    [chatButton createTitle:NSLocalizedString(@"Chat", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconHeight:0 iconOffsetY:0];
    chatButton.cornerRadius = 0;
    chatButton.borderColor = [UIColor grayColor];
    chatButton.bgColor = [UIColor grayColor];
    chatButton.titleColor = [UIColor whiteColor];
    [chatButton addTarget:self action:@selector(chatButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:chatButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/2, WINSIZE.height - 45, WINSIZE.width/2, 45)];
    [backgroundView setBackgroundColor:LIGHTEST_GRAY_COLOR];
    [self.view addSubview:backgroundView];
    
    PFUser *curUser = [PFUser currentUser];
    _secondBottomButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/2, 45)];
    _secondBottomButton.borderColor = [UIColor colorWithRed:99.0/255 green:184.0/255 blue:1.0 alpha:1.0];
    _secondBottomButton.bgColor = [UIColor colorWithRed:99.0/255 green:184.0/255 blue:1.0 alpha:1.0];
    _secondBottomButton.titleColor = [UIColor whiteColor];
    
    if ([_wantData.buyerID isEqualToString:curUser.objectId]) {
        [_secondBottomButton createTitle:NSLocalizedString(@"Promote your post", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconOffsetY:0];
        _secondBottomButton.cornerRadius = 0;
        [backgroundView addSubview:_secondBottomButton];
    } else {
        if (_currOffer)
            [_secondBottomButton createTitle:NSLocalizedString(@"Change your offer", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconOffsetY:0];
        else
            [_secondBottomButton createTitle:NSLocalizedString(@"Offer your price", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconOffsetY:0];
        
        [_secondBottomButton addTarget:self action:@selector(sellerOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
        _secondBottomButton.cornerRadius = 0;
        [backgroundView addSubview:_secondBottomButton];
    }
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) sellerOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = _wantData.buyerID;
    [user2 fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if (!error) {
            BuyersOrSellersOfferViewController *sellersOfferVC = [[BuyersOrSellersOfferViewController alloc] init];
            sellersOfferVC.delegate = self;
            sellersOfferVC.buyerName = user2[PF_USER_USERNAME];
            sellersOfferVC.user2 = user2;
            if (_currOffer) {
                sellersOfferVC.offerData = _currOffer;
            } else {
                OfferData *offerData = [[OfferData alloc] init];
                offerData.itemID = _wantData.itemID;
                offerData.itemName = _wantData.itemName;
                offerData.originalDemandedPrice = _wantData.demandedPrice;
                offerData.buyerID = user2.objectId;
                offerData.sellerID = user1.objectId;
                offerData.initiatorID = @"";
                offerData.offeredPrice = @"";
                offerData.deliveryTime = @"";
                offerData.offerStatus = PF_OFFER_STATUS_NOT_OFFERED;
                sellersOfferVC.offerData = offerData;
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.navigationController pushViewController:sellersOfferVC animated:YES];
        } else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) chatButtonClickedEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = _wantData.buyerID;
    [user2 fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if (!error) {
            [[PersistedCache sharedCache] setImage:[_itemImageList objectAtIndex:0] forKey:_wantData.itemID];
            
            if (_currOffer) {
                NSString *groupId = StartPrivateChat(user1, user2, _currOffer);
                [self actionChat:groupId withUser2:user2 andOfferData:_currOffer];
            } else {
                OfferData *offerData = [[OfferData alloc] init];
                offerData.itemID = _wantData.itemID;
                offerData.itemName = _wantData.itemName;
                offerData.originalDemandedPrice = _wantData.demandedPrice;
                offerData.buyerID = user2.objectId;
                offerData.sellerID = user1.objectId;
                offerData.initiatorID = @"";
                offerData.offeredPrice = @"";
                offerData.deliveryTime = @"";
                offerData.offerStatus = PF_OFFER_STATUS_NOT_OFFERED;
                
                NSString *groupId = StartPrivateChat(user1, user2, offerData);
                [self actionChat:groupId withUser2:user2 andOfferData:offerData];
            }
        } else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)actionChat:(NSString *)groupId withUser2: (PFUser *) user2 andOfferData: (OfferData *) offerData
//------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    [chatView setUser2Username:user2[PF_USER_USERNAME]];
    [chatView setOfferData:offerData];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark - Data Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveItemImages
//------------------------------------------------------------------------------------------------------------------------------
{    
    _itemImageList = [[NSMutableArray alloc] init];
    PFRelation *picRelation = _wantData.itemPictureList;
    
    [[picRelation query] findObjectsInBackgroundWithBlock:^(NSArray *pfObjList, NSError *error ) {
        for (PFObject *pfObj in pfObjList) {
            PFFile *imageFile = pfObj[@"itemPicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [_itemImageList addObject:image];
                ItemImageViewController *itemImageVC = [self viewControllerAtIndex:_currImageIndex];
                NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
                [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }];
        }
        
        _pageControl.numberOfPages = [pfObjList count];
    }];
}


#pragma mark - PageViewControllerDatasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    
    _pageControl.currentPage = index;
    
    if (index == 0)
        return nil;
    else
        return [self viewControllerAtIndex:index-1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    
    _pageControl.currentPage = index;
    
    if (index == _itemImagesNum-1)
        return nil;
    else
        return [self viewControllerAtIndex:index+1];
}


#pragma mark - SellersOfferViewController delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) buyersOrSellersOfferViewController:(BuyersOrSellersOfferViewController *)controller didOffer:(OfferData *)offer
//------------------------------------------------------------------------------------------------------------------------------
{
    _currOffer = offer;
    [_secondBottomButton setTitle:NSLocalizedString(@"Change your offer", nil) forState:UIControlStateNormal];
    
    NSString *id1 = [PFUser currentUser].objectId;
    NSString *id2 = _wantData.buyerID;
    NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", offer.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", offer.itemID, id2, id1];
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    [chatView setUser2Username:_wantData.buyerUsername];
    [chatView setOfferData:offer];
    NSString *message = [NSString stringWithFormat:@"Made An Offer\n  %@  \nDeliver in %@", offer.offeredPrice, offer.deliveryTime];
    [chatView messageSend:message Video:nil Picture:nil Audio:nil];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}


#pragma mark - Helpers

//------------------------------------------------------------------------------------------------------------------------------
- (ItemImageViewController *) viewControllerAtIndex: (NSInteger) index
//------------------------------------------------------------------------------------------------------------------------------
{
    ItemImageViewController *itemImageVC = [[ItemImageViewController alloc] init];
    itemImageVC.index = index;
    _currImageIndex = index;
    if (index < [_itemImageList count]) {
        [itemImageVC.itemImageView setImage:[_itemImageList objectAtIndex:index]];
    }
    
    return itemImageVC;
}

@end
