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

+ (BOOL)        hasPhoneLanguageChangedRecently;

+ (NSString *)  getBuyerLocationFilter: (BOOL) languageChanged;

+ (NSString *)  getCategoryFilter: (BOOL) languageChanged;

+ (NSString *)  getSortingChoice: (BOOL) languageChanged;

+ (NSString *)  getProductOriginFilter: (BOOL) languageChanged;

@end