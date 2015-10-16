//
//  MarketplaceBackend.h
//  whunted
//
//  Created by thomas nguyen on 13/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstant.h"
#import "WantData.h"

//------------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceBackend : NSObject
//------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Data Retrieval

+ (void) retrieveOfferByUser: (NSString *) userID forItem: (NSString *) itemID completionHandler: (TransactionHandler) compHandler;

+ (void) retrieveWhuntsWithQuery: (PFQuery *) query successHandler: (WhuntsHandler) succHandler failureHandler: (FailureHandler) failHandler;

#pragma mark - Query Creation

+ (PFQuery *) createQueryForWhuntsFromDictionary: (NSDictionary *) requirements;

+ (PFQuery *) createQueryForWhuntsFromSearchKeyword: (NSString *) searchKeyword;

+ (void) setBuyerLocationFilter: (NSString *) buyerLocation forQuery: (PFQuery *) query;

+ (void) setItemCategoryFilter: (NSString *) itemCategory forQuery: (PFQuery *) query;

+ (void) setProductOriginFilter: (NSString *) productOrigin forQuery: (PFQuery *) query;

+ (void) setSortingConditionForQuery: (PFQuery *) query withSortingChoice: (NSString *) sortingChoice;

+ (void) setConditionForQuery: (PFQuery *) query basedOnSortingChoice: (NSString *) sortingChoice andLastWhunt: (WantData *) wantData;

@end
