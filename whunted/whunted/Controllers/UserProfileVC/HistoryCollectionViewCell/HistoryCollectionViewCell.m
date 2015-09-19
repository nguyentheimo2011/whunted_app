//
//  HistoryCollectionViewCell.m
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "HistoryCollectionViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "ItemImageCache.h"

#define     kCellLeftMagin              4.0f
#define     kCellRightMargin            4.0f

@implementation HistoryCollectionViewCell
{
    UILabel         *_itemNameLabel;
    UILabel         *_demandedPriceLabel;
    UIButton        *_sellerNumButton;
    UIButton        *_likeButton;
    UIImageView     *_itemImageView;
    
    UILabel         *_boughtOrSoldLabel;
    
    UIView          *_likesNumContainer;
    
    UIImageView     *_likeImageView;
    UILabel         *_likesNumLabel;
    
    CGFloat         _cellWidth;
    CGFloat         _cellHeight;
    NSInteger       _likesNum;
    BOOL            _likedByMe;
}


@synthesize wantData        =   _wantData;
@synthesize cellIndex       =   _cellIndex;

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

//------------------------------------------------------------------------------------------------------------------------------
- (void) clearCellUI
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData = nil;
}


#pragma mark - Setters

//------------------------------------------------------------------------------------------------------------------------------
- (void) setWantData:(WantData *)wantData
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData = wantData;
    
    [_itemNameLabel setText:_wantData.itemName];
    [_demandedPriceLabel setText:_wantData.demandedPrice];
    
    NSString *text;
    if (_wantData.sellersNum <= 1)
    {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"seller", nil)];
    } else {
        text = [NSString stringWithFormat:@"%ld %@", (long)_wantData.sellersNum, NSLocalizedString(@"sellers", nil)];
    }
    
    [_sellerNumButton setTitle:text forState:UIControlStateNormal];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", _wantData.itemID, ITEM_FIRST_IMAGE];
    _itemImageView.image = [[ItemImageCache sharedCache] objectForKey:key];
    
    if (!_itemImageView.image)
        [self downloadItemImage];
    
    if (_wantData.isFulfilled)
        _boughtOrSoldLabel.hidden = NO;
    else
        _boughtOrSoldLabel.hidden = YES;
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeCell
//------------------------------------------------------------------------------------------------------------------------------
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    
    self.layer.cornerRadius = 5.0f;
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
    [self addSubview:_itemImageView];
    
    _itemImageView.layer.borderWidth = 0.5f;
    _itemImageView.layer.borderColor = [LIGHT_GRAY_COLOR CGColor];
    
    _itemImageView.image = nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addBoughtOrSoldLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _boughtOrSoldLabel = [[UILabel alloc] init];
    _boughtOrSoldLabel.text = NSLocalizedString(@"Bought", nil);
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
- (void) addLikeButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kButtonXPos   =   0;
    CGFloat const kButtonYPos   =   _cellWidth + 60.0f;
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
    CGFloat const kXPos = _cellWidth/2 - 0.5f;
    CGFloat const kYPos = _cellWidth + 60;
    CGFloat const kButtonHeight = 25;
    
    _sellerNumButton = [[UIButton alloc] initWithFrame:CGRectMake(kXPos, kYPos, _cellWidth/2 + 0.5f, kButtonHeight)];
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
    __block NSInteger cellIndex = _cellIndex;
    
    PFRelation *picRelation = _wantData.itemPictureList;
    PFQuery *query = [picRelation query];
    [query orderByAscending:PF_CREATED_AT];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *firstObject, NSError *error)
    {
        if (!error)
        {
            PFFile *firstPicture = firstObject[@"itemPicture"];
            [firstPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error_2) {
                if (!error_2)
                {
                    if (cellIndex == _cellIndex)
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

@end
