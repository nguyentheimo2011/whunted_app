//
//  SellersOfferData.h
//  whunted
//
//  Created by thomas nguyen on 4/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SellersOfferData : NSObject

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *sellerID;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *offeredPrice;
@property (nonatomic, strong) NSString *deliveryTime;

- (id) initWithPFObject: (PFObject *) pfObj;
- (PFObject *) getPFObject;

@end
