//
//  SellerListCell.m
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellerListCell.h"
#import "Utilities.h"

@implementation SellerListCell

@synthesize delegate;
@synthesize offerData;
@synthesize profilePicButton;
@synthesize sellerUsernameButton;
@synthesize sellersOfferedPrice;
@synthesize sellersOfferedDelivery;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self addProfilePicButton];
        [self addSellerUsername];
        [self addSellersOfferedPrice];
        [self addSellersOfferedDelivery];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) addButtonsIfNotAccepted
{
    [self addChatWithSellerButton];
    [self addAcceptButton];
}

- (void) addProfilePicButton
{
    profilePicButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 50, 50)];
    profilePicButton.layer.cornerRadius = 22;
    [profilePicButton setBackgroundImage:[UIImage imageNamed:@"userprofile.png"] forState:UIControlStateNormal];
    [self addSubview:profilePicButton];
}

- (void) addSellerUsername
{
    sellerUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(95, 10, 120, 20)];
    [sellerUsernameButton setTitle:@"seller " forState:UIControlStateNormal];
    [sellerUsernameButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sellerUsernameButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    sellerUsernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:sellerUsernameButton];
}

- (void) addSellersOfferedPrice
{
    sellersOfferedPrice = [[UILabel alloc] initWithFrame:CGRectMake(95, 30, 100, 20)];
    [sellersOfferedPrice setText:@"$90"];
    [sellersOfferedPrice setTextColor:[UIColor grayColor]];
    [sellersOfferedPrice setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:sellersOfferedPrice];
}

- (void) addSellersOfferedDelivery
{
    sellersOfferedDelivery = [[UILabel alloc] initWithFrame:CGRectMake(95, 50, 120, 20)];
    [sellersOfferedDelivery setText:@"Delivery: 2 weeks"];
    [sellersOfferedDelivery setTextColor:[UIColor grayColor]];
    [sellersOfferedDelivery setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:sellersOfferedDelivery];
}

- (void) addChatWithSellerButton
{
    UIButton *chatWithSellerButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width - 90, 30, 25, 25)];
    [chatWithSellerButton setBackgroundImage:[UIImage imageNamed:@"chat_with_seller.png"] forState:UIControlStateNormal];
    [self addSubview:chatWithSellerButton];
}

- (void) addAcceptButton
{
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width - 50, 30, 25, 25)];
    [acceptButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(acceptButtonCLickedHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptButton];
}

- (void) acceptButtonCLickedHandler
{
    [self.delegate sellerListCell:self didAcceptOfferFromSeller:offerData];
}

@end
