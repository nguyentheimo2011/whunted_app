//
//  WantTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 29/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WantTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *viewsNumLabel;
@property (nonatomic, strong) UILabel *likesNumLabel;
@property (nonatomic, strong) UILabel *itemNameLabel;

@end
