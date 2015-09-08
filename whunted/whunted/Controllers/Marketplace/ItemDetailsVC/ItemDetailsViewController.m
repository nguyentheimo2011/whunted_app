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
#import "UserProfileViewController.h"
#import "OfferViewingVC.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <MBProgressHUD.h>
#import <JTImageButton.h>

@implementation ItemDetailsViewController
{
    UIPageViewController    *_pageViewController;
    
    UILabel                 *_itemNameLabel;
    UILabel                 *_postedTimestampLabel;
    UILabel                 *_demandedPriceLabel;
    UILabel                 *_locationLabel;
    UILabel                 *_itemDescLabel;
    UILabel                 *_productOriginLabel;
    UILabel                 *_paymentMethodLabel;
    UILabel                 *_sellersLabel;
    
    JTImageButton           *_buyerUsernameButton;
    JTImageButton           *_secondBottomButton;
    JTImageButton           *_viewOffersButton;
    
    UIPageControl           *_pageControl;
    UIScrollView            *_scrollView;
    
    NSString                *_secondBottomButtonTitle;
    
    NSMutableArray          *_itemImageList;
    CGFloat                 _nextXPos;
    CGFloat                 _nextYPos;
    NSInteger               _currImageIndex;
    
    BOOL                    _itemPostedByMe;
    
    NSInteger               _numOfOffers;
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
        [self hideBottomTabBar];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    [self customizeUI];
    [self addScrollView];
    [self addPageViewController];
    [self addItemDetails];
    [self addFunctionalButtons];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [self updateSecondBottomButtonTitle];
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
    _itemPostedByMe = [_wantData.buyerID isEqualToString:[PFUser currentUser].objectId];
    
    [self retrieveItemImages];
    [self retrieveItemOffers];
    
    [self addNotificationObserver];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addNotificationObserver
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionalData:) name:NOTIFICATION_NEW_OFFER_MADE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionalData:) name:NOTIFICATION_OFFER_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionalData:) name:NOTIFICATION_OFFER_DECLINED_BY_OTHER object:nil];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) hideBottomTabBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.hidesBottomBarWhenPushed = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
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
    [self addLineSeparator];
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
- (void) addLineSeparator
//------------------------------------------------------------------------------------------------------------------------------
{
    // add a line to separate item image view from item details
    CGFloat const kLineYPos     =   WINSIZE.width;
    CGFloat const kLineHeihgt   =   0.5f;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kLineYPos, WINSIZE.width, kLineHeihgt)];
    view.backgroundColor = LIGHT_GRAY_COLOR;
    [_scrollView addSubview:view];
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
//    [self addProductOrigin];
    [self addPaymentMethodLabel];
    [self addSellersLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addFunctionalButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_itemPostedByMe) {
        [self addViewOfferButton];
    } else {
        [self addChatButton];
        [self addOfferButton];
    }
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
    [_buyerUsernameButton addTarget:self action:@selector(buyerUsernameButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
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
    CGFloat const kOriginImageLeftMargin     =   10.0f;
    CGFloat const kOriginImageTopMargin      =   15.0f;
    CGFloat const kOriginImageYPos           =   _itemDescLabel.frame.origin.y + _itemDescLabel.frame.size.height + kOriginImageTopMargin;
    CGFloat const kOriginImageWidth          =   23.0f;
    
    UIImage *originIconImage = [UIImage imageNamed:@"product_origin_icon.png"];
    UIImageView *originIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kOriginImageLeftMargin, kOriginImageYPos, kOriginImageWidth, kOriginImageWidth)];
    [originIconImageView setImage:originIconImage];
    [_scrollView addSubview:originIconImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kOriginImageLeftMargin + kOriginImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    
    NSString *productOriginText = [_wantData.itemOrigins componentsJoinedByString:@", "];
    CGSize expectedSize = [productOriginText sizeWithAttributes:@{NSFontAttributeName: DEFAULT_FONT}];
    _productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kOriginImageYPos, kLabelWidth, expectedSize.height)];
    [_productOriginLabel setText:productOriginText];
    [_productOriginLabel setFont:DEFAULT_FONT];
    [_productOriginLabel setTextColor:TEXT_COLOR_GRAY];
    [_scrollView addSubview:_productOriginLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPaymentMethodLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kPaymentImageLeftMargin     =   10.0f;
    CGFloat const kPaymentImageTopMargin      =   15.0f;
    CGFloat const kPaymentImageYPos           =   _itemDescLabel.frame.origin.y + _itemDescLabel.frame.size.height + kPaymentImageTopMargin;
    CGFloat const kPaymentImageWidth          =   23.0f;
    
    UIImage *paymentMethodIconImage = [UIImage imageNamed:@"payment_method_icon.png"];
    UIImageView *paymentMethodIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaymentImageLeftMargin, kPaymentImageYPos, kPaymentImageWidth, kPaymentImageWidth)];
    [paymentMethodIconImageView setImage:paymentMethodIconImage];
    [_scrollView addSubview:paymentMethodIconImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kPaymentImageLeftMargin + kPaymentImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    
    NSString *paymentMethodText;
    if ([_wantData.paymentMethod isEqualToString:ESCROW_PAYMENT_METHOD]) {
        paymentMethodText = @"Request for Escrow";
    } else {
        paymentMethodText = @"Not request for Escrow";
    }
    _paymentMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kPaymentImageYPos, kLabelWidth, kPaymentImageWidth)];
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
    CGFloat const kSellerImageLeftMargin     =   10.0f;
    CGFloat const kSellerImageTopMargin      =   15.0f;
    CGFloat const kSellerImageYPos           =   _paymentMethodLabel.frame.origin.y + _paymentMethodLabel.frame.size.height + kSellerImageTopMargin;
    CGFloat const kSellerImageWidth          =   23.0f;
    
    UIImage *sellersIconImage = [UIImage imageNamed:@"sellers_icon"];
    UIImageView *sellersIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSellerImageLeftMargin, kSellerImageYPos, kSellerImageWidth, kSellerImageWidth)];
    [sellersIconImageView setImage:sellersIconImage];
    [_scrollView addSubview:sellersIconImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kSellerImageLeftMargin + kSellerImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    
    NSString *sellersText;
    if (_wantData.sellersNum <= 0)
        sellersText = [NSString stringWithFormat:@"%ld seller", _wantData.sellersNum];
    else
        sellersText = [NSString stringWithFormat:@"%ld seller", _wantData.sellersNum];
    
    _sellersLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kSellerImageYPos, kLabelWidth, kSellerImageWidth)];
    [_sellersLabel setText:sellersText];
    [_sellersLabel setFont:DEFAULT_FONT];
    [_sellersLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:_sellersLabel];
    
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, kSellerImageYPos + kSellerImageWidth + 60.0f)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addChatButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, WINSIZE.height - 45, WINSIZE.width/2, 45)];
    [backgroundView setBackgroundColor:[LIGHTEST_GRAY_COLOR colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    JTImageButton *chatButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/2, 45)];
    [chatButton createTitle:NSLocalizedString(@"Chat", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconHeight:0 iconOffsetY:0];
    chatButton.cornerRadius = 0;
    chatButton.borderColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
    chatButton.bgColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
    chatButton.titleColor = [UIColor whiteColor];
    [chatButton addTarget:self action:@selector(chatButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:chatButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/2, WINSIZE.height - 45, WINSIZE.width/2, 45)];
    [backgroundView setBackgroundColor:[LIGHTEST_GRAY_COLOR colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    _secondBottomButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/2, 45)];
    _secondBottomButton.borderColor = [PERSIAN_GREEN_COLOR colorWithAlphaComponent:0.9f];
    _secondBottomButton.bgColor = [PERSIAN_GREEN_COLOR colorWithAlphaComponent:0.9f];
    _secondBottomButton.titleColor = [UIColor whiteColor];
    
    if (_currOffer)
    {
        _secondBottomButtonTitle = NSLocalizedString(@"Change your offer", nil);
        [_secondBottomButton createTitle:_secondBottomButtonTitle withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconOffsetY:0];
    }
    else
    {
        _secondBottomButtonTitle = NSLocalizedString(@"Offer your price", nil);
        [_secondBottomButton createTitle:_secondBottomButtonTitle withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconOffsetY:0];
    }
    
    [_secondBottomButton addTarget:self action:@selector(sellerOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    _secondBottomButton.cornerRadius = 0;
    [backgroundView addSubview:_secondBottomButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addViewOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, WINSIZE.height - 45, WINSIZE.width, 45)];
    [backgroundView setBackgroundColor:[LIGHTEST_GRAY_COLOR colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    _viewOffersButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 45)];
    [_viewOffersButton createTitle:NSLocalizedString(@"View Offer", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:16] iconHeight:0 iconOffsetY:0];
    _viewOffersButton.cornerRadius = 0;
    _viewOffersButton.borderColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
    _viewOffersButton.bgColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
    _viewOffersButton.titleColor = [UIColor whiteColor];
    [_viewOffersButton addTarget:self action:@selector(viewOffersButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_viewOffersButton];
}


#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) sellerOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [[PFUser alloc] init];
    user2.objectId = _wantData.buyerID;
    user2[PF_USER_USERNAME] = _wantData.buyerUsername;
    
    BuyersOrSellersOfferViewController *sellersOfferVC = [[BuyersOrSellersOfferViewController alloc] init];
    sellersOfferVC.delegate = self;
    sellersOfferVC.buyerName = _wantData.buyerUsername;
    sellersOfferVC.user2 = user2;
    sellersOfferVC.offerFrom = OFFER_FROM_ITEM_DETAILS;
    
    if (_currOffer) {
        sellersOfferVC.offerData = _currOffer;
    } else {
        TransactionData *offerData = [[TransactionData alloc] init];
        offerData.itemID = _wantData.itemID;
        offerData.itemName = _wantData.itemName;
        offerData.originalDemandedPrice = _wantData.demandedPrice;
        offerData.buyerID = _wantData.buyerID;
        offerData.sellerID = user1.objectId;
        offerData.initiatorID = @"";
        offerData.offeredPrice = @"";
        offerData.deliveryTime = @"";
        offerData.transactionStatus = TRANSACTION_STATUS_NONE;
        sellersOfferVC.offerData = offerData;
    }
    
    [self.navigationController pushViewController:sellersOfferVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) chatButtonClickedEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [[PFUser alloc] init];
    user2.objectId = _wantData.buyerID;
    user2[PF_USER_USERNAME] = _wantData.buyerUsername;
    
    [[PersistedCache sharedCache] setImage:[_itemImageList objectAtIndex:0] forKey:_wantData.itemID];
    
    if (_currOffer) {
        NSString *id1 = user1.objectId;
        NSString *id2 = user2.objectId;
        
        NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", _currOffer.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", _currOffer.itemID, id2, id1];;
        [self actionChat:groupId withUser2:user2 andOfferData:_currOffer];
    } else {
        TransactionData *offerData = [[TransactionData alloc] init];
        offerData.itemID = _wantData.itemID;
        offerData.itemName = _wantData.itemName;
        offerData.originalDemandedPrice = _wantData.demandedPrice;
        offerData.buyerID = user2.objectId;
        offerData.sellerID = user1.objectId;
        offerData.initiatorID = @"";
        offerData.offeredPrice = @"";
        offerData.deliveryTime = @"";
        offerData.transactionStatus = TRANSACTION_STATUS_NONE;
        
        NSString *groupId = StartPrivateChat(user1, user2, offerData, nil);
        [self actionChat:groupId withUser2:user2 andOfferData:offerData];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewOffersButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    OfferViewingVC  *offerViewingVC = [[OfferViewingVC alloc] init];
    offerViewingVC.itemImage = _itemImageList.count > 0 ? [_itemImageList objectAtIndex:0] : nil;
    offerViewingVC.wantData = _wantData;
    [self.navigationController pushViewController:offerViewingVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) actionChat:(NSString *)groupId withUser2: (PFUser *) user2 andOfferData: (TransactionData *) offerData
//------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    [chatView setUser2Username:user2[PF_USER_USERNAME]];
    [chatView setOfferData:offerData];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) buyerUsernameButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    UserHandler handler = ^(PFUser *user) {
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    [Utilities retrieveUserInfoByUserID:_wantData.buyerID andRunBlock:handler];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateViewingOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *title = [NSString stringWithFormat:@"%@ (%ld)", NSLocalizedString(@"View Offer", nil), _numOfOffers];
    [_viewOffersButton createTitle:title withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateTransactionalData:(NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    PFObject *obj = notification.object;
    if (obj) {
        _currOffer = [[TransactionData alloc] initWithPFObject:obj];
        _secondBottomButtonTitle = NSLocalizedString(@"Change your offer", nil);
    } else {
        _currOffer = nil;
        _secondBottomButtonTitle = NSLocalizedString(@"Offer your price", nil);
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateSecondBottomButtonTitle
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_secondBottomButtonTitle.length > 0) {
        [_secondBottomButton createTitle:_secondBottomButtonTitle withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
        _secondBottomButton.cornerRadius = 0;
    }
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveItemOffers
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *countingQuery = [[PFQuery alloc] initWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [countingQuery whereKey:PF_ITEM_ID equalTo:_wantData.itemID];
    [countingQuery countObjectsInBackgroundWithBlock:^(int num, NSError *error) {
        _numOfOffers = num;
        [self updateViewingOfferButton];
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
- (void) buyersOrSellersOfferViewController:(BuyersOrSellersOfferViewController *)controller didOffer:(TransactionData *)offer
//------------------------------------------------------------------------------------------------------------------------------
{
    // update data in user profile page
    [_delegate itemDetailsViewController:self didCompleteOffer:YES];
    
    _currOffer = offer;
    
    NSString *id1 = [PFUser currentUser].objectId;
    NSString *id2 = _wantData.buyerID;
    NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", offer.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", offer.itemID, id2, id1];
    
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    [chatView setUser2Username:_wantData.buyerUsername];
    [chatView setOfferData:offer];
    chatView.hidesBottomBarWhenPushed = YES;
    
    NSString *message = [Utilities makingOfferMessageFromOfferedPrice:offer.offeredPrice andDeliveryTime:offer.deliveryTime];
    NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:offer.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_currOffer.objectID, FB_CURRENT_OFFERED_PRICE:offer.offeredPrice, FB_CURRENT_OFFERED_DELIVERY_TIME:offer.deliveryTime};
    
    CompletionHandler handler = ^() {
        [self.navigationController pushViewController:chatView animated:YES];
    };
    
    [chatView messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeMakingOffer TransactionDetails:transDetails CompletionBlock:handler];
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
