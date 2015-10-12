//
//  MarketplaceViewController.h
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MarketplaceCollectionViewCell.h"
#import "ItemDetailsViewController.h"
#import "CategoryTableViewController.h"
#import "SortAndFilterTableVC.h"
#import "CityViewController.h"

//----------------------------------------------------------------------------------------------------------------------------
@protocol MarketplaceViewDelegate <NSObject>
//----------------------------------------------------------------------------------------------------------------------------

- (void) marketPlaceUserDidOfferForAnItem;

@end


//----------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceViewController : UIViewController
//----------------------------------------------------------------------------------------------------------------------------
                                        <UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         UIScrollViewDelegate,
                                         ItemDetailsViewControllerDelegate,
                                         CategoryTableViewControllerDelegate,
                                         SortAndFilterTableViewDelegate,
                                         CityViewDelegate,
                                         UISearchBarDelegate>

@property (nonatomic, weak) id<MarketplaceViewDelegate> delegate;

- (void) refreshWantData;

@end
