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

@interface ItemDetailsViewController ()

@property (nonatomic, strong) NSMutableArray *itemImageList;

@end

@implementation ItemDetailsViewController
{
    NSInteger _currIndex;
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
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
@synthesize secondBottomButton;
@synthesize offeredByCurrUser;
@synthesize offerPFObject;
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
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
    [self addChatButton];
    [self addOfferButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers

- (void) addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height)];
    [_scrollView setBackgroundColor:APP_COLOR_6];
    [self.view addSubview:_scrollView];
}

- (void) addPageViewController
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

- (ItemImageViewController *) viewControllerAtIndex: (NSInteger) index
{
    ItemImageViewController *itemImageVC = [[ItemImageViewController alloc] init];
    itemImageVC.index = index;
    _currIndex = index;
    if (index < [itemImageList count]) {
        [itemImageVC.itemImageView setImage:[itemImageList objectAtIndex:index]];
    }
    
    return itemImageVC;
}

- (void) addItemNameLabel
{
    itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WINSIZE.height * 0.6, WINSIZE.width - 20, 15)];
    [itemNameLabel setText:wantData.itemName];
    [itemNameLabel setFont:[UIFont systemFontOfSize:16]];
    [itemNameLabel setTextColor:[UIColor blackColor]];
    [_scrollView addSubview:itemNameLabel];
}

- (void) addPostedTimestampLabel
{
    postedTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WINSIZE.height * 0.6 + 20, 140, 15)];
    [postedTimestampLabel setText:@"listed 3 hours ago by"];
    [postedTimestampLabel setFont:[UIFont systemFontOfSize:14]];
    [postedTimestampLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:postedTimestampLabel];
}

- (void) addBuyerUsernameButton
{
    buyerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(115, WINSIZE.height * 0.6 + 20, 150, 15)];
    [buyerUsernameButton setTitle:wantData.buyer.objectId forState:UIControlStateNormal];
    [buyerUsernameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buyerUsernameButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_scrollView addSubview:buyerUsernameButton];
}

- (void) addDemandedPriceLabel
{
    demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WINSIZE.height * 0.6 + 50, WINSIZE.width-20, 15)];
    [demandedPriceLabel setText:wantData.demandedPrice];
    [demandedPriceLabel setFont:[UIFont systemFontOfSize:14]];
    [demandedPriceLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:demandedPriceLabel];
}

- (void) addLocationLabel
{
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WINSIZE.height * 0.6 + 80, WINSIZE.width-20, 15)];
    [locationLabel setText:wantData.meetingLocation];
    [locationLabel setFont:[UIFont systemFontOfSize:14]];
    [locationLabel setTextColor:[UIColor grayColor]];
    [_scrollView addSubview:locationLabel];
}

- (void) addItemDescLabel
{
    itemDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WINSIZE.height * 0.6 + 110, WINSIZE.width-20, 40)];
    [itemDescLabel setText:wantData.itemDesc];
    [itemDescLabel setFont:[UIFont systemFontOfSize:14]];
    [itemDescLabel setTextColor:[UIColor grayColor]];
    itemDescLabel.lineBreakMode = NSLineBreakByWordWrapping;
    itemDescLabel.numberOfLines = 0;
    [_scrollView addSubview:itemDescLabel];
}

- (void) addChatButton
{
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, WINSIZE.height - 40, WINSIZE.width/2, 40)];
    [chatButton setBackgroundColor:[UIColor grayColor]];
    [chatButton setTitle:@"對話" forState:UIControlStateNormal];
    [chatButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [chatButton addTarget:self action:@selector(chatButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatButton];
}

- (void) addOfferButton
{
    PFUser *curUser = [PFUser currentUser];
    secondBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width/2, WINSIZE.height - 40, WINSIZE.width/2, 40)];
    
    if ([wantData.buyer.objectId isEqualToString:curUser.objectId]) {
        [secondBottomButton setBackgroundColor:[UIColor colorWithRed:99.0/255 green:184.0/255 blue:1.0 alpha:1.0]];
        [secondBottomButton setTitle:@"跟朋友分享!" forState:UIControlStateNormal];
        [secondBottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:secondBottomButton];
    } else {
        [secondBottomButton setBackgroundColor:[UIColor colorWithRed:99.0/255 green:184.0/255 blue:1.0 alpha:1.0]];
        if (offeredByCurrUser)
            [secondBottomButton setTitle:@"修改出價" forState:UIControlStateNormal];
        else
            [secondBottomButton setTitle:@"出價" forState:UIControlStateNormal];
        [secondBottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [secondBottomButton addTarget:self action:@selector(sellerOfferButtonClickedHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:secondBottomButton];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Event Handlers
//------------------------------------------------------------------------------------------------------------------------------

- (void) sellerOfferButtonClickedHandler
{
    SellersOfferViewController *sellersOfferVC = [[SellersOfferViewController alloc] init];
    sellersOfferVC.wantData = wantData;
    sellersOfferVC.delegate = self;
    
    if (offerPFObject) {
        sellersOfferVC.currOfferedPrice = offerPFObject[@"offeredPrice"];
        sellersOfferVC.currOfferedDelivery = offerPFObject[@"deliveryTime"];
    }
    
    [self.navigationController pushViewController:sellersOfferVC animated:YES];
}

- (void) chatButtonClickedEvent
{
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = [wantData buyer];
    [user2 fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if (!error) {
            NSString *groupId = StartPrivateChat(user1, user2);
            [self actionChat:groupId];
        } else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)actionChat:(NSString *)groupId
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Handlers
//------------------------------------------------------------------------------------------------------------------------------

- (void) retrieveItemImages
{    
    itemImageList = [[NSMutableArray alloc] init];
    PFRelation *picRelation = wantData.itemPictureList;
    
    [[picRelation query] findObjectsInBackgroundWithBlock:^(NSArray *pfObjList, NSError *error ) {
        for (PFObject *pfObj in pfObjList) {
            PFFile *imageFile = pfObj[@"itemPicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [itemImageList addObject:image];
                ItemImageViewController *itemImageVC = [self viewControllerAtIndex:_currIndex];
                NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
                [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - PageViewController datasource methods
//------------------------------------------------------------------------------------------------------------------------------

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    if (index == 0) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index-1];
    }
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    if (index == itemImagesNum-1) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index+1];
    }
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return itemImagesNum;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - SellersOfferViewController delegate methods
//------------------------------------------------------------------------------------------------------------------------------

- (void) sellerOfferViewController:(SellersOfferViewController *)controller didOfferForItem:(PFObject *) object
{
    offeredByCurrUser = YES;
    offerPFObject = object;
    [secondBottomButton setTitle:@"修改出價" forState:UIControlStateNormal];
    [delegate itemDetailsViewController:self didCompleteOffer:YES];
}


@end
