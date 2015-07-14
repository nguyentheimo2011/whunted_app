//
//  HistoryCollectionViewCell.h
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Haneke/UIImageView+Haneke.h>
#import "WantData.h"

@interface HistoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *demandedPriceLabel;
@property (nonatomic, strong) UIButton *sellerNumButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIImageView *itemImageView;

@property (nonatomic, strong) WantData *wantData;

- (void) initCell;

@end
