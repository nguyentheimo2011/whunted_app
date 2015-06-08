//
//  WantTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 29/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Haneke/UIImageView+Haneke.h>
#import "WantData.h"

@class WantTableViewCell;

@protocol WantTableViewCellDelegate <NSObject>

- (void) wantTableViewCell: (WantTableViewCell *) cell didClickSellersNumButton: (WantData *) wantData;

@end

@interface WantTableViewCell : UITableViewCell

@property (nonatomic, strong) id<WantTableViewCellDelegate> delegate;

@property (nonatomic, strong) WantData *wantData;
@property (nonatomic) NSInteger sellersNum;

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *viewsNumLabel;
@property (nonatomic, strong) UILabel *likesNumLabel;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *lowestOfferedPriceLabel;
@property (nonatomic, strong) UIButton *sellersNumButton;
@property (nonatomic, strong) UILabel *acceptedStatusLabel;

- (void) addAcceptedStatusLabel;
- (void) removeAcceptedStatusLabel;

@end
