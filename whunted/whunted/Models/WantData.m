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

- (id) initWithPFObject: (PFObject *) wantDataPFObject
{
    self = [super init];
    if (self != nil) {
        self.itemID = wantDataPFObject.objectId;
        self.itemName = wantDataPFObject[@"itemName"];
        self.itemDesc = wantDataPFObject[@"itemDesc"];
        self.itemCategory = wantDataPFObject[@"category"];
        self.demandedPrice = wantDataPFObject[@"demandedPrice"];
        self.paymentMethod = wantDataPFObject[@"paymentMethod"];
        self.meetingLocation = wantDataPFObject[@"meetingPlace"];
        self.itemPictureList = wantDataPFObject[@"itemPictures"];
        self.buyerID = wantDataPFObject[@"buyerID"];
        self.hashTagList = wantDataPFObject[@"hashtaglist"];
    }
    
    return self;
}



@end
