//
//  SellTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellTableViewCell.h"
#import "AppConstant.h"

@implementation SellTableViewCell

@synthesize delegate;
@synthesize wantData;
@synthesize itemImageView;
@synthesize viewsNumLabel;
@synthesize likesNumLabel;
@synthesize itemNameLabel;
@synthesize lowestOfferedPriceLabel;
@synthesize yourOfferLabel;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self addItemImageView];
        [self addViewNumberSection];
        [self addLikesSection];
        [self addPromotionSection];
        [self addItemNameLabel];
        [self addLowestOfferedPrice];
        [self addYourOfferLabel];
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super setSelected:selected animated:animated];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView
//-------------------------------------------------------------------------------------------------------------------------------
{
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, WINSIZE.width-20, WINSIZE.width-20)];
    [itemImageView setBackgroundColor:BACKGROUND_GRAY_COLOR];
    [self addSubview:itemImageView];
    itemImageView.image = nil;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addViewNumberSection
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, WINSIZE.width-10, itemImageWidth/3, itemImageWidth/8)];
    [view setBackgroundColor:LIGHT_GRAY_COLOR];
    [self addSubview:view];
    
    viewsNumLabel = [[UILabel alloc] init];
    [viewsNumLabel setText:@"300"];
    viewsNumLabel.frame = CGRectMake(20, itemImageWidth/80, itemImageWidth/6, itemImageWidth/10);
    [view addSubview:viewsNumLabel];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *eyeImage = [UIImage imageNamed:@"view_icon.png"];
    imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    imageView.frame = CGRectMake(itemImageWidth/5, itemImageWidth/60, itemImageWidth/12, itemImageWidth/12);
    [imageView setImage:eyeImage];
    [view addSubview:imageView];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addLikesSection
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + itemImageWidth/3, WINSIZE.width-10, itemImageWidth/3, itemImageWidth/8)];
    [view setBackgroundColor:LIGHT_GRAY_COLOR];
    [self addSubview:view];
    
    likesNumLabel = [[UILabel alloc] init];
    [likesNumLabel setText:@"200"];
    likesNumLabel.frame = CGRectMake(20, itemImageWidth/80, itemImageWidth/6, itemImageWidth/10);
    [view addSubview:likesNumLabel];
    
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(itemImageWidth/5, itemImageWidth/40, itemImageWidth/16, itemImageWidth/16)];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"likes_icon.png"] forState:UIControlStateNormal];
    [likeButton setEnabled:YES];
    [likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:likeButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addPromotionSection
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + 2 * itemImageWidth/3, WINSIZE.width-10, itemImageWidth/3, itemImageWidth/8)];
    [view setBackgroundColor:LIGHT_GRAY_COLOR];
    [self addSubview:view];
    
    UIButton *promotionButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, itemImageWidth/4, itemImageWidth/8)];
    [promotionButton setTitle:NSLocalizedString(@"Promote", nil) forState:UIControlStateNormal];
    [promotionButton setEnabled:YES];
    [view addSubview:promotionButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addItemNameLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    CGFloat yPos = itemImageWidth * 7.0/6 + 5;
    itemNameLabel = [[UILabel alloc] init];
    itemNameLabel.frame = CGRectMake(10, yPos, itemImageWidth, 20);
    [itemNameLabel setText:@"Item Name"];
    [itemNameLabel setTextColor:[UIColor grayColor]];
    [itemNameLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:17]];
    [self addSubview:itemNameLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addLowestOfferedPrice
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    CGFloat yPos = itemImageWidth * 7.0/6 + 35;
    lowestOfferedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos, 200, 15)];
    [lowestOfferedPriceLabel setText:[NSString stringWithFormat:@"%@: TWD90", NSLocalizedString(@"Lowest offer", nil)]];
    [lowestOfferedPriceLabel setTextColor:[UIColor grayColor]];
    [lowestOfferedPriceLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self addSubview:lowestOfferedPriceLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addYourOfferLabel
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    CGFloat yPos = itemImageWidth * 7.0/6 + 60;
    yourOfferLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos, 200, 15)];
    [yourOfferLabel setText:[NSString stringWithFormat:@"%@: TWD90", NSLocalizedString(@"Lowest offer", nil)]];
    [yourOfferLabel setTextColor:[UIColor grayColor]];
    [yourOfferLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self addSubview:yourOfferLabel];
}

#pragma mark - Event Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) likeButtonClicked
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"likeButtonClicked");
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) sellerNumButtonClickedHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [delegate sellTableViewCell:self didClickSellersNumButton:wantData];
}

@end

