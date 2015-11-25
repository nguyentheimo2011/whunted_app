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

//------------------------------------------------------------------------------------------------------------------------------
@interface ItemDetailsViewController : UIViewController<UIPageViewControllerDataSource, BuyersOrSellerOfferDelegate, UploadingWantDetailsViewControllerDelegate>
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)   WantData                *wantData;
@property (nonatomic)           NSInteger               itemImagesNum;
@property (nonatomic)           BOOL                    bottomButtonsNotNeeded;
@property (nonatomic, strong)   NSString                *viewControllerName;
@property (nonatomic)           TransactionData         *currOffer;

@end
