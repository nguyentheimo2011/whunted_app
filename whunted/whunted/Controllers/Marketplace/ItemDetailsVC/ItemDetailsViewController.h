//
//  ItemDetailsViewController.h
//  whunted
//
//  Created by thomas nguyen on 2/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WantData.h"
#import "BuyersOrSellersOfferViewController.h"
#import "TransactionData.h"
#import "EditWantDataVC.h"

#import <JTImageButton.h>

@class ItemDetailsViewController;

//------------------------------------------------------------------------------------------------------------------------------
@protocol ItemDetailsViewControllerDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

- (void) itemDetailsViewController: (ItemDetailsViewController *) controller didCompleteOffer: (BOOL) completed;


@end

//------------------------------------------------------------------------------------------------------------------------------
@interface ItemDetailsViewController : UIViewController<UIPageViewControllerDataSource, BuyersOrSellerOfferDelegate>
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak) id<ItemDetailsViewControllerDelegate> delegate;

@property (nonatomic, strong) WantData              *wantData;
@property (nonatomic)         NSInteger             itemImagesNum;

@property (nonatomic)         TransactionData       *currOffer;

@end
