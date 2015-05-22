//
//  BuyingData.m
//  whunted
//
//  Created by thomas nguyen on 6/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "WantData.h"

@implementation WantData

- (id) init
{
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (id) initWithItemID: (NSString *) itemID andItemCategory: (NSString *) itemCat andItemName: (NSString *) itemName andBuyerID: (NSString *) buyerID
{
    self = [super init];
    if (self != nil) {
        self.itemID = itemID;
        self.itemCategory = itemCat;
        self.itemName = itemName;
        self.buyerID = buyerID;
    }
    
    return self;
}

@end
