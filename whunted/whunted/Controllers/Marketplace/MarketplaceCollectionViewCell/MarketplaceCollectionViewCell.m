//
//  MarketplaceCollectionViewCell.m
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceCollectionViewCell.h"
#import "Utilities.h"

@implementation MarketplaceCollectionViewCell

@synthesize itemNameLabel;
@synthesize demandedPriceLabel;
@synthesize buyerUsernameLabel;
@synthesize timestampLabel;
@synthesize sellerNumButton;
@synthesize cheapestPriceLabel;
@synthesize buyerProfilePic;
@synthesize itemImageView;

- (void) initCell
{
    [self addItemImageView];
    [self addItemNameLabel];
    [self addPriceLabel];
    [self addBuyerProfilePic];
    [self addBuyerUsername];
    [self addTimestampLabel];
    [self addSellerNumButton];
    [self addCheapestPriceLabel];
}

- (void) addItemImageView
{
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, WINSIZE.width/2-15, WINSIZE.width/2-10)];
    [itemImageView setBackgroundColor:APP_COLOR_2];
    [self addSubview:itemImageView];
}

- (void) addItemNameLabel
{
    CGFloat yPos = WINSIZE.width/2 + 5;
    itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 15)];
    [itemNameLabel setText:@"Item name"];
    [itemNameLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:itemNameLabel];
}

- (void) addPriceLabel
{
    CGFloat yPos = WINSIZE.width/2 + 25;
    demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 15)];
    [demandedPriceLabel setText:@"Item price"];
    [demandedPriceLabel setFont:[UIFont systemFontOfSize:15]];
    [demandedPriceLabel setTextColor:APP_COLOR_2];
    [self addSubview:demandedPriceLabel];
}

- (void) addBuyerProfilePic
{
    CGFloat yPos = WINSIZE.width/2 + 50;
    buyerProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(5, yPos, 30, 30)];
    [buyerProfilePic setBackgroundColor:APP_COLOR_6];
    buyerProfilePic.layer.cornerRadius = 13;
    [self addSubview:buyerProfilePic];
}

- (void) addBuyerUsername
{
    CGFloat xPos = 45;
    CGFloat yPos = WINSIZE.width/2 + 50;
    buyerUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, WINSIZE.width/2-55, 15)];
    [buyerUsernameLabel setText:@"Username"];
    [buyerUsernameLabel setFont:[UIFont systemFontOfSize:14]];
    [buyerUsernameLabel setTextColor:APP_COLOR_2];
    [self addSubview:buyerUsernameLabel];
}

- (void) addTimestampLabel {
    CGFloat xPos = 45;
    CGFloat yPos = WINSIZE.width/2 + 65;
    timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, WINSIZE.width/2-55, 15)];
    [timestampLabel setText:@"timestamp"];
    [timestampLabel setFont:[UIFont systemFontOfSize:14]];
    [timestampLabel setTextColor:APP_COLOR_2];
    [self addSubview:timestampLabel];
}

- (void) addSellerNumButton
{
    CGFloat xPos = 5;
    CGFloat yPos = WINSIZE.width/2 + 90;
    sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, (WINSIZE.width/2-15)/2, 25)];
    [sellerNumButton setBackgroundColor:APP_COLOR_2];
    [sellerNumButton setTitle:@"2 sellers" forState:UIControlStateNormal];
    sellerNumButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:sellerNumButton];
}

- (void) addCheapestPriceLabel
{
    CGFloat xPos = (WINSIZE.width/2-15)/2 + 5;
    CGFloat yPos = WINSIZE.width/2 + 90;
    sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, (WINSIZE.width/2-15)/2, 25)];
    [sellerNumButton setBackgroundColor:APP_COLOR_3];
    [sellerNumButton setTitle:@"$90" forState:UIControlStateNormal];
    sellerNumButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:sellerNumButton];
}

@end
