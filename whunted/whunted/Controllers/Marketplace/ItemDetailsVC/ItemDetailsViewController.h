//
//  ItemDetailsViewController.h
//  whunted
//
//  Created by thomas nguyen on 2/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Haneke/UIImageView+Haneke.h>
#import "WantData.h"
#import "SellersOfferViewController.h"

@interface ItemDetailsViewController : UIViewController<UIPageViewControllerDataSource, SellerOfferViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) WantData *wantData;
@property (nonatomic) NSInteger itemImagesNum;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *postedTimestampLabel;
@property (nonatomic, strong) UIButton *buyerUsernameButton;
@property (nonatomic, strong) UILabel *demandedPriceLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *itemDescLabel;
@property (nonatomic, strong) UIButton *secondBottomButton;
@property (nonatomic) BOOL offeredByCurrUser;
@property (nonatomic) PFObject *offerPFObject;

@end
