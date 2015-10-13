//
//  MarketplaceLogicHelper.h
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------------------------------------------------------------------------------------------
@interface MarketplaceLogicHelper : NSObject
//-----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Info Retrieving Functions
//-----------------------------------------------------------------------------------------------------------------------------

+ (BOOL)        hasPhoneLanguageChangedRecently;

+ (NSString *)  getBuyerLocationFilter: (BOOL) languageChanged;

+ (NSString *)  getCategoryFilter: (BOOL) languageChanged;

+ (NSString *)  getSortingChoice: (BOOL) languageChanged;

+ (NSString *)  getProductOriginFilter: (BOOL) languageChanged;

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Sort and Filter Functions
//-----------------------------------------------------------------------------------------------------------------------------

+ (NSArray *) sortArray: (NSArray *) array by: (NSString *) sortingChoice;

+ (NSArray *) filterArray: (NSArray *) array byCategory: (NSString *) category;

+ (NSArray *) filterArray: (NSArray *) array byProductOrigin: (NSString *) productOrigin;

+ (NSArray *) filterArray: (NSArray *) array byBuyerLocation: (NSString *) buyerLocation;

@end
