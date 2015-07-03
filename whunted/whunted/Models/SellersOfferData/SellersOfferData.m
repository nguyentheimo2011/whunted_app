//
//  SellersOfferData.m
//  whunted
//
//  Created by thomas nguyen on 4/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellersOfferData.h"
#import "AppConstant.h"

@implementation SellersOfferData

@synthesize objectID = _objectID;
@synthesize itemID = _itemID;
@synthesize buyerID = _buyerID;
@synthesize sellerID = _sellerID;
@synthesize initiatorID = _initiatorID;
@synthesize offeredPrice = _offeredPrice;
@synthesize deliveryTime = _deliveryTime;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithPFObject: (PFObject *) pfObj
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        _objectID = pfObj.objectId;
        _itemID = pfObj[PF_ITEM_ID];
        _buyerID = pfObj[PF_BUYER_ID];
        _sellerID = pfObj[PF_SELLER_ID];
        _initiatorID = pfObj[PF_INITIATOR_ID];
        _offeredPrice = pfObj[PF_OFFERED_PRICE];
        _deliveryTime = pfObj[PF_DELIVERY_TIME];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (PFObject *) getPFObjectWithClassName: (NSString *) className
//------------------------------------------------------------------------------------------------------------------------------
{
    PFObject *pfObj = [PFObject objectWithClassName:className];
    pfObj[PF_ITEM_ID] = _itemID;
    pfObj[PF_BUYER_ID] = _buyerID;
    pfObj[PF_SELLER_ID] = _sellerID;
    pfObj[PF_INITIATOR_ID] = _initiatorID;
    pfObj[PF_OFFERED_PRICE] = _offeredPrice;
    pfObj[PF_DELIVERY_TIME] = _deliveryTime;
    
    return pfObj;
}



@end
