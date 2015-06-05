//
//  SellersOfferData.m
//  whunted
//
//  Created by thomas nguyen on 4/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellersOfferData.h"

@implementation SellersOfferData

@synthesize objectID;
@synthesize sellerID;
@synthesize itemID;
@synthesize offeredPrice;
@synthesize deliveryTime;

- (id) init
{
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (id) initWithPFObject: (PFObject *) pfObj
{
    self = [super init];
    if (self != nil) {
        self.objectID = pfObj.objectId;
        self.sellerID = pfObj[@"sellerID"];
        self.itemID = pfObj[@"itemID"];
        self.offeredPrice = pfObj[@"offeredPrice"];
        self.deliveryTime = pfObj[@"deliveryTime"];
    }
    
    return self;
}

- (PFObject *) getPFObjectWithClassName: (NSString *) className
{
    PFObject *pfObj = [PFObject objectWithClassName:className];
    pfObj[@"sellerID"] = self.sellerID;
    pfObj[@"itemID"] = self.itemID;
    pfObj[@"offeredPrice"] = self.offeredPrice;
    pfObj[@"deliveryTime"] = self.deliveryTime;
    
    return pfObj;
}



@end
