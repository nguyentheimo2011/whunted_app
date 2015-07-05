//
//  ChatAdditionalData.h
//  whunted
//
//  Created by thomas nguyen on 5/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatAdditionalData : NSObject

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *originalDemandedPrice;
@property (nonatomic, strong) NSString *buyerID;

@end
