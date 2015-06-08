//
//  SellersOfferViewController.h
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"

@class SellersOfferViewController;

@protocol SellerOfferViewControllerDelegate <NSObject>

- (void) sellerOfferViewController: (SellersOfferViewController *) controller didOfferForItem: (PFObject *) object;

@end

@interface SellersOfferViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<SellerOfferViewControllerDelegate> delegate;

@property (nonatomic, strong) WantData *wantData;

@property (nonatomic, strong) NSString *currOfferedPrice;
@property (nonatomic, strong) NSString *currOfferedDelivery;

@end
