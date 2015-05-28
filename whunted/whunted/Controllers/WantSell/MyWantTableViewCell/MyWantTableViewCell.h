//
//  MyWantTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 22/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"

@interface MyWantTableViewCell : UITableViewCell

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) WantData *wantData;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (weak, nonatomic) IBOutlet UILabel *viewsNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *likesNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *lowestPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellersNumLabel;

- (IBAction)likeButtonClicked:(UIButton *)sender;

- (IBAction)promotionButtonClicked:(UIButton *)sender;

- (IBAction)sellerButtonClicked:(UIButton *)sender;

@end
