//
//  MarketplaceBackend.h
//  whunted
//
//  Created by thomas nguyen on 13/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstant.h"

//------------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceBackend : NSObject
//------------------------------------------------------------------------------------------------------------------------------

+ (void) retrieveOfferByUser: (NSString *) userID forItem: (NSString *) itemID completionHandler: (TransactionHandler) compHandler;

+ (void) retrieveWhuntsWithQuery: (PFQuery *) query successHandler: (WhuntsHandler) succHandler failureHandler: (FailureHandler) failHandler;

@end
