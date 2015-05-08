//
//  BuyingData.h
//  whunted
//
//  Created by thomas nguyen on 6/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyingData : NSObject

@property (nonatomic, strong) NSString *buyerID;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *demandedPrice;
@property (nonatomic, strong) NSMutableArray *viewerList;
@property (nonatomic, strong) NSMutableArray *likerList;
@property (nonatomic, strong) NSMutableArray *supplierList;

@end
