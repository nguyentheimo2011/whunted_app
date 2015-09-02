//
//  SellersOfferViewController.h
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APNumberPad.h>
#import "TransactionData.h"

@class BuyersOrSellersOfferViewController;

//-------------------------------------------------------------------------------------------------------------------------------
@protocol BuyersOrSellerOfferDelegate <NSObject>
//-------------------------------------------------------------------------------------------------------------------------------

- (void) buyersOrSellersOfferViewController: (BuyersOrSellersOfferViewController *) controller didOffer: (TransactionData *) offer;

@end

//-------------------------------------------------------------------------------------------------------------------------------
@interface BuyersOrSellersOfferViewController : UIViewController <UITextFieldDelegate, APNumberPadDelegate>
//-------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak)     id<BuyersOrSellerOfferDelegate> delegate;

@property (nonatomic, strong) TransactionData *offerData;
@property (nonatomic, strong) NSString  *buyerName;
@property (nonatomic)         BOOL      isEditingOffer;

@property (nonatomic, strong) PFUser    *user2;

@property (nonatomic, strong) NSString  *offerFrom;

@end
