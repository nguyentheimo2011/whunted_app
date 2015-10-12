//
//  MarketplaceLogicHelper.m
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceLogicHelper.h"
#import "AppConstant.h"

@implementation MarketplaceLogicHelper

//-----------------------------------------------------------------------------------------------------------------------------
+ (BOOL) hasPhoneLanguageChangedRecently
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *currLang = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    NSString *lastLang = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_USED_IN_LAST_SESSION];
    BOOL languageChanged = NO;
    if (![currLang isEqualToString:lastLang])
    {
        languageChanged = YES;
        [[NSUserDefaults standardUserDefaults] setObject:currLang forKey:LANGUAGE_USED_IN_LAST_SESSION];
    }
    
    return languageChanged;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getBuyerLocationFilter: (BOOL) languageChanged
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *buyerLocation = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_BUYER_LOCATION_FILTER];
    
    if (languageChanged || buyerLocation.length == 0)
    {
        buyerLocation = NSLocalizedString(ITEM_BUYER_LOCATION_DEFAULT, nil);
        [[NSUserDefaults standardUserDefaults] setObject:buyerLocation forKey:CURRENT_BUYER_LOCATION_FILTER];
    }
    
    return buyerLocation;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getCategoryFilter:(BOOL)languageChanged
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *category = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_CATEGORY_FILTER];
    if (languageChanged || category.length == 0)
    {
        category = NSLocalizedString(ITEM_CATEGORY_ALL, nil);
        [[NSUserDefaults standardUserDefaults] setObject:category forKey:CURRENT_CATEGORY_FILTER];
    }
    
    return category;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getSortingChoice:(BOOL)languageChanged
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *sortingChoice = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_SORTING_BY];
    if (languageChanged || sortingChoice.length == 0)
    {
        sortingChoice = NSLocalizedString(SORTING_BY_RECENT, nil);
        [[NSUserDefaults standardUserDefaults] setObject:sortingChoice forKey:CURRENT_SORTING_BY];
    }
    
    return sortingChoice;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getProductOriginFilter:(BOOL)languageChanged
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *productOrigin = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_PRODUCT_ORIGIN_FILTER];
    if (languageChanged || productOrigin.length == 0)
    {
        productOrigin = NSLocalizedString(ITEM_PRODUCT_ORIGIN_ALL, nil);
        [[NSUserDefaults standardUserDefaults] setObject:productOrigin forKey:CURRENT_PRODUCT_ORIGIN_FILTER];
    }
    
    return productOrigin;
}

@end
