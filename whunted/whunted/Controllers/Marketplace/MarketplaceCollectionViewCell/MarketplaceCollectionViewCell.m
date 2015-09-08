//
//  MarketplaceCollectionViewCell.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceCollectionViewCell.h"
#import "TemporaryCache.h"
#import "AppConstant.h"
#import "Utilities.h"

#define kCellLeftMagin      4.0f
#define kCellRightMargin    4.0f

@implementation MarketplaceCollectionViewCell
{
    UILabel             *_itemNameLabel;
    UILabel             *_demandedPriceLabel;
    UILabel             *_buyerUsernameLabel;
    UILabel             *_timestampLabel;
    UIButton            *_sellerNumButton;
    UIButton            *_likeButton;
    UIImageView         *_buyerProfilePic;
    UIImageView         *_itemImageView;
    
    UIImageView         *_likeImageView;
    UILabel             *_likesNumLabel;
    UIView              *_likesNumContainer;
    
    CGFloat             _cellWidth;
    CGFloat             _cellHeight;
    BOOL                _likedByMe;
    NSInteger           _likesNum;
}

@synthesize wantData = _wantData;

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCell
//------------------------------------------------------------------------------------------------------------------------------
{
    [self initData];
    [self customizeCell];
    [self addItemImageView];
    [self addItemNameLabel];
    [self addPriceLabel];
    [self addBuyerProfilePic];
    [self addBuyerUsername];
    [self addTimestampLabel];
    [self addLikeButton];
    [self addSellerNumButton];
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
    [_buyerUsernameLabel setText:_wantData.buyerUsername];
    [_timestampLabel setText:[Utilities timestampStringFromDate:_wantData.createdDate]];
    [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", wantData.likesNum]];
    [self resizeLikesNumContainer];
    [_sellerNumButton setTitle:[NSString stringWithFormat:@"%ld", wantData.sellersNum] forState:UIControlStateNormal];
    
    NSString *text;
    if (_wantData.sellersNum <= 1) {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"seller", nil)];
    } else {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"sellers", nil)];
    }
    
    [_sellerNumButton setTitle:text forState:UIControlStateNormal];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", _wantData.itemID, ITEM_FIRST_IMAGE];
    _itemImageView.image = [[TemporaryCache sharedCache] objectForKey:key];
    
    
    if (!_itemImageView.image)
        [self downloadItemImage];
    
    NSString *imageKey = [NSString stringWithFormat:@"%@%@", _wantData.buyerID, USER_PROFILE_IMAGE];
    if ([[TemporaryCache sharedCache] objectForKey:imageKey]) {
        UIImage *profileImage = [[TemporaryCache sharedCache] objectForKey:imageKey];
        [_buyerProfilePic setImage:profileImage];
    } else {
        [self downloadProfileImage];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) clearCellUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [_buyerProfilePic setImage:nil];
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    _cellWidth = self.frame.size.width;
    _cellHeight = self.frame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellWidth)];
    [_itemImageView setBackgroundColor:[UIColor whiteColor]];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    _itemImageView.layer.borderWidth = 0.5f;
    _itemImageView.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    [self addSubview:_itemImageView];
    
    _itemImageView.image = nil;
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
    [_itemNameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
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
    [_demandedPriceLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [_demandedPriceLabel setTextColor:TEXT_COLOR_GRAY];
    [self addSubview:_demandedPriceLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerProfilePic
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageYPos = _cellWidth + 53.0f;
    CGFloat const kImageWidth = 30.0f;
    
    _buyerProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(kCellLeftMagin, kImageYPos, kImageWidth, kImageWidth)];
    [_buyerProfilePic setBackgroundColor:LIGHTEST_GRAY_COLOR];
    _buyerProfilePic.layer.cornerRadius = kImageWidth/2;
    _buyerProfilePic.clipsToBounds = YES;
    _buyerProfilePic.layer.borderWidth = 0.5f;
    _buyerProfilePic.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    [self addSubview:_buyerProfilePic];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerUsername
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelXPos    =   _buyerProfilePic.frame.size.width + 2 * kCellLeftMagin;
    CGFloat const kLabelYPos    =   _buyerProfilePic.frame.origin.y - 2.0f;
    CGFloat const kLabelWidth   =   _cellWidth - kLabelXPos - kCellRightMargin;
    CGFloat const kLabelHeight  =   15.0f;
    
    _buyerUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    [_buyerUsernameLabel setText:@"Username"];
    [_buyerUsernameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [_buyerUsernameLabel setTextColor:TEXT_COLOR_GRAY];
    [self addSubview:_buyerUsernameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelXPos    =   _buyerUsernameLabel.frame.origin.x;
    CGFloat const kLabelYPos    =   _cellWidth + 68.0f;
    CGFloat const kLabelWidth   =   _buyerUsernameLabel.frame.size.width;
    CGFloat const kLabelHeight  =   15.0f;
    
    _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    [_timestampLabel setText:@"timestamp"];
    [_timestampLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [_timestampLabel setTextColor:TEXT_COLOR_GRAY];
    [self addSubview:_timestampLabel];
}

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


#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) likeButtonClickedEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_likedByMe) {
        _likedByMe = NO;
        _likesNum -= 1;
        [_likeImageView setImage:[UIImage imageNamed:@"heart_white.png"]];
        [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    } else {
        _likedByMe = YES;
        _likesNum += 1;
        [_likeImageView setImage:[UIImage imageNamed:@"heart_red.png"]];
        [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    }
    
    [self resizeLikesNumContainer];
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
- (void) downloadItemImage
//------------------------------------------------------------------------------------------------------------------------------
{
    PFRelation *picRelation = _wantData.itemPictureList;
    PFQuery *query = [picRelation query];
    [query orderByAscending:PF_CREATED_AT];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error) {
        if (!error) {
            PFFile *firstPicture = firstObject[@"itemPicture"];
            [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2) {
                if (!error_2)
                {
                    UIImage *image = [UIImage imageWithData:data];
                    [_itemImageView setImage:image];
                    
                    NSString *key = [NSString stringWithFormat:@"%@%@", _wantData.itemID, ITEM_FIRST_IMAGE];
                    [[TemporaryCache sharedCache] setObject:image forKey:key];
                }
                else
                {
                    NSLog(@"Error: %@ %@", error_2, [error_2 userInfo]);
                }
            }];
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) downloadProfileImage
//------------------------------------------------------------------------------------------------------------------------------
{
    FetchedUserHandler handler = ^(PFUser *user, UIImage *image) {
        if ([user.objectId isEqualToString:_wantData.buyerID]) {
            [_buyerProfilePic setImage:image];
            
            NSString *imageKey = [NSString stringWithFormat:@"%@%@", _wantData.buyerID, USER_PROFILE_IMAGE];
            [[TemporaryCache sharedCache] setObject:image forKey:imageKey];
        }
    };
    
    [Utilities getUserWithID:_wantData.buyerID andRunBlock:handler];
}

@end
