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

- (id) initWithItemID: (NSString *) itemID andItemCategory: (NSString *) itemCat andItemName: (NSString *) itemName andBuyerID: (PFUser *) buyerID
{
    self = [super init];
    if (self != nil) {
        self.itemID = itemID;
        self.itemCategory = itemCat;
        self.itemName = itemName;
        self.buyer = buyerID;
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
        self.productOrigin = wantDataPFObject[@"productOrigin"];
        self.demandedPrice = wantDataPFObject[@"demandedPrice"];
        self.paymentMethod = wantDataPFObject[@"paymentMethod"];
        self.meetingLocation = wantDataPFObject[@"meetingPlace"];
        self.itemPictureList = wantDataPFObject[@"itemPictures"];
        self.buyer = wantDataPFObject[@"buyerID"];
        self.hashTagList = [NSArray arrayWithArray:wantDataPFObject[@"hashtaglist"]];
        
        NSString *dealClosed = wantDataPFObject[@"isDealClosed"];
        if ([dealClosed isEqual:@"YES"]) {
            self.isDealClosed = YES;
        } else {
            self.isDealClosed = NO;
        }
    }
    
    return self;
}

- (PFObject *) getPFObject
{
    PFObject *wantDataPFObject = [PFObject objectWithClassName:@"WantedPost"];
    wantDataPFObject.objectId = self.itemID;
    wantDataPFObject[@"itemName"] = self.itemName;
    wantDataPFObject[@"itemDesc"] = self.itemDesc;
    wantDataPFObject[@"category"] = self.itemCategory;
    wantDataPFObject[@"productOrigin"] = self.productOrigin;
    wantDataPFObject[@"demandedPrice"] = self.demandedPrice;
    wantDataPFObject[@"paymentMethod"] = self.paymentMethod;
    wantDataPFObject[@"meetingPlace"] = self.meetingLocation;
    wantDataPFObject[@"buyerID"] = self.buyer;
    wantDataPFObject[@"hashtaglist"] = self.hashTagList;
    
    if (self.isDealClosed) {
        wantDataPFObject[@"isDealClosed"] = @"YES";
    } else {
        wantDataPFObject[@"isDealClosed"] = @"NO";
    }
    
    PFRelation *relation = [wantDataPFObject relationForKey:@"itemPictures"];
    for (PFObject *obj in self.backupItemPictureList) {
        [relation addObject:obj];
    }
    
    return wantDataPFObject;
}



@end