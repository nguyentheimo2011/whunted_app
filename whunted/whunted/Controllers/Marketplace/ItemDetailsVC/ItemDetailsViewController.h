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

@class ItemDetailsViewController;

@protocol ItemDetailsViewControllerDelegate <NSObject>

- (void) itemDetailsViewController: (ItemDetailsViewController *) controller didCompleteOffer: (BOOL) completed;

@end

@interface ItemDetailsViewController : UIViewController<UIPageViewControllerDataSource, SellerOfferViewControllerDelegate>

@property (nonatomic, weak) id<ItemDetailsViewControllerDelegate> delegate;

@property (nonatomic, strong) UIPageViewController  *pageViewController;
@property (nonatomic, strong) WantData              *wantData;
@property (nonatomic)         NSInteger             itemImagesNum;
@property (nonatomic, strong) UILabel               *itemNameLabel;
@property (nonatomic, strong) UILabel               *postedTimestampLabel;
@property (nonatomic, strong) UIButton              *buyerUsernameButton;
@property (nonatomic, strong) UILabel               *demandedPriceLabel;
@property (nonatomic, strong) UILabel               *locationLabel;
@property (nonatomic, strong) UILabel               *itemDescLabel;
@property (nonatomic, strong) UILabel               *productOriginLabel;
@property (nonatomic, strong) UILabel               *paymentMethodLabel;
@property (nonatomic, strong) UILabel               *sellersLabel;
@property (nonatomic, strong) UIButton              *secondBottomButton;
@property (nonatomic)         BOOL                  offeredByCurrUser;
@property (nonatomic)         PFObject              *offerPFObject;

@end
