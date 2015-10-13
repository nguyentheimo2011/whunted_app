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
@interface MarketplaceViewController : UIViewController
//----------------------------------------------------------------------------------------------------------------------------
                                        <UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         UIScrollViewDelegate,
                                         CategoryTableViewControllerDelegate,
                                         SortAndFilterTableViewDelegate,
                                         CityViewDelegate,
                                         UISearchBarDelegate>

- (void) refreshWantData;

@end
