//
//  SellTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellTableViewCell.h"
#import "Utilities.h"

@implementation SellTableViewCell

@synthesize delegate;
@synthesize wantData;
@synthesize itemImageView;
@synthesize viewsNumLabel;
@synthesize likesNumLabel;
@synthesize itemNameLabel;
@synthesize lowestOfferedPriceLabel;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self addItemImageView];
        [self addViewNumberSection];
        [self addLikesSection];
        [self addPromotionSection];
        [self addItemNameLabel];
        [self addLowestOfferedPrice];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void) addItemImageView
{
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, WINSIZE.width-20, WINSIZE.width-20)];
    [itemImageView setBackgroundColor:APP_COLOR_2];
    [self addSubview:itemImageView];
    [itemImageView hnk_cancelSetImage];
    itemImageView.image = nil;
}

- (void) addViewNumberSection
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, WINSIZE.width-10, itemImageWidth/3, itemImageWidth/8)];
    [view setBackgroundColor:APP_COLOR_3];
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

- (void) addLikesSection
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + itemImageWidth/3, WINSIZE.width-10, itemImageWidth/3, itemImageWidth/8)];
    [view setBackgroundColor:APP_COLOR_3];
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

- (void) addPromotionSection
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + 2 * itemImageWidth/3, WINSIZE.width-10, itemImageWidth/3, itemImageWidth/8)];
    [view setBackgroundColor:APP_COLOR_3];
    [self addSubview:view];
    
    UIButton *promotionButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, itemImageWidth/4, itemImageWidth/8)];
    [promotionButton setTitle:@"Promote" forState:UIControlStateNormal];
    [promotionButton setEnabled:YES];
    [view addSubview:promotionButton];
}

- (void) addItemNameLabel
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    CGFloat yPos = itemImageWidth * 7.0/6 + 5;
    itemNameLabel = [[UILabel alloc] init];
    itemNameLabel.frame = CGRectMake(10, yPos, itemImageWidth, 20);
    [itemNameLabel setText:@"Item Name"];
    [itemNameLabel setTextColor:[UIColor grayColor]];
    [itemNameLabel setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:itemNameLabel];
}

- (void) addLowestOfferedPrice
{
    CGFloat itemImageWidth = WINSIZE.width-20;
    CGFloat yPos = itemImageWidth * 7.0/6 + 35;
    lowestOfferedPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos, 150, 15)];
    [lowestOfferedPriceLabel setText:@"Lowest offered: $90"];
    [lowestOfferedPriceLabel setTextColor:[UIColor grayColor]];
    [lowestOfferedPriceLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:lowestOfferedPriceLabel];
}

#pragma mark - Event Handlers
- (void) likeButtonClicked
{
    NSLog(@"likeButtonClicked");
}

- (void) sellerNumButtonClickedHandler
{
    [delegate sellTableViewCell:self didClickSellersNumButton:wantData];
}

@end
