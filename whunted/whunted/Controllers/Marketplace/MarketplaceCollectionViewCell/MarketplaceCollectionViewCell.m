//
//  MarketplaceCollectionViewCell.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceCollectionViewCell.h"
#import "ItemImageCache.h"
#import "ProfileImageCache.h"
#import "AppConstant.h"
#import "Utilities.h"

#define kCellLeftMagin      4.0f
#define kCellRightMargin    4.0f

@implementation MarketplaceCollectionViewCell
{
    UILabel             *_itemNameLabel;
    UILabel             *_demandedPriceLabel;
    UIButton            *_buyerUsernameButton;
    UILabel             *_timestampLabel;
    UIButton            *_sellerNumButton;
    UIButton            *_likeButton;
    UIButton            *_buyerProfilePic;
    UIImageView         *_itemImageView;
    
    UILabel             *_boughtOrSoldLabel;
    
    UIImageView         *_likeImageView;
    UILabel             *_likesNumLabel;
    UIView              *_likesNumContainer;
    
    CGFloat             _cellWidth;
    CGFloat             _cellHeight;
    BOOL                _likedByMe;
    NSInteger           _likesNum;
}

@synthesize wantData        =   _wantData;
@synthesize cellIndex       =   _cellIndex;
@synthesize cellIdentifier  =   _cellIdentifier;

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCell
//------------------------------------------------------------------------------------------------------------------------------
{
    [self initData];
    [self customizeCell];
    [self addItemImageView];
    [self addBoughtOrSoldLabel];
    [self addItemNameLabel];
    [self addPriceLabel];
    [self addBuyerProfilePic];
    [self addBuyerUsername];
    [self addTimestampLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _likedByMe = NO;
    _likesNum = _wantData.likesNum;
}


#pragma mark - Setters

//------------------------------------------------------------------------------------------------------------------------------
- (void) setWantData:(WantData *)wantData
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData = wantData;
    _likesNum = _wantData.likesNum;
    
    [_itemNameLabel setText:_wantData.itemName];
    [_demandedPriceLabel setText:_wantData.demandedPrice];
    [_buyerUsernameButton setTitle:_wantData.buyerUsername forState:UIControlStateNormal];
    [_timestampLabel setText:[Utilities timestampStringFromDate:_wantData.createdDate]];
    [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", wantData.likesNum]];
    [self resizeLikesNumContainer];
    [_sellerNumButton setTitle:[NSString stringWithFormat:@"%ld", wantData.sellersNum] forState:UIControlStateNormal];
    
    NSString *text;
    if (_wantData.sellersNum <= 1)
    {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"seller", nil)];
    }
    else
    {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"sellers", nil)];
    }
    
    [_sellerNumButton setTitle:text forState:UIControlStateNormal];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", _wantData.itemID, ITEM_FIRST_IMAGE];
    _itemImageView.image = [[ItemImageCache sharedCache] objectForKey:key];
    
    
    if (!_itemImageView.image)
        [self retrieveItemImage];
    
    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _wantData.buyerID, USER_PROFILE_IMAGE];
    if ([[ProfileImageCache sharedCache] objectForKey:imageKey])
    {
        UIImage *profileImage = [[ProfileImageCache sharedCache] objectForKey:imageKey];
        [_buyerProfilePic setBackgroundImage:profileImage forState:UIControlStateNormal];
    }
    else
    {
        [self retrieveProfileImage];
    }
    
    if (_wantData.isFulfilled)
        _boughtOrSoldLabel.hidden = NO;
    else
        _boughtOrSoldLabel.hidden = YES;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) clearCellUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [_buyerProfilePic setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [GRAY_COLOR_WITH_WHITE_COLOR_3 CGColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    [Utilities addShadowToCollectionCell:self];
    
    _cellWidth = self.frame.size.width;
    _cellHeight = self.frame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellWidth)];
    [_itemImageView setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_1];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    _itemImageView.layer.borderWidth = 0.5f;
    _itemImageView.layer.borderColor = [GRAY_COLOR_WITH_WHITE_COLOR_3 CGColor];
    _itemImageView.layer.cornerRadius = 5;
    _itemImageView.clipsToBounds = YES;
    [self addSubview:_itemImageView];
    
    _itemImageView.image = nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBoughtOrSoldLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _boughtOrSoldLabel = [[UILabel alloc] init];
    _boughtOrSoldLabel.text = NSLocalizedString(@"Sold", nil);
    _boughtOrSoldLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _boughtOrSoldLabel.textColor = [UIColor whiteColor];
    _boughtOrSoldLabel.backgroundColor = FLAT_FRESH_RED_COLOR;
    _boughtOrSoldLabel.layer.cornerRadius = 4.0f;
    _boughtOrSoldLabel.clipsToBounds = YES;
    [_boughtOrSoldLabel sizeToFit];
    
    CGFloat const kLabelWidth   =   _boughtOrSoldLabel.frame.size.width + 10.0f;
    CGFloat const kLabelHeight  =   _boughtOrSoldLabel.frame.size.height;
    CGFloat const kLabelOriginX =   _cellWidth - kLabelWidth - 8.0f;
    CGFloat const kLabelOriginY =   8.0f;
    _boughtOrSoldLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight);
    _boughtOrSoldLabel.textAlignment = NSTextAlignmentCenter;
    
    [_itemImageView addSubview:_boughtOrSoldLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelYPos      =   _cellWidth + 8.0f;
    CGFloat const kLabelWidth     =   _cellWidth - 2 * kCellLeftMagin;
    CGFloat const kLabelHeight    =   20.0f;
    
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellLeftMagin, kLabelYPos, kLabelWidth, kLabelHeight)];
    [_itemNameLabel setText:@"Item name"];
    [_itemNameLabel setFont:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]];
    _itemNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [self addSubview:_itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPriceLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kPriceLabelPos    =   _cellWidth + 30.0f;
    CGFloat const kPriceLabelWidth  =   _cellWidth - 2 * kCellLeftMagin;
    CGFloat const kPriceLabelHeight =   15.0f;
    
    _demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellLeftMagin, kPriceLabelPos, kPriceLabelWidth, kPriceLabelHeight)];
    [_demandedPriceLabel setText:@"Item price"];
    [_demandedPriceLabel setFont:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:14]];
    [_demandedPriceLabel setTextColor:TEXT_COLOR_GRAY];
    [self addSubview:_demandedPriceLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerProfilePic
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageWidth = 45.0f;
    CGFloat const kImageHeight = kImageWidth;
    CGFloat const kImageOriginY = _cellWidth + 40.0f;
    CGFloat const kImageOriginX = _cellWidth - kCellRightMargin - kImageWidth;
    
    _buyerProfilePic = [[UIButton alloc] initWithFrame:CGRectMake(kImageOriginX, kImageOriginY, kImageWidth, kImageHeight)];
    [_buyerProfilePic setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_2];
    _buyerProfilePic.layer.cornerRadius = kImageWidth/2;
    _buyerProfilePic.clipsToBounds = YES;
    _buyerProfilePic.layer.borderWidth = 0.5f;
    _buyerProfilePic.layer.borderColor = [GRAY_COLOR_WITH_WHITE_COLOR_3 CGColor];
    [_buyerProfilePic addTarget:self action:@selector(profilePictureTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buyerProfilePic];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerUsername
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX    =   kCellLeftMagin;
    CGFloat const kLabelOriginY    =   _cellWidth + 52.0f;
    CGFloat const kLabelWidth       =   _cellWidth - kCellLeftMagin - 3 * kCellRightMargin - _buyerProfilePic.frame.size.width;
    CGFloat const kLabelHeight      =   15.0f;
    
    _buyerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    [_buyerUsernameButton setTitle:NSLocalizedString(@"Username", nil) forState:UIControlStateNormal];
    [_buyerUsernameButton.titleLabel setFont:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:13]];
    [_buyerUsernameButton setTitleColor:TEXT_COLOR_LESS_DARK forState:UIControlStateNormal];
    _buyerUsernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_buyerUsernameButton addTarget:self action:@selector(usernameLabelTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buyerUsernameButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelXPos    =   _buyerUsernameButton.frame.origin.x;
    CGFloat const kLabelYPos    =   _cellWidth + 68.0f;
    CGFloat const kLabelWidth   =   _buyerUsernameButton.frame.size.width;
    CGFloat const kLabelHeight  =   15.0f;
    
    _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    [_timestampLabel setText:@"timestamp"];
    [_timestampLabel setFont:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:13]];
    [_timestampLabel setTextColor:TEXT_COLOR_GRAY];
    _timestampLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timestampLabel];
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) likeButtonClickedEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_likedByMe)
    {
        _likedByMe = NO;
        _likesNum -= 1;
        [_likeImageView setImage:[UIImage imageNamed:@"heart_white.png"]];
        [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    }
    else
    {
        _likedByMe = YES;
        _likesNum += 1;
        [_likeImageView setImage:[UIImage imageNamed:@"heart_red.png"]];
        [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    }
    
    [self resizeLikesNumContainer];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) usernameLabelTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_cellIdentifier isEqualToString:CELL_IN_MARKETPLACE])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_MARKETPLACE_TAP_EVENT object:_wantData.buyerID];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_USER_PROFILE_TAP_EVENT object:_wantData.buyerID];
    }
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) profilePictureTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_cellIdentifier isEqualToString:CELL_IN_MARKETPLACE])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_MARKETPLACE_TAP_EVENT object:_wantData.buyerID];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERNAME_BUTTON_USER_PROFILE_TAP_EVENT object:_wantData.buyerID];
    }
}


#pragma mark - Helpers

//------------------------------------------------------------------------------------------------------------------------------
- (void) resizeLikesNumContainer
//------------------------------------------------------------------------------------------------------------------------------
{
    [_likesNumLabel sizeToFit];
    
    CGFloat const kContainerWidth = _likesNumLabel.frame.origin.x + _likesNumLabel.frame.size.width;
    CGFloat const kContainerXPos  = (_likeButton.frame.size.width - kContainerWidth) / 2.0;
    
    _likesNumContainer.frame = CGRectMake(kContainerXPos, 0, kContainerWidth, _likeButton.frame.size.height);
}

#pragma mark - Backend

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveItemImage
//------------------------------------------------------------------------------------------------------------------------------
{
    PFRelation *picRelation = _wantData.itemPictureList;
    PFQuery *query = [picRelation query];
    [query orderByAscending:PF_CREATED_AT];
    
    __block NSInteger cellIndex = _cellIndex;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error)
    {
        if (!error)
        {
            PFFile *firstPicture = firstObject[@"itemPicture"];
            [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2)
            {
                if (!error_2)
                {
                    // check if it is setting image for the right cell
                    if (_cellIndex == cellIndex)
                    {
                        UIImage *image = [UIImage imageWithData:data];
                        [_itemImageView setImage:image];
                        
                        NSString *key = [NSString stringWithFormat:@"%@%@", _wantData.itemID, ITEM_FIRST_IMAGE];
                        [[ItemImageCache sharedCache] setObject:image forKey:key];
                    }
                }
                else
                {
                    [Utilities handleError:error_2];
                }
            }];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) retrieveProfileImage
//------------------------------------------------------------------------------------------------------------------------------
{
    __block NSInteger cellIndex = _cellIndex;
    
    FetchedUserHandler handler = ^(PFUser *user, UIImage *image)
    {
        // check if it is setting buyerProfileImage for the right cell
        if (_cellIndex == cellIndex)
        {
            if (image)
            {
                [_buyerProfilePic setBackgroundImage:image forState:UIControlStateNormal];
                
                NSString *imageKey = [NSString stringWithFormat:@"%@%@", _wantData.buyerID, USER_PROFILE_IMAGE];
                [[ProfileImageCache sharedCache] setObject:image forKey:imageKey];
            }
            else
            {
                UIImage *placeHolder = [UIImage imageNamed:@"user_profile_image_placeholder_big.png"];
                [_buyerProfilePic setBackgroundImage:placeHolder forState:UIControlStateNormal];
                NSString *imageKey = [NSString stringWithFormat:@"%@%@", _wantData.buyerID, USER_PROFILE_IMAGE];
                [[ProfileImageCache sharedCache] setObject:placeHolder forKey:imageKey];
            }
        }
    };
    
    [Utilities getUserWithID:_wantData.buyerID imageNeeded:YES andRunBlock:handler];
}

#pragma mark - Next version

/*
 //------------------------------------------------------------------------------------------------------------------------------
 - (void) addLikeButton
 //------------------------------------------------------------------------------------------------------------------------------
 {
 CGFloat const kButtonXPos   =   0;
 CGFloat const kButtonYPos   =   _cellWidth + 90.0f;
 CGFloat const kButtonWidth  =   _cellWidth/2;
 CGFloat const kButtonHeight =   25.0f;
 
 _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonYPos, kButtonWidth, kButtonHeight)];
 [_likeButton setBackgroundColor:[UIColor whiteColor]];
 _likeButton.layer.borderWidth = 0.5f;
 _likeButton.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
 [_likeButton addTarget:self action:@selector(likeButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
 [self addSubview:_likeButton];
 
 CGFloat const kImageTopMargin   =   5.5f;
 CGFloat const kImageWdith       =   14.0f;
 
 _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, kImageTopMargin, kImageWdith, kImageWdith)];
 [_likeImageView setImage:[UIImage imageNamed:@"heart_white.png"]];
 
 CGFloat const kLabelLeftMargin  =   5.0f;
 CGFloat const kLabelXPos        =   kImageWdith + kLabelLeftMargin;
 CGFloat const kLabelYPos        =   5.0f;
 CGFloat const kLabelHeight      =   15.0f;
 
 _likesNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, 0, kLabelHeight)];
 [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
 [_likesNumLabel setTextColor:TEXT_COLOR_GRAY];
 [_likesNumLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
 [_likesNumLabel sizeToFit];
 
 CGFloat const kContainerWidth = kImageWdith + kLabelLeftMargin + _likesNumLabel.frame.size.width;
 CGFloat const kContainerXPos  = (kButtonWidth - kContainerWidth) / 2.0;
 
 _likesNumContainer = [[UIView alloc] initWithFrame:CGRectMake(kContainerXPos, 0, kContainerWidth, kButtonHeight)];
 [_likesNumContainer addSubview:_likeImageView];
 [_likesNumContainer addSubview:_likesNumLabel];
 UITapGestureRecognizer *tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeButtonClickedEvent)];
 [_likesNumContainer addGestureRecognizer:tapGesRec];
 
 [_likeButton addSubview:_likesNumContainer];
 }
 
 //------------------------------------------------------------------------------------------------------------------------------
 - (void) addSellerNumButton
 //------------------------------------------------------------------------------------------------------------------------------
 {
 CGFloat const kButtonXPos   =   _cellWidth/2 - 0.5f;
 CGFloat const kButtonYPos   =   _likeButton.frame.origin.y;
 CGFloat const kButtonWidth  =   _cellWidth/2 + 0.5f;
 CGFloat const kButtonHeight =   _likeButton.frame.size.height;
 
 _sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonXPos, kButtonYPos, kButtonWidth, kButtonHeight)];
 [_sellerNumButton setBackgroundColor:[UIColor whiteColor]];
 _sellerNumButton.layer.borderWidth = 0.5f;
 _sellerNumButton.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
 [_sellerNumButton setTitle:[NSString stringWithFormat: @"0 %@", NSLocalizedString(@"seller", nil)] forState:UIControlStateNormal];
 _sellerNumButton.titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:14];
 [_sellerNumButton setTitleColor:TEXT_COLOR_GRAY forState:UIControlStateNormal];
 [self addSubview:_sellerNumButton];
 }
 */

@end
