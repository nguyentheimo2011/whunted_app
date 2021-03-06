//
//  MarketplaceCollectionViewCell.h
//  whunted
//
//  Created by thomas nguyen on 1/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"

//----------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceCollectionViewCell : UICollectionViewCell
//----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)   WantData            *wantData;
@property (nonatomic)           NSInteger           cellIndex;
@property (nonatomic, strong)   NSString            *cellIdentifier;
@property (nonatomic, strong)   PFUser              *profileOwner;

- (void) initCell;

- (void) clearCellUI;

@end
