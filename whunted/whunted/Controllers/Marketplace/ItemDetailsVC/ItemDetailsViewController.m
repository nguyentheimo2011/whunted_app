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
#import "UserProfileViewController.h"
#import "OfferViewingVC.h"

#import "AppConstant.h"
#import "Utilities.h"

#import <JTImageButton.h>
#import <Google/Analytics.h>

@implementation ItemDetailsViewController
{
    UIPageViewController    *_pageViewController;
    
    UILabel                 *_itemNameLabel;
    UILabel                 *_postedTimestampLabel;
    UILabel                 *_demandedPriceLabel;
    UILabel                 *_locationLabel;
    UILabel                 *_itemDescLabel;
    UILabel                 *_itemHashtagLabel;
    UILabel                 *_productOriginLabel;
    UILabel                 *_secondHandLabel;
    UILabel                 *_sellersLabel;
    
    JTImageButton           *_buyerUsernameButton;
    JTImageButton           *_secondBottomButton;
    JTImageButton           *_viewOffersButton;
    JTImageButton           *_chatButton;
    JTImageButton           *_referenceLinkButton;
    
    UIPageControl           *_pageControl;
    UIScrollView            *_scrollView;
    
    NSString                *_secondBottomButtonTitle;
    
    NSMutableArray          *_itemImageList;
    
    CGFloat                 _currOccupiedYPos;

    NSInteger               _currImageIndex;
    
    BOOL                    _itemPostedByMe;
    
    NSInteger               _numOfOffers;
}

@synthesize wantData                =   _wantData;
@synthesize itemImagesNum           =   _itemImagesNum;
@synthesize currOffer               =   _currOffer;
@synthesize bottomButtonsNotNeeded  =   _bottomButtonsNotNeeded;
@synthesize viewControllerName      =   _viewControllerName;
@synthesize viewedOnSellingTab      =   _viewedOnSellingTab;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil)
    {
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
    if (_itemPostedByMe)
    {
        [self updateViewingOfferButtonTitle];
    }
    else
    {
        [self updateSecondBottomButtonTitle];
    }
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"ItemDetailsScreen"];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    [Utilities logOutMessage:@"ItemDetailsViewController didReceiveMemoryWarning"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionalData:) name:NOTIFICATION_NEW_OFFER_MADE_BY_ME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveItemOffers) name:NOTIFICATION_NEW_OFFER_MADE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionalData:) name:NOTIFICATION_OFFER_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionalData:) name:NOTIFICATION_OFFER_DECLINED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWantDataUponOfferAccepted) name:NOTIFICATION_OFFER_ACCEPTED object:nil];
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
    [Utilities customizeTitleLabel:_wantData.itemName forViewController:self];
    
    if ([_wantData.buyerID isEqualToString:[PFUser currentUser].objectId])
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editInfoOfMyWantData)];
}

/*
 * Used in viewDidLoad. ScrollView is adjusted automatically to start from the bottom of navigation bar
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height)];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_scrollView];
}

/*
 * Used when navigation bar has already been loaded. Used to re-add scrollview to ItemDetails view.
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView2
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat height = [Utilities getHeightOfNavigationAndStatusBars:self];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, WINSIZE.width, WINSIZE.height - height)];
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
    view.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_5;
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
    [self addReferenceLink];
    [self addProductOrigin];
    [self addSecondHandUI];
    
    _currOccupiedYPos += 60.0f;
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, _currOccupiedYPos)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addFunctionalButtons
//------------------------------------------------------------------------------------------------------------------------------
{
    if (!_bottomButtonsNotNeeded)
    {
        if (_itemPostedByMe)
        {
            [self addViewOfferButton];
        }
        else if (_wantData.isFulfilled)
        {
            [self addChatButton:YES];
        }
        else
        {
            [self addChatButton:NO];
            [self addOfferButton];
        }
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
    [_itemNameLabel setFont:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE]];
    [_itemNameLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_scrollView addSubview:_itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPostedTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *timestamp = [Utilities longTimestampStringFromDate:_wantData.createdDate];
    NSString *postedTimestampText;
    
    if ([Utilities isCurrLanguageTraditionalChinese])
        postedTimestampText = [NSString stringWithFormat:@"%@%@ %@", timestamp, NSLocalizedString(@"posted", nil), NSLocalizedString(@"by", nil)];
    else
        postedTimestampText = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"posted", nil), timestamp, NSLocalizedString(@"by", nil)];
    
    CGFloat const kLabelLeftMargin  =   10.0f;
    CGFloat const kLabelYPos        =   _itemNameLabel.frame.origin.y + _itemNameLabel.frame.size.height;
    
    _postedTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelYPos, 0, 0)];
    [_postedTimestampLabel setText:postedTimestampText];
    [_postedTimestampLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE]];
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
    [_buyerUsernameButton createTitle:_wantData.buyerUsername withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
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
    CGFloat const kPriceImageHeight         =   kPriceImageWidth;
    
    UIImage *priceTagImage = [UIImage imageNamed:@"pricetag_icon.png"];
    UIImageView *priceTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPriceImageLeftMargin, kPriceImageYPos, kPriceImageWidth, kPriceImageHeight)];
    [priceTagImageView setImage:priceTagImage];
    [_scrollView addSubview:priceTagImageView];
    
    CGFloat const kLabel1LeftMargin      =   15.0f;
    CGFloat const kLabel1OriginX         =   kPriceImageLeftMargin + kPriceImageWidth + kLabel1LeftMargin;
    CGFloat const kMaxWidth              =   WINSIZE.width - kLabel1OriginX - 10.0f;
    
    UILabel *contextualLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel1OriginX, kPriceImageYPos, kMaxWidth, kPriceImageHeight)];
    contextualLabel.text = NSLocalizedString(@"Willing to pay", nil);
    contextualLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    contextualLabel.textColor = TEXT_COLOR_GRAY;
    [contextualLabel sizeToFit];
    [_scrollView addSubview:contextualLabel];
    
    CGFloat const kLabel2OriginX    =   kLabel1OriginX + contextualLabel.frame.size.width;
    CGFloat const kLabel2Width      =   kMaxWidth - contextualLabel.frame.size.width;
    CGFloat const kLabel2Height     =   contextualLabel.frame.size.height;
    
    _demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel2OriginX, kPriceImageYPos, kLabel2Width, kLabel2Height)];
    [_demandedPriceLabel setText:_wantData.demandedPrice];
    [_demandedPriceLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]];
    [_demandedPriceLabel setTextColor:CYAN_COLOR_WITH_WHITE_1];
    [_scrollView addSubview:_demandedPriceLabel];
    
    _currOccupiedYPos = _demandedPriceLabel.frame.origin.y + _demandedPriceLabel.frame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLocationLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.meetingLocation.length > 0)
    {
        CGFloat const kLocationImageLeftMargin     =   10.0f;
        CGFloat const kLocationImageTopMargin      =   15.0f;
        CGFloat const kLocationImageYPos           =   _currOccupiedYPos + kLocationImageTopMargin;
        CGFloat const kLocationImageWidth          =   23.0f;
        CGFloat const kLocationImageHeight         =   23.0f;
        
        UIImage *locationImage = [UIImage imageNamed:@"location_icon.png"];
        UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLocationImageLeftMargin, kLocationImageYPos, kLocationImageWidth, kLocationImageHeight)];
        [locationImageView setImage:locationImage];
        [_scrollView addSubview:locationImageView];
        
        CGFloat const kLabelLeftMargin      =   15.0f;
        CGFloat const kLabel1OriginX        =   kLocationImageLeftMargin + kLocationImageWidth + kLabelLeftMargin;
        CGFloat const kMaxWidth             =   WINSIZE.width - kLabel1OriginX - 10.0f;
        
        UILabel *contextualLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel1OriginX, kLocationImageYPos, kMaxWidth, kLocationImageHeight)];
        contextualLabel.text = NSLocalizedString(@"Buyer is located at", nil);
        contextualLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
        contextualLabel.textColor = TEXT_COLOR_GRAY;
        [contextualLabel sizeToFit];
        [_scrollView addSubview:contextualLabel];
        
        CGFloat const kLabel2OriginX    =   kLabel1OriginX + contextualLabel.frame.size.width;
        CGFloat const kLabel2Width      =   kMaxWidth - contextualLabel.frame.size.width;
        CGFloat const kLabel2Height     =   contextualLabel.frame.size.height;
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel2OriginX, kLocationImageYPos, kLabel2Width, kLabel2Height)];
        [_locationLabel setText:_wantData.meetingLocation];
        [_locationLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]];
        [_locationLabel setTextColor:CYAN_COLOR_WITH_WHITE_1];
        [_scrollView addSubview:_locationLabel];
        
        _currOccupiedYPos = _locationLabel.frame.origin.y + _locationLabel.frame.size.height;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemDescLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.itemDesc.length > 0 || _wantData.hashTagList.count > 0)
    {
        CGFloat const kDescImageLeftMargin     =   10.0f;
        CGFloat const kDescImageTopMargin      =   15.0f;
        CGFloat const kDescImageYPos           =   _currOccupiedYPos + kDescImageTopMargin;
        CGFloat const kDescImageWidth          =   23.0f;
        
        UIImage *descriptionImage = [UIImage imageNamed:@"info_icon.png"];
        UIImageView *descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDescImageLeftMargin, kDescImageYPos, kDescImageWidth, kDescImageWidth)];
        [descriptionImageView setImage:descriptionImage];
        [_scrollView addSubview:descriptionImageView];
        
        CGFloat const kLabelLeftMargin      =   15.0f;
        CGFloat const kLabelXPos            =   kDescImageLeftMargin + kDescImageWidth + kLabelLeftMargin;
        CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
        
        if (_wantData.itemDesc.length > 0)
        {
            _itemDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kDescImageYPos, kLabelWidth, 0)];
            _itemDescLabel.text = _wantData.itemDesc;
            _itemDescLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
            _itemDescLabel.textColor = CYAN_COLOR_WITH_WHITE_1;
            _itemDescLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _itemDescLabel.numberOfLines = 0;
            [_itemDescLabel sizeToFit];
            [_scrollView addSubview:_itemDescLabel];
            
            _currOccupiedYPos = _itemDescLabel.frame.origin.y + _itemDescLabel.frame.size.height;
        }
        else
        {
            _currOccupiedYPos = kDescImageYPos;
        }
        
        if (_wantData.hashTagList.count > 0)
        {
            NSString *hashtagString = [_wantData.hashTagList componentsJoinedByString:@" "];
            
            _itemHashtagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, _currOccupiedYPos, kLabelWidth, 0)];
            _itemHashtagLabel.text = hashtagString;
            _itemHashtagLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
            _itemHashtagLabel.textColor = CYAN_COLOR_WITH_WHITE_1;
            _itemHashtagLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _itemHashtagLabel.numberOfLines = 0;
            [_itemHashtagLabel sizeToFit];
            [_scrollView addSubview:_itemHashtagLabel];
            
            _currOccupiedYPos = _itemHashtagLabel.frame.origin.y + _itemHashtagLabel.frame.size.height;
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addReferenceLink
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.referenceURL.length > 0)
    {
        CGFloat const kLinkImageLeftMargin     =   10.0f;
        CGFloat const kLinkImageTopMargin      =   15.0f;
        CGFloat const kLinkImageYPos           =   _currOccupiedYPos + kLinkImageTopMargin;
        CGFloat const kLinkImageWidth          =   23.0f;
        CGFloat const kLinkImageHeight         =   23.0f;
        
        UIImage *linkIconImage = [UIImage imageNamed:@"reference_link_icon.png"];
        UIImageView *linkIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLinkImageLeftMargin, kLinkImageYPos, kLinkImageWidth, kLinkImageHeight)];
        [linkIconImageView setImage:linkIconImage];
        [_scrollView addSubview:linkIconImageView];
        
        CGFloat const kButtonLeftMargin      =   15.0f;
        CGFloat const kButtonXPos            =   kLinkImageLeftMargin + kLinkImageWidth + kButtonLeftMargin;
        CGFloat const kButtonWidth           =   WINSIZE.width - kButtonXPos - 10.0f;
        
        _referenceLinkButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonXPos, kLinkImageYPos, kButtonWidth, kLinkImageHeight)];
        [_referenceLinkButton createTitle:_wantData.referenceURL withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
        _referenceLinkButton.titleColor = CYAN_COLOR_WITH_WHITE_1;
        _referenceLinkButton.bgColor = [UIColor whiteColor];
        _referenceLinkButton.borderWidth = 0;
        [_referenceLinkButton addTarget:self action:@selector(referenceLinkButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_referenceLinkButton];
        
        _currOccupiedYPos = _referenceLinkButton.frame.origin.y + _referenceLinkButton.frame.size.height;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addProductOrigin
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.itemOrigins.count > 0 && ((NSString *)[_wantData.itemOrigins objectAtIndex:0]).length > 0)
    {
        CGFloat const kOriginImageLeftMargin     =   10.0f;
        CGFloat const kOriginImageTopMargin      =   15.0f;
        CGFloat const kOriginImageYPos           =   _currOccupiedYPos + kOriginImageTopMargin;
        CGFloat const kOriginImageWidth          =   23.0f;
        CGFloat const kOriginImageHeight         =   kOriginImageWidth;
        
        UIImage *originIconImage = [UIImage imageNamed:@"product_origin_icon.png"];
        UIImageView *originIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kOriginImageLeftMargin, kOriginImageYPos, kOriginImageWidth, kOriginImageHeight)];
        [originIconImageView setImage:originIconImage];
        [_scrollView addSubview:originIconImageView];
        
        CGFloat const kLabelLeftMargin      =   15.0f;
        CGFloat const kLabel1OriginX        =   kOriginImageLeftMargin + kOriginImageWidth + kLabelLeftMargin;
        CGFloat const kMaxWidth             =   WINSIZE.width - kLabel1OriginX - 10.0f;
        
        UILabel *contextualLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel1OriginX, kOriginImageYPos, kMaxWidth, kOriginImageHeight)];
        contextualLabel.text = NSLocalizedString(@"Product comes from", nil);
        contextualLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
        contextualLabel.textColor = TEXT_COLOR_GRAY;
        [contextualLabel sizeToFit];
        [_scrollView addSubview:contextualLabel];
        
        if (_wantData.itemOrigins.count == 1)
        {
            CGFloat const kLabel2OriginX    =   kLabel1OriginX + contextualLabel.frame.size.width;
            CGFloat const kLabel2Width      =   kMaxWidth - contextualLabel.frame.size.width;
            CGFloat const kLabel2Height     =   contextualLabel.frame.size.height;
            
            _productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel2OriginX, kOriginImageYPos, kLabel2Width, kLabel2Height)];
            _productOriginLabel.text = _wantData.itemOrigins[0];
            _productOriginLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
            [_productOriginLabel setTextColor:CYAN_COLOR_WITH_WHITE_1];
            [_scrollView addSubview:_productOriginLabel];
        }
        else
        {
            NSString *productOriginText = [_wantData.itemOrigins componentsJoinedByString:@", "];
            CGFloat const kLabel2OriginX    =   kLabel1OriginX;
            CGFloat const kLabel2OriginY    =   kOriginImageYPos + contextualLabel.frame.size.height + 4.0f;
            CGFloat const kLabel2Width      =   kMaxWidth;
            
            _productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel2OriginX, kLabel2OriginY, kLabel2Width, 0)];
            _productOriginLabel.text = productOriginText;
            _productOriginLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
            _productOriginLabel.textColor = CYAN_COLOR_WITH_WHITE_1;
            _productOriginLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _productOriginLabel.numberOfLines = 0;
            [_productOriginLabel sizeToFit];
            [_scrollView addSubview:_productOriginLabel];
        }
        
        _currOccupiedYPos = _productOriginLabel.frame.origin.y + _productOriginLabel.frame.size.height;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSecondHandUI
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageLeftMargin     =   10.0f;
    CGFloat const kImageTopMargin      =   15.0f;
    CGFloat const kImageYPos           =   _currOccupiedYPos + kImageTopMargin;
    CGFloat const kImageWidth          =   23.0f;
    CGFloat const kImageHeight         =   23.0f;
    
    UIImage *iconImage = [UIImage imageNamed:@"secondhand_option_icon.png"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftMargin, kImageYPos, kImageWidth, kImageHeight)];
    [iconImageView setImage:iconImage];
    [_scrollView addSubview:iconImageView];
    
    CGFloat const kLabelLeftMargin      =   15.0f;
    CGFloat const kLabelXPos            =   kImageLeftMargin + kImageWidth + kLabelLeftMargin;
    CGFloat const kLabelWidth           =   WINSIZE.width - kLabelXPos - 10.0f;
    
    _secondHandLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kImageYPos, kLabelWidth, kImageHeight)];
    _secondHandLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _secondHandLabel.textColor = TEXT_COLOR_GRAY;
    
    if (_wantData.acceptedSecondHand)
        _secondHandLabel.text = NSLocalizedString(@"Accept both new and second-hand", nil);
    else
        _secondHandLabel.text = NSLocalizedString(@"Accept only new item", nil);
    
    [_scrollView addSubview:_secondHandLabel];
    
    _currOccupiedYPos = _secondHandLabel.frame.origin.y + _secondHandLabel.frame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addChatButton: (BOOL) isFullWidth
//------------------------------------------------------------------------------------------------------------------------------
{
    // if the want hasn't been fulfilled yet, chat button has the width of half of screen's width.
    // if the want has already been fulfilled and item is viewd from marketplace, chat button is temporarily 'Item Bought' button and is disabled.
    UIView *backgroundView;
    
    if (isFullWidth)
    {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, WINSIZE.height - BOTTOM_BUTTON_HEIGHT, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    }
    else
    {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, WINSIZE.height - BOTTOM_BUTTON_HEIGHT, WINSIZE.width/2, BOTTOM_BUTTON_HEIGHT)];
    }
    
    [backgroundView setBackgroundColor:[GRAY_COLOR_WITH_WHITE_COLOR_2 colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    if (isFullWidth && [_viewControllerName isEqualToString:ITEM_DETAILS_FROM_MARKETPLACE])
    {
        _chatButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
        
        if (_viewedOnSellingTab)
        {
            [_chatButton createTitle:NSLocalizedString(@"Item Sold", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconHeight:0 iconOffsetY:0];
        }
        else
        {
            [_chatButton createTitle:NSLocalizedString(@"Item Bought", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconHeight:0 iconOffsetY:0];
        }
    
        _chatButton.bgColor = [FLAT_FRESH_RED_COLOR colorWithAlphaComponent:0.9f];
    }
    else
    {
        if (isFullWidth)
        {
            _chatButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
        }
        else
        {
            _chatButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/2, BOTTOM_BUTTON_HEIGHT)];
        }
        
        [_chatButton createTitle:NSLocalizedString(@"Chat with buyer", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconHeight:0 iconOffsetY:0];
        [_chatButton addTarget:self action:@selector(chatButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.bgColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
    }
    
    _chatButton.cornerRadius = 0;
    _chatButton.borderWidth = 0;
    _chatButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:_chatButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(WINSIZE.width/2, WINSIZE.height - BOTTOM_BUTTON_HEIGHT, WINSIZE.width/2, BOTTOM_BUTTON_HEIGHT)];
    [backgroundView setBackgroundColor:[GRAY_COLOR_WITH_WHITE_COLOR_2 colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    _secondBottomButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width/2, BOTTOM_BUTTON_HEIGHT)];
    _secondBottomButton.borderColor = [PERSIAN_GREEN_COLOR colorWithAlphaComponent:0.9f];
    _secondBottomButton.bgColor = [PERSIAN_GREEN_COLOR colorWithAlphaComponent:0.9f];
    _secondBottomButton.titleColor = [UIColor whiteColor];
    
    if (_currOffer)
    {
        _secondBottomButtonTitle = NSLocalizedString(@"Change your offer", nil);
        [_secondBottomButton createTitle:_secondBottomButtonTitle withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
    }
    else
    {
        _secondBottomButtonTitle = NSLocalizedString(@"Offer to sell", nil);
        [_secondBottomButton createTitle:_secondBottomButtonTitle withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
    }
    
    [_secondBottomButton addTarget:self action:@selector(sellerOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    _secondBottomButton.cornerRadius = 0;
    [backgroundView addSubview:_secondBottomButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addViewOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, WINSIZE.height - BOTTOM_BUTTON_HEIGHT, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    [backgroundView setBackgroundColor:[GRAY_COLOR_WITH_WHITE_COLOR_2 colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    _viewOffersButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    
    if (_wantData.isFulfilled)
    {
        [_viewOffersButton createTitle:NSLocalizedString(@"Item Bought", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
        _viewOffersButton.bgColor = [FLAT_FRESH_RED_COLOR colorWithAlphaComponent:0.9f];
    }
    else
    {
        [_viewOffersButton createTitle:NSLocalizedString(@"View Offer", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
        _viewOffersButton.bgColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
    }
    
    _viewOffersButton.cornerRadius = 0;
    _viewOffersButton.borderWidth = 0;
    _viewOffersButton.titleColor = [UIColor whiteColor];
    [_viewOffersButton addTarget:self action:@selector(viewOffersButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_viewOffersButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [_scrollView removeFromSuperview];
    
    [self retrieveItemImages];
    [self addScrollView2];
    [self addPageViewController];
    [self addItemDetails];
    [self addFunctionalButtons];
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
    
    if (_currOffer)
    {
        [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"EditOfferFromItemDetailsEvent" label:@"OfferButton" value:nil];
        
        sellersOfferVC.offerData = _currOffer;
    }
    else
    {
        [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"MakeOfferFromItemDetailsEvent" label:@"OfferButton" value:nil];
        
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
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ChatFromItemDetailsEvent" label:@"ChatButton" value:nil];
    
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [[PFUser alloc] init];
    user2.objectId = _wantData.buyerID;
    user2[PF_USER_USERNAME] = _wantData.buyerUsername;
    
    if (_currOffer)
    {
        NSString *id1 = user1.objectId;
        NSString *id2 = user2.objectId;
        
        NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", _currOffer.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", _currOffer.itemID, id2, id1];;
        [self actionChat:groupId withUser2:user2 andOfferData:_currOffer];
    }
    else
    {
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
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewOffersEvent" label:@"ViewOffersButton" value:nil];
    
    OfferViewingVC  *offerViewingVC = [[OfferViewingVC alloc] init];
    offerViewingVC.itemImage    =   _itemImageList.count > 0 ? [_itemImageList objectAtIndex:0] : nil;
    offerViewingVC.wantData     =   _wantData;
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
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewUserProfileEvent" label:@"BuyerUsernameButton" value:nil];
    
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    UserHandler handler = ^(PFUser *user)
    {
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    [Utilities retrieveUserInfoByUserID:_wantData.buyerID andRunBlock:handler];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateViewingOfferButtonTitle
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.isFulfilled)
    {
        [_viewOffersButton createTitle:NSLocalizedString(@"Item Bought", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
        _viewOffersButton.bgColor = [FLAT_FRESH_RED_COLOR colorWithAlphaComponent:0.9f];
        _viewOffersButton.borderWidth = 0;
        _viewOffersButton.cornerRadius = 0;
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"%@ (%ld)", NSLocalizedString(@"View Offer", nil), _numOfOffers];
        [_viewOffersButton createTitle:title withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
        _viewOffersButton.bgColor = [DARK_CYAN_COLOR colorWithAlphaComponent:0.9f];
        _viewOffersButton.borderWidth = 0;
        _viewOffersButton.cornerRadius = 0;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateTransactionalData:(NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    PFObject *obj = notification.object;
    if (obj)
    {
        _currOffer = [[TransactionData alloc] initWithPFObject:obj];
        _secondBottomButtonTitle = NSLocalizedString(@"Change your offer", nil);
    }
    else
    {
        _currOffer = nil;
        _secondBottomButtonTitle = NSLocalizedString(@"Offer to sell", nil);
        
        // if cancel or decline offer, then decrease numOfOffers by 1
        if (_numOfOffers > 0)
            _numOfOffers--;
    }
}


//------------------------------------------------------------------------------------------------------------------------------
- (void) updateWantDataUponOfferAccepted
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.isFulfilled = YES;
    
    if (!_itemPostedByMe)
    {
        // if item is not posted by me, change the two bottom buttons to one Chat button
        [_chatButton.superview removeFromSuperview];
        [_secondBottomButton.superview removeFromSuperview];
        [self addChatButton:YES];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) updateSecondBottomButtonTitle
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_secondBottomButtonTitle.length > 0)
    {
        [_secondBottomButton createTitle:_secondBottomButtonTitle withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALLER_FONT_SIZE] iconOffsetY:0];
        _secondBottomButton.cornerRadius = 0;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) editInfoOfMyWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"EditWantDataEvent" label:@"EditButton" value:nil];
    
    EditWantDataVC *editingVC = [[EditWantDataVC alloc] initWithWantData:_wantData forEditing:YES];
    editingVC.delegate = self;
    [self.navigationController pushViewController:editingVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) referenceLinkButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_wantData.referenceURL]];
    [webView loadRequest:request];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = webView;
    [self.navigationController pushViewController:viewController animated:YES];
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
    _currOffer = offer;
    
    NSString *id1 = [PFUser currentUser].objectId;
    NSString *id2 = _wantData.buyerID;
    NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", offer.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", offer.itemID, id2, id1];
    
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    [chatView setUser2Username:_wantData.buyerUsername];
    [chatView setOfferData:offer];
    chatView.hidesBottomBarWhenPushed = YES;
    
    NSString *message = [Utilities makingOfferMessageFromOfferedPrice:offer.offeredPrice deliveryTime:offer.deliveryTime shippingFeeIncluded:offer.shippingFeeIncluded];
    NSDictionary *transDetails = @{FB_GROUP_ID:groupId, FB_TRANSACTION_STATUS:offer.transactionStatus, FB_TRANSACTION_LAST_USER: [PFUser currentUser].objectId, FB_CURRENT_OFFER_ID:_currOffer.objectID, FB_CURRENT_OFFERED_PRICE:offer.offeredPrice, FB_CURRENT_SHIPPING_FEE_INCLUDED:[Utilities stringFromBoolean:offer.shippingFeeIncluded], FB_CURRENT_OFFERED_DELIVERY_TIME:offer.deliveryTime};
    
    CompletionHandler handler = ^() {
        [self.navigationController pushViewController:chatView animated:YES];
    };
    
    [chatView messageSend:message Video:nil Picture:nil Audio:nil ChatMessageType:ChatMessageTypeMakingOffer TransactionDetails:transDetails CompletionBlock:handler];
}


#pragma mark - UploadingWantDetailsViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) completeEditingWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    [self updateUI];
}


#pragma mark - Backend

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveItemImages
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemImageList = [[NSMutableArray alloc] init];
    _wantData.itemPictures = [[NSMutableArray alloc] init];
    
    PFRelation *picRelation = _wantData.itemPictureList;
    PFQuery *query = [picRelation query];
    [query orderByAscending:PF_CREATED_AT];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *pfObjList, NSError *error )
    {
        if (error)
        {
            [Utilities handleError:error];
        }
        else
        {
            for (int i=0; i<pfObjList.count; i++)
            {
                [_itemImageList addObject:[[UIImage alloc] init]];
                [_wantData.itemPictures addObject:[pfObjList objectAtIndex:i]];
            }
            
            for (int i=0; i<pfObjList.count; i++)
            {
                PFObject *pfObj = [pfObjList objectAtIndex:i];
                
                PFFile *imageFile = pfObj[PF_ITEM_PICTURE];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                {
                    UIImage *image = [UIImage imageWithData:data];
                    [_itemImageList replaceObjectAtIndex:i withObject:image];
                    ItemImageViewController *itemImageVC = [self viewControllerAtIndex:_currImageIndex];
                    NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
                    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                }];
            }
            
            _pageControl.numberOfPages = [pfObjList count];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveItemOffers
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.isFulfilled)
    {
        _numOfOffers = 1;
    }
    else
    {
        PFQuery *countingQuery = [[PFQuery alloc] initWithClassName:PF_ONGOING_TRANSACTION_CLASS];
        [countingQuery whereKey:PF_ITEM_ID equalTo:_wantData.itemID];
        [countingQuery countObjectsInBackgroundWithBlock:^(int num, NSError *error) {
            _numOfOffers = num;
            [self updateViewingOfferButtonTitle];
        }];
    }
}


#pragma mark - Helpers

//------------------------------------------------------------------------------------------------------------------------------
- (ItemImageViewController *) viewControllerAtIndex: (NSInteger) index
//------------------------------------------------------------------------------------------------------------------------------
{
    ItemImageViewController *itemImageVC = [[ItemImageViewController alloc] init];
    itemImageVC.index = index;
    _currImageIndex = index;
    if (index < [_itemImageList count])
    {
        [itemImageVC.itemImageView setImage:[_itemImageList objectAtIndex:index]];
    }
    
    return itemImageVC;
}


#pragma mark - Next version

/*
//------------------------------------------------------------------------------------------------------------------------------
- (void) addSellersLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kSellerImageLeftMargin     =   10.0f;
    CGFloat const kSellerImageTopMargin      =   15.0f;
    CGFloat const kSellerImageYPos           =   _currOccupiedYPos + kSellerImageTopMargin;
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

    _currOccupiedYPos = _sellersLabel.frame.origin.y + _sellersLabel.frame.size.height + 60.0f;
}*/

/*
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
 if ([_wantData.paymentMethod isEqualToString:PAYMENT_METHOD_ESCROW])
 {
 paymentMethodText = @"Request for Escrow";
 }
 else
 {
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
 */

@end
