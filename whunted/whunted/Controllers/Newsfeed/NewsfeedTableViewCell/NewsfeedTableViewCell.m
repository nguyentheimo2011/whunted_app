//
//  NewsfeedTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 2/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "NewsfeedTableViewCell.h"
#import "AppConstant.h"


@implementation NewsfeedTableViewCell
{
    UIView              *_cellContainer;
    
    UIImageView         *_itemImageView;
    UIImageView         *_buyerProfileImageView;
    
    UILabel             *_itemNameLabel;
    UILabel             *_initialPriceLabel;
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
    _initialPriceLabel.backgroundColor = FLAT_FRESH_RED_COLOR;
    _initialPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_initialPriceLabel sizeToFit];
    
    CGFloat const kLabelWidth   =   MIN(_initialPriceLabel.frame.size.width + 10.0f, kLabelMaxWidth);
    CGFloat const kLabelOriginX =   WINSIZE.width - kLabelWidth - kLabelRightMargin;
    _initialPriceLabel.frame = CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight);
    [_itemImageView addSubview:_initialPriceLabel];
}


@end
