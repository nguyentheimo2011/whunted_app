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

@synthesize itemNameLabel = _itemNameLabel;
@synthesize demandedPriceLabel = _demandedPriceLabel;
@synthesize buyerUsernameLabel = _buyerUsernameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize sellerNumButton = _sellerNumButton;
@synthesize likeButton = _likeButton;
@synthesize buyerProfilePic = _buyerProfilePic;
@synthesize itemImageView = _itemImageView;
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
    _likesNum = 124;
}

#pragma mark - Setters

//------------------------------------------------------------------------------------------------------------------------------
- (void) setWantData:(WantData *)wantData
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData = wantData;
    
    [_itemNameLabel setText:_wantData.itemName];
    [_demandedPriceLabel setText:_wantData.demandedPrice];
    [_buyerUsernameLabel setText:_wantData.buyer.objectId];
    
    NSString *text;
    if (_wantData.sellersNum <= 1) {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"seller", nil)];
    } else {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"sellers", nil)];
    }
    
    [_sellerNumButton setTitle:text forState:UIControlStateNormal];
    
    _itemImageView.image = nil;
    NSString *fileName = [NSString stringWithFormat:@"item_%@.jpg", _wantData.itemID];
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists) {
        [_itemImageView hnk_setImageFromFile:path];
    } else {
        [self downloadImageAndSaveLocally:path];
    }
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeCell
//------------------------------------------------------------------------------------------------------------------------------
{
    [self setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]];
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
    [_itemNameLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:15]];
    [self addSubview:_itemNameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPriceLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat yPos = _cellWidth + 35;
    _demandedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, yPos, WINSIZE.width/2-15, 15)];
    [_demandedPriceLabel setText:@"Item price"];
    [_demandedPriceLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:15]];
    [_demandedPriceLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_demandedPriceLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerProfilePic
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat yPos = _cellWidth + 60;
    _buyerProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(5, yPos, 30, 30)];
    [_buyerProfilePic setBackgroundColor:LIGHTEST_GRAY_COLOR];
    _buyerProfilePic.layer.cornerRadius = 13;
    [self addSubview:_buyerProfilePic];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerUsername
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat xPos = 45;
    CGFloat yPos = _cellWidth + 60;
    _buyerUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, WINSIZE.width/2-55, 15)];
    [_buyerUsernameLabel setText:@"Username"];
    [_buyerUsernameLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:14]];
    [_buyerUsernameLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_buyerUsernameLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addTimestampLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat xPos = 45;
    CGFloat yPos = _cellWidth + 75;
    _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, WINSIZE.width/2-55, 15)];
    [_timestampLabel setText:@"timestamp"];
    [_timestampLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:14]];
    [_timestampLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_timestampLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSellerNumButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat yPos = _cellWidth + 100;
    _sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, _cellWidth/2, 25)];
    [_sellerNumButton setBackgroundColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0]];
    [_sellerNumButton setTitle:[NSString stringWithFormat: @"0 %@", NSLocalizedString(@"seller", nil)] forState:UIControlStateNormal];
    _sellerNumButton.titleLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    [self addSubview:_sellerNumButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLikeButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat xPos = _cellWidth/2;
    CGFloat yPos = _cellWidth + 100;
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, _cellWidth/2, 25)];
    [_likeButton setBackgroundColor:LIGHT_GRAY_COLOR];
    [_likeButton addTarget:self action:@selector(likeButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, -1.5, 28, 28)];
    [_likeImageView setImage:[UIImage imageNamed:@"heart_white.png"]];
    [_likeButton addSubview:_likeImageView];
    
    _likesNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, _cellWidth/2 - 40, 15)];
    [_likesNumLabel setText:[NSString stringWithFormat:@"%ld", (long)_likesNum]];
    [_likesNumLabel setTextColor:[UIColor whiteColor]];
    [_likesNumLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) downloadImageAndSaveLocally: (NSString *) path
//------------------------------------------------------------------------------------------------------------------------------
{
    PFRelation *picRelation = _wantData.itemPictureList;
    [[picRelation query] getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error) {
        if (!error) {
            PFFile *firstPicture = firstObject[@"itemPicture"];
            [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2) {
                if (!error_2) {
                    UIImage *image = [UIImage imageWithData:data];
                    NSData *data = UIImageJPEGRepresentation(image, 1);
                    [data writeToFile:path atomically:YES];
                    [_itemImageView setImage:image];
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
