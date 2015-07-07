//
//  ItemDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 2/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemDetailsViewController.h"
#import "AppConstant.h"
#import "ItemImageViewController.h"
#import "ChatView.h"
#import "recent.h"
#import "PersistedCache.h"

@interface ItemDetailsViewController ()

@property (nonatomic, strong) NSMutableArray *itemImageList;

@end

@implementation ItemDetailsViewController
{
    NSInteger       _currImageIndex;
    UIPageControl   *_pageControl;
    UIScrollView    *_scrollView;
    CGFloat         _nextXPos;
    CGFloat         _nextYPos;
}

@synthesize pageViewController;
@synthesize wantData;
@synthesize itemImageList;
@synthesize itemImagesNum;
@synthesize itemNameLabel;
@synthesize postedTimestampLabel;
@synthesize buyerUsernameButton;
@synthesize demandedPriceLabel;
@synthesize locationLabel;
@synthesize itemDescLabel;
@synthesize productOriginLabel;
@synthesize paymentMethodLabel;
@synthesize sellersLabel;
@synthesize secondBottomButton;
@synthesize currOffer = _currOffer;
@synthesize delegate;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self retrieveItemImages];
    [self addScrollView];
    [self addPageViewController];
    [self addItemNameLabel];
    [self addPostedTimestampLabel];
    [self addBuyerUsernameButton];
    [self addDemandedPriceLabel];
    [self addLocationLabel];
    [self addItemDescLabel];
    [self addProductOrigin];
    [self addPaymentMethodLabel];
    [self addSellersLabel];
    [self addChatButton];
    [self addOfferButton];
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height)];
    [_scrollView setBackgroundColor:LIGHTEST_GRAY_COLOR];
    [self.view addSubview:_scrollView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPageViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    pageViewController.view.frame = CGRectMake(0, 0, WINSIZE.width, WINSIZE.height * 0.6);
    
    ItemImageViewController *itemImageVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageViewController];
    [_scrollView addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
}

//------------------------------------------------------------------------------------------------------------------------------
- (ItemImageViewController *) viewControllerAtIndex: (NSInteger) index
//------------------------------------------------------------------------------------------------------------------------------
{
    ItemImageViewController *itemImageVC = [[ItemImageViewController alloc] init];
    itemImageVC.index = index;
    _currImageIndex = index;
    if (index < [itemImageList count]) {
        [itemImageVC.itemImageView setImage:[itemImageList objectAtIndex:index]];
    }
    
    return itemImageVC;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WINSIZE.height * 0.6 - 10, WINSIZE.width - 20, 20)];
    [itemNameLabel setText:wantData.itemName];
    [itemNameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:17]];
    [itemNameLabel setTextColor:[UIColor blackColor]];
    [_scrollView addSubview:itemNameLabel];
    
    _nextYPos = WINSIZE.height * 0.6 + 13;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPostedTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *placeHolderText = @"listed 3 hours ago by";
    CGSize expectedSize = [placeHolderText sizeWithAttributes:@{NSFontAttributeName: NORMAL_FONT}];
    
    postedTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _nextYPos, expectedSize.width, expectedSize.height)];
    [postedTimestampLabel setText:placeHolderText];
    [postedTimestampLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [postedTimestampLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:postedTimestampLabel];
    
    _nextXPos = expectedSize.width - 10;
    _nextYPos = _nextYPos + expectedSize.height + 17;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerUsernameButton
//------------------------------------------------------------------------------------------------------------------------------
{
    buyerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(_nextXPos, postedTimestampLabel.frame.origin.y, 150, 20)];
    [buyerUsernameButton setTitle:wantData.buyer.objectId forState:UIControlStateNormal];
    [buyerUsernameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buyerUsernameButton.titleLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [_scrollView addSubview:buyerUsernameButton];
    
    _nextXPos = 10;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDemandedPriceLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *priceTagImage = [UIImage imageNamed:@"pricetag_icon.png"];
    UIImageView *priceTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, 23, 23)];
    [priceTagImageView setImage:priceTagImage];
    [_scrollView addSubview:priceTagImageView];
    
    _nextXPos = 40;
    _nextYPos += 3;
    
    demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, 20)];
    [demandedPriceLabel setText:wantData.demandedPrice];
    [demandedPriceLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [demandedPriceLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:demandedPriceLabel];
    
    _nextXPos = 10;
    _nextYPos += 35;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLocationLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *locationImage = [UIImage imageNamed:@"location_icon.png"];
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, 23, 23)];
    [locationImageView setImage:locationImage];
    [_scrollView addSubview:locationImageView];
    
    _nextXPos = 40;
    _nextYPos += 3;
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, 25)];
    [locationLabel setText:wantData.meetingLocation];
    [locationLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [locationLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:locationLabel];
    
    _nextXPos = 10;
    _nextYPos += 35;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemDescLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *descriptionImage = [UIImage imageNamed:@"info_icon.png"];
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, 20, 20)];
    [descriptionImageView setImage:descriptionImage];
    [_scrollView addSubview:descriptionImageView];
    
    _nextXPos = 40;
    _nextYPos += 3;
    
    CGSize expectedSize = [wantData.itemDesc sizeWithAttributes:@{NSFontAttributeName: NORMAL_FONT}];
    itemDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, expectedSize.height)];
    [itemDescLabel setText:wantData.itemDesc];
    [itemDescLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [itemDescLabel setTextColor:[UIColor grayColor]];
    itemDescLabel.lineBreakMode = NSLineBreakByWordWrapping;
    itemDescLabel.numberOfLines = 0;
    [_scrollView addSubview:itemDescLabel];
    
    _nextXPos = 10;
    _nextYPos += expectedSize.height + 20;
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
    
    NSString *productOriginText = [wantData.productOriginList componentsJoinedByString:@", "];
    CGSize expectedSize = [productOriginText sizeWithAttributes:@{NSFontAttributeName: NORMAL_FONT}];
    productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, expectedSize.height)];
    [productOriginLabel setText:productOriginText];
    [productOriginLabel setFont:NORMAL_FONT];
    [productOriginLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:productOriginLabel];
    
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
    if ([wantData.paymentMethod isEqualToString:ESCROW_PAYMENT_METHOD]) {
        paymentMethodText = @"Request for Escrow";
    } else {
        paymentMethodText = @"Not request for Escrow";
    }
    paymentMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, 20)];
    [paymentMethodLabel setText:paymentMethodText];
    [paymentMethodLabel setFont:NORMAL_FONT];
    [paymentMethodLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:paymentMethodLabel];
    
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
    sellersLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nextXPos, _nextYPos, WINSIZE.width-50, 20)];
    [sellersLabel setText:sellersText];
    [sellersLabel setFont:NORMAL_FONT];
    [sellersLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:sellersLabel];
    
    _nextYPos += 25;
    
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, _nextYPos += 60)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addChatButton
//------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, WINSIZE.height - 40, WINSIZE.width/2, 40)];
    [chatButton setBackgroundColor:[UIColor grayColor]];
    [chatButton setTitle:NSLocalizedString(@"Chat", nil) forState:UIControlStateNormal];
    [chatButton.titleLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [chatButton addTarget:self action:@selector(chatButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferButton
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *curUser = [PFUser currentUser];
    secondBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width/2, WINSIZE.height - 40, WINSIZE.width/2, 40)];
    
    if ([wantData.buyer.objectId isEqualToString:curUser.objectId]) {
        [secondBottomButton setBackgroundColor:[UIColor colorWithRed:99.0/255 green:184.0/255 blue:1.0 alpha:1.0]];
        [secondBottomButton setTitle:NSLocalizedString(@"Promote your post", nil) forState:UIControlStateNormal];
        [secondBottomButton.titleLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
        [self.view addSubview:secondBottomButton];
    } else {
        [secondBottomButton setBackgroundColor:[UIColor colorWithRed:99.0/255 green:184.0/255 blue:1.0 alpha:1.0]];
        if (_currOffer)
            [secondBottomButton setTitle:NSLocalizedString(@"Change your offer", nil) forState:UIControlStateNormal];
        else
            [secondBottomButton setTitle:NSLocalizedString(@"Offer your price", nil) forState:UIControlStateNormal];
        [secondBottomButton.titleLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
        [secondBottomButton addTarget:self action:@selector(sellerOfferButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:secondBottomButton];
    }
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) sellerOfferButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [wantData buyer];
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
                offerData.itemID = wantData.itemID;
                offerData.itemName = wantData.itemName;
                offerData.originalDemandedPrice = wantData.demandedPrice;
                offerData.buyerID = user2.objectId;
                offerData.sellerID = user1.objectId;
                offerData.initiatorID = @"";
                offerData.offeredPrice = @"";
                offerData.deliveryTime = @"";
                offerData.offerStatus = PF_OFFER_STATUS_NOT_OFFERED;
                sellersOfferVC.offerData = offerData;
            }
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
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [wantData buyer];
    [user2 fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if (!error) {
            [[PersistedCache sharedCache] setImage:[itemImageList objectAtIndex:0] forKey:wantData.itemID];
            
            if (_currOffer) {
                NSString *groupId = StartPrivateChat(user1, user2, _currOffer);
                [self actionChat:groupId withUser2:user2 andOfferData:_currOffer];
            } else {
                OfferData *offerData = [[OfferData alloc] init];
                offerData.itemID = wantData.itemID;
                offerData.itemName = wantData.itemName;
                offerData.originalDemandedPrice = wantData.demandedPrice;
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
    itemImageList = [[NSMutableArray alloc] init];
    PFRelation *picRelation = wantData.itemPictureList;
    
    [[picRelation query] findObjectsInBackgroundWithBlock:^(NSArray *pfObjList, NSError *error ) {
        for (PFObject *pfObj in pfObjList) {
            PFFile *imageFile = pfObj[@"itemPicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [itemImageList addObject:image];
                ItemImageViewController *itemImageVC = [self viewControllerAtIndex:_currImageIndex];
                NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
                [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }];
        }
    }];
}

#pragma mark - PageViewController datasource methods

//------------------------------------------------------------------------------------------------------------------------------
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    if (index == 0) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index-1];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    if (index == itemImagesNum-1) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index+1];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    return itemImagesNum;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//------------------------------------------------------------------------------------------------------------------------------
{
    // The selected item reflected in the page indicator.
    return 0;
}

#pragma mark - SellersOfferViewController delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) buyersOrSellersOfferViewController:(BuyersOrSellersOfferViewController *)controller didOffer:(OfferData *)offer
//------------------------------------------------------------------------------------------------------------------------------
{
    _currOffer = offer;
    [secondBottomButton setTitle:NSLocalizedString(@"Change your offer", nil) forState:UIControlStateNormal];
    [delegate itemDetailsViewController:self didCompleteOffer:YES];
}


@end
