//
//  SellersOfferData.h
//  whunted
//
//  Created by thomas nguyen on 4/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface TransactionData : NSObject

@property (nonatomic, strong)   NSString    *objectID;
@property (nonatomic, strong)   NSString    *itemID;
@property (nonatomic, strong)   NSString    *itemName;
@property (nonatomic, strong)   NSString    *originalDemandedPrice;
@property (nonatomic, strong)   NSString    *buyerID;
@property (nonatomic, strong)   NSString    *sellerID;
@property (nonatomic, strong)   NSString    *initiatorID;
@property (nonatomic, strong)   NSString    *offeredPrice;
@property (nonatomic, strong)   NSString    *deliveryTime;
@property (nonatomic, strong)   NSString    *offerStatus;

- (id)          initWithPFObject: (PFObject *) pfObj;
- (PFObject *)  getPFObjectWithClassName: (NSString *) className;

@end
