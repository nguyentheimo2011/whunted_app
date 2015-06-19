//
//  MarketplaceCollectionViewCell.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceCollectionViewCell.h"
#import "AppConstant.h"

@implementation MarketplaceCollectionViewCell
{
    CGFloat _cellWidth;
    CGFloat _cellHeight;
    BOOL _likedByMe;
    NSInteger _likesNum;
    UIImageView *_likeImageView;
    UILabel *_likesNumLabel;
}

@synthesize itemNameLabel;
@synthesize demandedPriceLabel;
@synthesize buyerUsernameLabel;
@synthesize timestampLabel;
@synthesize sellerNumButton;
@synthesize likeButton;
@synthesize buyerProfilePic;
@synthesize itemImageView;
@synthesize wantData;

- (void) initCell
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

- (void) initData
{
    _likedByMe = NO;
    _likesNum = 124;
}

#pragma mark - UI Handlers

- (void) customizeCell
{
    [self setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    _cellWidth = self.frame.size.width;
    _cellHeight = self.frame.size.height;
}

- (void) addItemImageView
{
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellWidth)];
    [itemImageView setBackgroundColor:APP_COLOR_3];
    [self addSubview:itemImageView];
    [itemImageView hnk_cancelSetImage];
    itemImageView.image = nil;
}

- (void) addItemNameLabel
{
    CGFloat yPos = _cellWidth + 10;
    itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 20)];
    [itemNameLabel setText:@"Item name"];
    [itemNameLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:itemNameLabel];
}

- (void) addPriceLabel
{
    CGFloat yPos = _cellWidth + 35;
    demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 15)];
    [demandedPriceLabel setText:@"Item price"];
    [demandedPriceLabel setFont:[UIFont systemFontOfSize:15]];
    [demandedPriceLabel setTextColor:[UIColor grayColor]];
    [self addSubview:demandedPriceLabel];
}

- (void) addBuyerProfilePic
{
    CGFloat yPos = _cellWidth + 60;
    buyerProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(5, yPos, 30, 30)];
    [buyerProfilePic setBackgroundColor:APP_COLOR_6];
    buyerProfilePic.layer.cornerRadius = 13;
    [self addSubview:buyerProfilePic];
}

- (void) addBuyerUsername
{
    CGFloat xPos = 45;
    CGFloat yPos = _cellWidth + 60;
    buyerUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, WINSIZE.width/2-55, 15)];
    [buyerUsernameLabel setText:@"Username"];
    [buyerUsernameLabel setFont:[UIFont systemFontOfSize:14]];
    [buyerUsernameLabel setTextColor:[UIColor grayColor]];
    [self addSubview:buyerUsernameLabel];
}

- (void) addTimestampLabel {
    CGFloat xPos = 45;
    CGFloat yPos = _cellWidth + 75;
    timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, WINSIZE.width/2-55, 15)];
    [timestampLabel setText:@"timestamp"];
    [timestampLabel setFont:[UIFont systemFontOfSize:14]];
    [timestampLabel setTextColor:[UIColor grayColor]];
    [self addSubview:timestampLabel];
}

- (void) addSellerNumButton
{
    CGFloat yPos = _cellWidth + 100;
    sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _cellWidth/2, 25)];
    [sellerNumButton setBackgroundColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0]];
    [sellerNumButton setTitle:@"0 賣家" forState:UIControlStateNormal];
    sellerNumButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:sellerNumButton];
}

- (void) addLikeButton
{
    CGFloat xPos = _cellWidth/2;
    CGFloat yPos = _cellWidth + 100;
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, _cellWidth/2, 25)];
    [likeButton setBackgroundColor:APP_COLOR_3];
    [likeButton addTarget:self action:@selector(likeButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeButton];
    
    _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, -1.5, 28, 28)];
    [_likeImageView setImage:[UIImage imageNamed:@"heart_white.png"]];
    [likeButton addSubview:_likeImageView];
    
    _likesNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, _cellWidth/2 - 40, 15)];
    [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    [_likesNumLabel setTextColor:[UIColor whiteColor]];
    [_likesNumLabel setFont:[UIFont systemFontOfSize:16]];
    [likeButton addSubview:_likesNumLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Event Handlers
//------------------------------------------------------------------------------------------------------------------------------
- (void) likeButtonClickedEvent
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

@end
