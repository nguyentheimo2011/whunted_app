//
//  BuyingData.h
//  whunted
//
//  Created by thomas nguyen on 6/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "TransactionData.h"

@interface WantData : NSObject

// properties of wanted item
@property (nonatomic, strong)   NSString          *itemID;
@property (nonatomic, strong)   NSString          *itemName;
@property (nonatomic, strong)   NSString          *itemDesc;
@property (nonatomic, strong)   NSString          *itemCategory;
@property (nonatomic, strong)   NSArray           *itemOrigins;
@property (nonatomic, strong)   NSMutableArray    *itemPictures;
@property (nonatomic)           NSInteger         itemPicturesNum;
@property (nonatomic, strong)   NSArray           *hashTagList;
@property (nonatomic, strong)   NSString          *referenceURL;

// properties of a want
@property (nonatomic, strong)   NSString          *buyerID;
@property (nonatomic, strong)   NSString          *buyerUsername;
@property (nonatomic, strong)   NSString          *demandedPrice;
@property (nonatomic, strong)   NSString          *paymentMethod;
@property (nonatomic)           BOOL              acceptedSecondHand;
@property (nonatomic, strong)   NSString          *meetingLocation;
@property (nonatomic, strong)   NSDate            *createdDate;
@property (nonatomic, strong)   NSDate            *updatedDate;

// properties of a post
@property (nonatomic)           NSInteger         likesNum;
@property (nonatomic, strong)   NSMutableArray    *likerList;

// properties of a transaction
@property (nonatomic, strong)   NSArray           *sellersOfferList;
@property (nonatomic)           NSInteger         sellersNum;

@property (nonatomic)           BOOL              isFulfilled;
@property (nonatomic, strong)   TransactionData         *acceptedOffer;

// Temprary data sturetures
@property (nonatomic, strong)   PFRelation        *itemPictureList;


- (id) initWithPFObject: (PFObject *) wantDataPFObject;
- (PFObject *) getPFObject;

- (NSComparisonResult) compareBasedOnRecent: (WantData *) otherWantData;
- (NSComparisonResult) compareBasedOnPopular: (WantData *) otherWantData;
- (NSComparisonResult) compareBasedOnAscendingPrice: (WantData *) otherWantData;
- (NSComparisonResult) compareBasedOnDescendingPrice: (WantData *) otherWantData;

@end
