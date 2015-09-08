//
//  NewsfeedTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 2/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "NewsfeedTableViewCell.h"
#import "WantData.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "TemporaryCache.h"

#import <JTImageButton.h>


@implementation NewsfeedTableViewCell
{
    UIView              *_cellContainer;
    
    UIImageView         *_itemImageView;
    UIImageView         *_buyerProfileImageView;
    UIImageView         *_sellerProfileImageView;
    
    UILabel             *_itemNameLabel;
    UILabel             *_initialPriceLabel;
    UILabel             *_productOriginLabel;
    UILabel             *_meetingLocationLabel;
    
    JTImageButton       *_whuntButton;
}

@synthesize transactionData     =   _transactionData;


#pragma mark - Setters

//-----------------------------------------------------------------------------------------------------------------------------
- (void) setTransactionData:(TransactionData *)transactionData
//-----------------------------------------------------------------------------------------------------------------------------
{
    _transactionData = transactionData;
    
    _itemNameLabel.text = transactionData.itemName;
    [self setTextForInitialPriceLabel:transactionData.originalDemandedPrice];
    
    [self retrieveItemInfo];
    [self setProfileImages];
}


#pragma mark - UI Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [self addCellContainer];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addCellContainer
//-----------------------------------------------------------------------------------------------------------------------------
{
    _cellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, NEWSFEED_CELL_HEIGHT)];
    [self addSubview:_cellContainer];
    
    [self addItemImageView];
    [self addBuyerProfileImageView];
    [self addItemNameLabel];
    [self addInitialPriceLabel];
    [self addWhuntButton];
    [self addSellerProfileImageView];
    [self addProductOriginUI];
    [self addMeetingLocationUI];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewWidth   =   WINSIZE.width;
    CGFloat const kImageViewHeight  =   WINSIZE.width;
    CGFloat const kImageViewOriginY =   35.0f;
    
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    _itemImageView.backgroundColor = WHITE_GRAY_COLOR;
    [_cellContainer addSubview:_itemImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerProfileImageView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewWidth   =   50.0f;
    CGFloat const kImageViewHeight  =   50.0f;
    CGFloat const kImageViewOriginX =   15.0f;
    CGFloat const kImageViewOriginY =   15.0f;
    
    _buyerProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    _buyerProfileImageView.backgroundColor = VIVID_SKY_BLUE_COLOR;
    _buyerProfileImageView.layer.cornerRadius = kImageViewHeight/2;
    _buyerProfileImageView.clipsToBounds = YES;
    [_cellContainer addSubview:_buyerProfileImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX     =   _buyerProfileImageView.frame.origin.x + _buyerProfileImageView.frame.size.width + 5.0f;
    CGFloat const kLabelOriginY     =   12.0f;
    CGFloat const kLabelWidth       =   WINSIZE.width - kLabelOriginX - 20.0f;
    CGFloat const kLabelHeight      =   20.0f;
    
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _itemNameLabel.text = @"Item Name";
    _itemNameLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _itemNameLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_cellContainer addSubview:_itemNameLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addInitialPriceLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelRightMargin     =   10.0f;
    CGFloat const kLabelBottomMargin    =   10.0f;
    CGFloat const kLabelMaxWidth        =   WINSIZE.width/2 - kLabelRightMargin;
    CGFloat const kLabelHeight          =   25.0f;
    CGFloat const kLabelOriginY         =   _itemImageView.frame.size.height - kLabelHeight - kLabelBottomMargin;
    
    _initialPriceLabel = [[UILabel alloc] init];
    _initialPriceLabel.text = @"";
    _initialPriceLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _initialPriceLabel.textColor = [UIColor whiteColor];
    _initialPriceLabel.backgroundColor = STAR_COMMAND_BLUE;
    _initialPriceLabel.textAlignment = NSTextAlignmentCenter;
    _initialPriceLabel.layer.cornerRadius = 5.0f;
    _initialPriceLabel.clipsToBounds = YES;
    [_initialPriceLabel sizeToFit];
    
    CGFloat const kLabelWidth   =   MIN(_initialPriceLabel.frame.size.width + 10.0f, kLabelMaxWidth);
    CGFloat const kLabelOriginX =   WINSIZE.width - kLabelWidth - kLabelRightMargin;
    _initialPriceLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight);
    [_itemImageView addSubview:_initialPriceLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addSeparatorBelowItemImage
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kSeparatorOriginY = _itemImageView.frame.origin.y + _itemImageView.frame.size.height;
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, kSeparatorOriginY, WINSIZE.width, 0.5f)];
    separatorLine.backgroundColor = LIGHTER_GRAY_COLOR;
    [_cellContainer addSubview:separatorLine];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addSeparatorBetweenCells
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kSeparatorOriginY = _cellContainer.frame.size.height - 1.0f;
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(15.0f, kSeparatorOriginY, WINSIZE.width-30.0f, 0.5f)];
    separatorLine.backgroundColor = LIGHTER_GRAY_COLOR;
    [_cellContainer addSubview:separatorLine];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addWhuntButton
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonWidth      =   90.0f;
    CGFloat const kButtonHeight     =   40.0f;
    CGFloat const kButtonOriginX    =   WINSIZE.width - kButtonWidth - 10.0f;
    CGFloat const kButtonOriginY    =   _itemImageView.frame.origin.y + _itemImageView.frame.size.height + 10.0f;
    
    _whuntButton = [[JTImageButton alloc] initWithFrame:CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight)];
    [_whuntButton createTitle:NSLocalizedString(@"WHUNT!", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE] iconHeight:0 iconOffsetY:0];
    _whuntButton.titleColor = [UIColor whiteColor];
    _whuntButton.bgColor = FLAT_FRESH_RED_COLOR;
    _whuntButton.borderWidth = 0.5f;
    _whuntButton.borderColor = FLAT_FRESH_RED_COLOR;
    _whuntButton.cornerRadius = 8.0f;
    _whuntButton.clipsToBounds = YES;
    [_cellContainer addSubview:_whuntButton];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addSellerProfileImageView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewWidth   =   50.0f;
    CGFloat const kImageViewHeight  =   50.0f;
    CGFloat       kImageViewOriginX =   _whuntButton.frame.origin.x - kImageViewWidth - 20.0f;
    CGFloat const kImageViewOriginY =   _whuntButton.frame.origin.y - 5.0f;
    
    if (WINSIZE.width == 320)
        kImageViewOriginX += 10.0f;
    
    _sellerProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    _sellerProfileImageView.layer.cornerRadius = kImageViewHeight/2;
    _sellerProfileImageView.clipsToBounds = YES;
    _sellerProfileImageView.backgroundColor = JASMINE_YELLOW_COLOR;
    [_cellContainer addSubview:_sellerProfileImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addProductOriginUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewWidth   =   20.0f;
    CGFloat const kImageViewHeight  =   20.0f;
    CGFloat const kImageViewOriginX =   10.0f;
    CGFloat const kImageViewOriginY =   _whuntButton.frame.origin.y - 2.5f;
    
    UIImageView *productOriginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    productOriginImageView.image = [UIImage imageNamed:@"product_origin_icon.png"];
    [_cellContainer addSubview:productOriginImageView];
    
    CGFloat const kLabelOriginX =   kImageViewOriginX + kImageViewWidth + 5.0f;
    CGFloat const kLabelOriginY =   kImageViewOriginY;
    CGFloat const kLabelWidth   =   _sellerProfileImageView.frame.origin.x - 5.0f - kLabelOriginX;
    CGFloat const kLabelHeight  =   20.0f;
    
    _productOriginLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _productOriginLabel.text = @"London, England";
    _productOriginLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _productOriginLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_cellContainer addSubview:_productOriginLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addMeetingLocationUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewWidth   =   20.0f;
    CGFloat const kImageViewHeight  =   20.0f;
    CGFloat const kImageViewOriginX =   10.0f;
    CGFloat const kImageViewOriginY =   _whuntButton.frame.origin.y + 22.5f;
    
    UIImageView *productOriginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    productOriginImageView.image = [UIImage imageNamed:@"location_icon.png"];
    [_cellContainer addSubview:productOriginImageView];
    
    CGFloat const kLabelOriginX =   kImageViewOriginX + kImageViewWidth + 5.0f;
    CGFloat const kLabelOriginY =   kImageViewOriginY;
    CGFloat const kLabelWidth   =   _sellerProfileImageView.frame.origin.x - 5.0f - kLabelOriginX;
    CGFloat const kLabelHeight  =   20.0f;
    
    _meetingLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    _meetingLocationLabel.text = @"Taipei, Taiwan";
    _meetingLocationLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _meetingLocationLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [_cellContainer addSubview:_meetingLocationLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) setTextForInitialPriceLabel: (NSString *) text
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelRightMargin     =   10.0f;
    CGFloat const kLabelBottomMargin    =   10.0f;
    CGFloat const kLabelMaxWidth        =   WINSIZE.width/2 - kLabelRightMargin;
    CGFloat const kLabelHeight          =   25.0f;
    CGFloat const kLabelOriginY         =   _itemImageView.frame.size.height - kLabelHeight - kLabelBottomMargin;
    
    _initialPriceLabel.text = text;
    [_initialPriceLabel sizeToFit];
    
    CGFloat const kLabelWidth   =   MIN(_initialPriceLabel.frame.size.width + 10.0f, kLabelMaxWidth);
    CGFloat const kLabelOriginX =   WINSIZE.width - kLabelWidth - kLabelRightMargin;
    _initialPriceLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight);
    [_itemImageView addSubview:_initialPriceLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) setProfileImages
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *key = [NSString stringWithFormat:@"%@%@", _transactionData.buyerID, USER_PROFILE_IMAGE];
    UIImage *buyerImage = [[TemporaryCache sharedCache] objectForKey:key];
    
    if (buyerImage)
        _buyerProfileImageView.image = buyerImage;
    else {
        FetchedUserHandler handler = ^(PFUser *user, UIImage *image) {
            _buyerProfileImageView.image = image;
        };
        [Utilities getUserWithID:_transactionData.buyerID andRunBlock:handler];
    }
    
    key = [NSString stringWithFormat:@"%@%@", _transactionData.sellerID, USER_PROFILE_IMAGE];
    UIImage *sellerImage = [[TemporaryCache sharedCache] objectForKey:key];
    
    if (sellerImage)
        _sellerProfileImageView.image = sellerImage;
    else {
        FetchedUserHandler handler = ^(PFUser *user, UIImage *image) {
            _sellerProfileImageView.image = image;
        };
        [Utilities getUserWithID:_transactionData.sellerID andRunBlock:handler];
    }
}


#pragma mark - Backend

//-----------------------------------------------------------------------------------------------------------------------------
- (void) retrieveItemInfo
//-----------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query whereKey:PF_OBJECT_ID equalTo:_transactionData.itemID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error)
        {
            WantData *wantData = [[WantData alloc] initWithPFObject:object];
            _productOriginLabel.text = (wantData.itemOrigins.count > 0) ? [wantData.itemOrigins objectAtIndex:0] : @"";
            _meetingLocationLabel.text = wantData.meetingLocation;
            
            [self downloadItemImage:wantData];
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) downloadItemImage: (WantData *) wantData
//------------------------------------------------------------------------------------------------------------------------------
{
    PFRelation *picRelation = wantData.itemPictureList;
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
                    
                    NSString *key = [NSString stringWithFormat:@"%@%@", wantData.itemID, ITEM_FIRST_IMAGE];
                    [[TemporaryCache sharedCache] setObject:image forKey:key];
                }
                else
                {
                    NSLog(@"Error: %@ %@", error_2, [error_2 userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end
