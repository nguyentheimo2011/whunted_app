//
//  MarketplaceCollectionViewCell.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceCollectionViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"

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
    [self addSellerNumButton];
    [self addLikeButton];
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
    
    [_itemNameLabel setText:_wantData.itemName];
    [_demandedPriceLabel setText:_wantData.demandedPrice];
    [_buyerUsernameLabel setText:_wantData.buyerUsername];
    [_timestampLabel setText:[Utilities timestampStringFromDate:_wantData.createdDate]];
    [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", wantData.likesNum]];
    [_sellerNumButton setTitle:[NSString stringWithFormat:@"%ld", wantData.sellersNum] forState:UIControlStateNormal];
    
    NSString *text;
    if (_wantData.sellersNum <= 1) {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"seller", nil)];
    } else {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"sellers", nil)];
    }
    
    [_sellerNumButton setTitle:text forState:UIControlStateNormal];
    
    _itemImageView.image = nil;
    [_itemImageView hnk_setImage:nil withKey:[NSString stringWithFormat:@"item_%@", _wantData.itemID]];
    
    if (!_itemImageView.image)
        [self downloadItemImage];
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeCell
//------------------------------------------------------------------------------------------------------------------------------
{
    [self setBackgroundColor:LIGHTEST_GRAY_COLOR];
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [GRAY_COLOR_LIGHT CGColor];
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
    [_itemImageView setBackgroundColor:LIGHT_GRAY_COLOR];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_itemImageView];
    [_itemImageView hnk_cancelSetImage];
    _itemImageView.image = nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat yPos = _cellWidth + 10;
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 20)];
    [_itemNameLabel setText:@"Item name"];
    [_itemNameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self addSubview:_itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPriceLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat yPos = _cellWidth + 35;
    _demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 15)];
    [_demandedPriceLabel setText:@"Item price"];
    [_demandedPriceLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [_demandedPriceLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_demandedPriceLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerProfilePic
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageLeftMargin = 5.0f;
    CGFloat const kImageYPos = _cellWidth + 60.0f;
    CGFloat const kImageWidth = 30.0f;
    
    _buyerProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftMargin, kImageYPos, kImageWidth, kImageWidth)];
    [_buyerProfilePic setBackgroundColor:LIGHT_BLUE_COLOR];
    _buyerProfilePic.layer.cornerRadius = kImageWidth/2;
    [self addSubview:_buyerProfilePic];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerUsername
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelXPos    =   40.0f;
    CGFloat const kLabelYPos    =   _cellWidth + 60.0f;
    CGFloat const kLabelWidth   =   WINSIZE.width/2 - 53.0f;
    CGFloat const kLabelHeight  =   15.0f;
    
    _buyerUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    [_buyerUsernameLabel setText:@"Username"];
    [_buyerUsernameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [_buyerUsernameLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_buyerUsernameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelXPos    =   40.0f;
    CGFloat const kLabelYPos    =   _cellWidth + 75.0f;
    CGFloat const kLabelWidth   =   WINSIZE.width/2 - 53.0f;
    CGFloat const kLabelHeight  =   15.0f;
    
    _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    [_timestampLabel setText:@"timestamp"];
    [_timestampLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:13]];
    [_timestampLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_timestampLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSellerNumButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kXPos = _cellWidth/2;
    CGFloat const kYPos = _cellWidth + 100;
    _sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(kXPos, kYPos, _cellWidth/2, 25)];
    [_sellerNumButton setBackgroundColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0]];
    [_sellerNumButton setTitle:[NSString stringWithFormat: @"0 %@", NSLocalizedString(@"seller", nil)] forState:UIControlStateNormal];
    _sellerNumButton.titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    [self addSubview:_sellerNumButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLikeButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kXPos = 0;
    CGFloat const kYPos = _cellWidth + 100;
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(kXPos, kYPos, _cellWidth/2, 25)];
    [_likeButton setBackgroundColor:LIGHT_GRAY_COLOR];
    [_likeButton addTarget:self action:@selector(likeButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, -1.5, 28, 28)];
    [_likeImageView setImage:[UIImage imageNamed:@"heart_white.png"]];
    [_likeButton addSubview:_likeImageView];
    
    _likesNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, _cellWidth/2 - 40, 15)];
    [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    [_likesNumLabel setTextColor:[UIColor whiteColor]];
    [_likesNumLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_likeButton addSubview:_likesNumLabel];
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
}


#pragma mark - Backend

//------------------------------------------------------------------------------------------------------------------------------
- (void) downloadItemImage
//------------------------------------------------------------------------------------------------------------------------------
{
    PFRelation *picRelation = _wantData.itemPictureList;
    [[picRelation query] getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error) {
        if (!error) {
            PFFile *firstPicture = firstObject[@"itemPicture"];
            [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2) {
                if (!error_2) {
                    UIImage *image = [UIImage imageWithData:data];
                    [_itemImageView hnk_setImage:image withKey:[NSString stringWithFormat:@"item_%@", _wantData.itemID]];
                } else {
                    NSLog(@"Error: %@ %@", error_2, [error_2 userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
