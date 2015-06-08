//
//  SellTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 8/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Haneke/UIImageView+Haneke.h>
#import "WantData.h"

@class SellTableViewCell;

@protocol SellTableViewCellDelegate <NSObject>

- (void) sellTableViewCell: (SellTableViewCell *) cell didClickSellersNumButton: (WantData *) wantData;

@end

@interface SellTableViewCell : UITableViewCell

@property (nonatomic, strong) id<SellTableViewCellDelegate> delegate;

@property (nonatomic, strong) WantData *wantData;

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *viewsNumLabel;
@property (nonatomic, strong) UILabel *likesNumLabel;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *lowestOfferedPriceLabel;
@property (nonatomic, strong) UILabel *yourOfferLabel;

@end
