//
//  NewsfeedTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 2/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "NewsfeedTableViewCell.h"
#import "AppConstant.h"

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

//-----------------------------------------------------------------------------------------------------------------------------
- (id) initCellWithTransactionData:(TransactionData *)transactionData
//-----------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self)
    {
        _transactionData = transactionData;
        
        [self addCellContainer];
    }
    
    return self;
}


#pragma mark - UI Handlers

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
    [self addSeparatorBelowItemImage];
    [self addSeparatorBetweenCells];
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
    CGFloat const kImageViewOriginY =   30.0f;
    
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    _itemImageView.backgroundColor = LIGHTEST_GRAY_COLOR;
    [_cellContainer addSubview:_itemImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addBuyerProfileImageView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kImageViewWidth   =   50.0f;
    CGFloat const kImageViewHeight  =   50.0f;
    CGFloat const kImageViewOriginX =   15.0f;
    CGFloat const kImageViewOriginY =   10.0f;
    
    _buyerProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewOriginX, kImageViewOriginY, kImageViewWidth, kImageViewHeight)];
    _buyerProfileImageView.backgroundColor = VIVID_SKY_BLUE_COLOR;
    _buyerProfileImageView.layer.cornerRadius = kImageViewHeight/2;
    [_cellContainer addSubview:_buyerProfileImageView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelOriginX     =   _buyerProfileImageView.frame.origin.x + _buyerProfileImageView.frame.size.width + 5.0f;
    CGFloat const kLabelOriginY     =   7.0f;
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
    _initialPriceLabel.text = @"TWD 20,000";
    _initialPriceLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _initialPriceLabel.textColor = [UIColor whiteColor];
    _initialPriceLabel.backgroundColor = STAR_COMMAND_BLUE;
    _initialPriceLabel.textAlignment = NSTextAlignmentCenter;
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


@end
