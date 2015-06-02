//
//  MarketplaceViewController.h
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "GenericController.h"

@interface MarketplaceViewController : GenericController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *wantDataList;

@end
