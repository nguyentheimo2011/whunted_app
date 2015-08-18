//
//  BuyingData.h
//  whunted
//
//  Created by thomas nguyen on 6/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "OfferData.h"

@interface WantData : NSObject

@property (nonatomic, strong) NSString          *itemID;
@property (nonatomic, strong) NSString          *buyerID;
@property (nonatomic, strong) NSString          *buyerUsername;
@property (nonatomic, strong) NSString          *itemName;
@property (nonatomic, strong) NSString          *itemDesc;
@property (nonatomic)         BOOL              secondHandOption;
@property (nonatomic, strong) NSString          *itemCategory;
@property (nonatomic, strong) NSString          *demandedPrice;
@property (nonatomic, strong) NSString          *paymentMethod;
@property (nonatomic, strong) NSString          *referenceURL;
@property (nonatomic, strong) NSString          *meetingLocation;
@property (nonatomic, strong) NSDate            *createdDate;
@property (nonatomic, strong) NSDate            *updatedDate;

@property (nonatomic, strong) PFRelation        *itemPictureList;
@property (nonatomic, strong) NSMutableArray    *backupItemPictureList;
@property (nonatomic)         NSInteger         itemPicturesNum;

@property (nonatomic, strong) NSArray           *hashTagList;

@property (nonatomic, strong) NSArray           *productOriginList;

@property (nonatomic)         NSInteger         likesNum;
@property (nonatomic, strong) NSMutableArray    *likerList;

@property (nonatomic, strong) NSArray           *sellersOfferList;
@property (nonatomic)         NSInteger         sellersNum;

@property (nonatomic)         BOOL              isDealClosed;
@property (nonatomic, strong) OfferData         *acceptedOffer;

- (id) initWithPFObject: (PFObject *) wantDataPFObject;
- (PFObject *) getPFObject;

@end
