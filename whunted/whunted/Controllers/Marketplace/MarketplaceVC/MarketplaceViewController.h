//
//  MarketplaceViewController.h
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "GenericController.h"
#import "MarketplaceCollectionViewCell.h"
#import "ItemDetailsViewController.h"

@protocol MarketplaceViewDelegate <NSObject>

- (void) marketPlaceUserDidOfferForAnItem;

@end

@interface MarketplaceViewController : GenericController <UICollectionViewDataSource, UICollectionViewDelegate, ItemDetailsViewControllerDelegate>

@property (nonatomic, weak) id<MarketplaceViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray    *wantDataList;

- (void) updateWantDataTable;

@end
