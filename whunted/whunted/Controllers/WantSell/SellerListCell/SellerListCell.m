//
//  SellerListCell.m
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellerListCell.h"
#import "AppConstant.h"

@implementation SellerListCell

@synthesize delegate = _delegate;
@synthesize offerData = _offerData;
@synthesize profilePicButton = _profilePicButton;
@synthesize sellerUsernameButton = _sellerUsernameButton;
@synthesize sellersOfferedPrice = _sellersOfferedPrice;
@synthesize sellersOfferedDelivery = _sellersOfferedDelivery;

//-------------------------------------------------------------------------------------------------------------------------------
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil) {
        [self addProfilePicButton];
        [self addSellerUsername];
        [self addSellersOfferedPrice];
        [self addSellersOfferedDelivery];
        [self addChatWithSellerButton];
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
- (void) addButtonsIfNotAccepted
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addAcceptButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addProfilePicButton
//-------------------------------------------------------------------------------------------------------------------------------
{
    _profilePicButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 50, 50)];
    _profilePicButton.layer.cornerRadius = 22;
    [_profilePicButton setBackgroundImage:[UIImage imageNamed:@"userprofile.png"] forState:UIControlStateNormal];
    [self addSubview:_profilePicButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSellerUsername
//-------------------------------------------------------------------------------------------------------------------------------
{
    _sellerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(95, 10, 120, 20)];
    [_sellerUsernameButton setTitle:@"seller " forState:UIControlStateNormal];
    [_sellerUsernameButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_sellerUsernameButton.titleLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    _sellerUsernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_sellerUsernameButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSellersOfferedPrice
//-------------------------------------------------------------------------------------------------------------------------------
{
    _sellersOfferedPrice = [[UILabel alloc] initWithFrame:CGRectMake(95, 30, 100, 20)];
    [_sellersOfferedPrice setText:@"$90"];
    [_sellersOfferedPrice setTextColor:[UIColor grayColor]];
    [_sellersOfferedPrice setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [self addSubview:_sellersOfferedPrice];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addSellersOfferedDelivery
//-------------------------------------------------------------------------------------------------------------------------------
{
    _sellersOfferedDelivery = [[UILabel alloc] initWithFrame:CGRectMake(95, 50, 120, 20)];
    [_sellersOfferedDelivery setText:@"Delivery: 2 weeks"];
    [_sellersOfferedDelivery setTextColor:[UIColor grayColor]];
    [_sellersOfferedDelivery setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:14]];
    [self addSubview:_sellersOfferedDelivery];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addChatWithSellerButton
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *chatWithSellerButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width - 90, 30, 25, 25)];
    [chatWithSellerButton setBackgroundImage:[UIImage imageNamed:@"chat_with_seller.png"] forState:UIControlStateNormal];
    [self addSubview:chatWithSellerButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addAcceptButton
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width - 50, 30, 25, 25)];
    [acceptButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(acceptButtonCLickedHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptButton];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) acceptButtonCLickedHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [_delegate sellerListCell:self didAcceptOfferFromSeller:_offerData];
}

@end
