//
//  BuyingData.m
//  whunted
//
//  Created by thomas nguyen on 6/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "WantData.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation WantData

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithPFObject: (PFObject *) wantDataPFObject
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        self.itemID                 =       wantDataPFObject.objectId;
        self.itemName               =       wantDataPFObject[PF_ITEM_NAME];
        self.itemDesc               =       wantDataPFObject[PF_ITEM_DESC];
        self.itemCategory           =       wantDataPFObject[PF_ITEM_CATEGORY];
        self.itemOrigins            =       [wantDataPFObject[PF_ITEM_ORIGINS] componentsSeparatedByString:COMMA_CHARACTER];
        self.itemPictureList        =       wantDataPFObject[PF_ITEM_PICTURE_LIST];
        self.itemPicturesNum        =       [wantDataPFObject[PF_ITEM_PICTURES_NUM] integerValue];
        self.hashTagList            =       [NSArray arrayWithArray:wantDataPFObject[PF_ITEM_HASHTAG_LIST]];
        self.referenceURL           =       wantDataPFObject[PF_ITEM_REFERENCE_URL];
        
        self.buyerID                =       wantDataPFObject[PF_ITEM_BUYER_ID];
        self.buyerUsername          =       wantDataPFObject[PF_ITEM_BUYER_USERNAME];
        self.demandedPrice          =       [Utilities formattedPriceFromNumber:wantDataPFObject[PF_ITEM_DEMANDED_PRICE]];
        self.acceptedSecondHand     =       [wantDataPFObject[PF_ITEM_ACCEPTED_SECONDHAND] boolValue];
        self.meetingLocation        =       wantDataPFObject[PF_ITEM_MEETING_PLACE];
       
        self.sellersNum             =       [wantDataPFObject[PF_ITEM_SELLERS_NUM] integerValue];
        self.likesNum               =       [wantDataPFObject[PF_ITEM_LIKES_NUM] integerValue];
        self.createdDate            =       wantDataPFObject.createdAt;
        self.updatedDate            =       wantDataPFObject.updatedAt;
        
        self.isFulfilled            =       [Utilities booleanFromYesNoString:wantDataPFObject[PF_ITEM_IS_FULFILLED]];
        self.itemIsDeleted          =       [Utilities booleanFromYesNoString:wantDataPFObject[PF_ITEM_IS_DELETED]];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (PFObject *) getPFObject
//------------------------------------------------------------------------------------------------------------------------------
{
    PFObject *wantDataPFObject = [PFObject objectWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    
    wantDataPFObject.objectId                       =       self.itemID;
    wantDataPFObject[PF_ITEM_NAME]                  =       self.itemName;
    wantDataPFObject[PF_ITEM_DESC]                  =       self.itemDesc;
    wantDataPFObject[PF_ITEM_CATEGORY]              =       self.itemCategory;
    wantDataPFObject[PF_ITEM_ORIGINS]               =       [self.itemOrigins componentsJoinedByString:COMMA_CHARACTER];
    wantDataPFObject[PF_ITEM_PICTURES_NUM]          =       [NSString stringWithFormat:@"%ld", self.itemPicturesNum];
    wantDataPFObject[PF_ITEM_HASHTAG_LIST]          =       self.hashTagList;
    wantDataPFObject[PF_ITEM_REFERENCE_URL]         =       self.referenceURL;
    
    wantDataPFObject[PF_ITEM_BUYER_ID]              =       self.buyerID;
    wantDataPFObject[PF_ITEM_BUYER_USERNAME]        =       self.buyerUsername;
    wantDataPFObject[PF_ITEM_DEMANDED_PRICE]        =       [Utilities numberFromFormattedPrice:self.demandedPrice];
    wantDataPFObject[PF_ITEM_ACCEPTED_SECONDHAND]   =       [Utilities stringFromBoolean:self.acceptedSecondHand];
    wantDataPFObject[PF_ITEM_MEETING_PLACE]         =       self.meetingLocation;
    
    wantDataPFObject[PF_ITEM_SELLERS_NUM]           =       [NSString stringWithFormat:@"%ld", self.sellersNum];
    wantDataPFObject[PF_ITEM_LIKES_NUM]             =       [NSString stringWithFormat:@"%ld", self.likesNum];
    
    
    wantDataPFObject[PF_ITEM_IS_FULFILLED]          =       [Utilities stringFromBoolean:self.isFulfilled];
    wantDataPFObject[PF_ITEM_IS_DELETED]            =       [Utilities stringFromBoolean:self.itemIsDeleted];
    
    PFRelation *relation = [wantDataPFObject relationForKey:PF_ITEM_PICTURE_LIST];
    for (PFObject *obj in self.itemPictures)
        [relation addObject:obj];
    
    return wantDataPFObject;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSComparisonResult) compareBasedOnRecent:(WantData *)otherWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    return [otherWantData.createdDate compare:self.createdDate];
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSComparisonResult) compareBasedOnPopular:(WantData *)otherWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    if (self.likesNum > otherWantData.likesNum)
        return NSOrderedAscending;
    else if (self.likesNum == otherWantData.likesNum)
        return NSOrderedSame;
    else
        return NSOrderedDescending;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSComparisonResult) compareBasedOnAscendingPrice:(WantData *)otherWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    float selfPrice = [Utilities floatingNumFromDemandedPrice:self.demandedPrice];
    float otherPrice = [Utilities floatingNumFromDemandedPrice:otherWantData.demandedPrice];
    
    if ( selfPrice > otherPrice)
        return NSOrderedDescending;
    else if (selfPrice == otherPrice)
        return NSOrderedSame;
    else
        return NSOrderedAscending;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSComparisonResult) compareBasedOnDescendingPrice:(WantData *)otherWantData
//------------------------------------------------------------------------------------------------------------------------------
{
    float selfPrice = [Utilities floatingNumFromDemandedPrice:self.demandedPrice];
    float otherPrice = [Utilities floatingNumFromDemandedPrice:otherWantData.demandedPrice];
    
    if (selfPrice > otherPrice)
        return NSOrderedAscending;
    else if (selfPrice == otherPrice)
        return NSOrderedSame;
    else
        return NSOrderedDescending;
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) matchSearchTerm: (NSString *) searchTerm
//------------------------------------------------------------------------------------------------------------------------------
{
    if (searchTerm.length == 0)
        return YES;
    
    NSString *lowercasedSearchTerm = [searchTerm lowercaseString];
    
    if ([[_itemName lowercaseString] containsString:lowercasedSearchTerm])
        return YES;
    else if ([[_itemDesc lowercaseString] containsString:lowercasedSearchTerm])
        return YES;
    else
    {
        for (NSString *hashtag in _hashTagList)
            if ([[hashtag lowercaseString] containsString:lowercasedSearchTerm])
                return YES;
    }
    
    return NO;
}


@end
