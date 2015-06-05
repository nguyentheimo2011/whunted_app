//
//  SellerListCell.h
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellersOfferData.h"

@class SellerListCell;

@protocol SellerListCellDelegate <NSObject>

- (void) sellerListCell: (SellerListCell *) cell didAcceptOfferFromSeller: (SellersOfferData *) offerData;

@end

@interface SellerListCell : UITableViewCell

@property (nonatomic, weak) id<SellerListCellDelegate> delegate;

@property (nonatomic, strong) SellersOfferData *offerData;

@property (nonatomic, strong) UIButton *profilePicButton;
@property (nonatomic, strong) UIButton *sellerUsernameButton;
@property (nonatomic, strong) UILabel *sellersOfferedPrice;
@property (nonatomic, strong) UILabel *sellersOfferedDelivery;

- (void) addButtonsIfNotAccepted;

@end
