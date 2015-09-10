//
//  HistoryCollectionViewCell.h
//  whunted
//
//  Created by thomas nguyen on 14/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"

@interface HistoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)   WantData        *wantData;

@property (nonatomic)           NSInteger       cellIndex;


- (void) initCell;

@end
