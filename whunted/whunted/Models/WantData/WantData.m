//
//  BuyingData.m
//  whunted
//
//  Created by thomas nguyen on 6/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "WantData.h"
#import "AppConstant.h"

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
        self.itemName = wantDataPFObject[PF_ITEM_NAME];
        self.itemDesc = wantDataPFObject[PF_ITEM_DESC];
        self.itemCategory = wantDataPFObject[PF_ITEM_CATEGORY];
        self.demandedPrice = wantDataPFObject[PF_ITEM_DEMANDED_PRICE];
        self.paymentMethod = wantDataPFObject[PF_ITEM_PAYMENT_METHOD];
        self.meetingLocation = wantDataPFObject[PF_ITEM_MEETING_PLACE];
        self.itemPictureList = wantDataPFObject[PF_ITEM_PICTURE_LIST];
        self.itemPicturesNum = [wantDataPFObject[PF_ITEM_PICTURES_NUM] integerValue];
        self.buyer = wantDataPFObject[PF_ITEM_BUYER_ID];
        self.hashTagList = [NSArray arrayWithArray:wantDataPFObject[PF_ITEM_HASHTAG_LIST]];
        self.sellersNum = [wantDataPFObject[PF_ITEM_SELLERS_NUM] integerValue];
        
        NSString *dealClosed = wantDataPFObject[PF_ITEM_CLOSED_DEAL];
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
    wantDataPFObject[PF_ITEM_NAME] = self.itemName;
    wantDataPFObject[PF_ITEM_DESC] = self.itemDesc;
    wantDataPFObject[PF_ITEM_CATEGORY] = self.itemCategory;
    wantDataPFObject[PF_ITEM_DEMANDED_PRICE] = self.demandedPrice;
    wantDataPFObject[PF_ITEM_PAYMENT_METHOD] = self.paymentMethod;
    wantDataPFObject[PF_ITEM_MEETING_PLACE] = self.meetingLocation;
    wantDataPFObject[PF_ITEM_BUYER_ID] = self.buyer;
    wantDataPFObject[PF_ITEM_HASHTAG_LIST] = self.hashTagList;
    wantDataPFObject[PF_ITEM_SELLERS_NUM] = [NSString stringWithFormat:@"%ld", self.sellersNum];
    wantDataPFObject[PF_ITEM_PICTURES_NUM] = [NSString stringWithFormat:@"%ld", self.itemPicturesNum];
    
    if (self.isDealClosed) {
        wantDataPFObject[PF_ITEM_CLOSED_DEAL] = @"YES";
    } else {
        wantDataPFObject[PF_ITEM_CLOSED_DEAL] = @"NO";
    }
    
    PFRelation *relation = [wantDataPFObject relationForKey:PF_ITEM_PICTURE_LIST];
    for (PFObject *obj in self.backupItemPictureList) {
        [relation addObject:obj];
    }
    
    return wantDataPFObject;
}



@end
