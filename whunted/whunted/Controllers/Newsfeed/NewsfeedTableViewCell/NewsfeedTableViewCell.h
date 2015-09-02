//
//  NewsfeedTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 2/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TransactionData.h"

//-----------------------------------------------------------------------------------------------------------------------------
@interface NewsfeedTableViewCell : UITableViewCell
//-----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)       TransactionData     *transactionData;


- (id) initCellWithTransactionData: (TransactionData *) transactionData;

@end
