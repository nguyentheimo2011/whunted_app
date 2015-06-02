//
//  MarketplaceCollectionViewCell.h
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketplaceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *demandedPriceLabel;
@property (nonatomic, strong) UILabel *buyerUsernameLabel;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UIButton *sellerNumButton;
@property (nonatomic, strong) UILabel *cheapestPriceLabel;
@property (nonatomic, strong) UIImageView *buyerProfilePic;
@property (nonatomic, strong) UIImageView *itemImageView;

- (void) initCell;

@end
