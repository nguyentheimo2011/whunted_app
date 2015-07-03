//
//  SellersOfferViewController.h
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APNumberPad.h>
#import "WantData.h"

@class BuyersOrSellersOfferViewController;

@protocol BuyersOrSellerOfferDelegate <NSObject>

- (void) buyersOrSellersOfferViewController: (BuyersOrSellersOfferViewController *) controller didOfferForItem: (PFObject *) object;

@end

@interface BuyersOrSellersOfferViewController : UIViewController <UITextFieldDelegate, APNumberPadDelegate>

@property (nonatomic, weak) id<BuyersOrSellerOfferDelegate> delegate;

@property (nonatomic, strong) WantData *wantData;

@property (nonatomic, strong) NSString *currOfferedPrice;
@property (nonatomic, strong) NSString *currOfferedDelivery;

@end
