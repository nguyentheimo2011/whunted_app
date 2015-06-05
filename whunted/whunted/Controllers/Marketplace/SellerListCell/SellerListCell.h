//
//  SellerListCell.h
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerListCell : UITableViewCell

@property (nonatomic, strong) UIButton *profilePicButton;
@property (nonatomic, strong) UIButton *sellerUsernameButton;
@property (nonatomic, strong) UILabel *sellersOfferedPrice;
@property (nonatomic, strong) UILabel *sellersOfferedDelivery;

@end
