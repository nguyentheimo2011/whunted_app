//
//  MarketplaceBackend.m
//  whunted
//
//  Created by thomas nguyen on 13/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceBackend.h"
#import "TransactionData.h"
#import "WantData.h"
#import "SearchEngine.h"
#import "Utilities.h"

@implementation MarketplaceBackend


#pragma mark - Data Retrieval

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) retrieveOfferByUser:(NSString *)userID forItem:(NSString *)itemID completionHandler:(TransactionHandler)compHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *sQuery = [PFQuery queryWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [sQuery whereKey:PF_SELLER_ID equalTo:userID];
    [sQuery whereKey:PF_ITEM_ID equalTo:itemID];
    
    [sQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         TransactionData *offer;
         
         if (!error)
         {
             if (objects.count > 0)
             {
                 offer = [[TransactionData alloc] initWithPFObject:[objects objectAtIndex:0]];
             }
         }
         else
         {
             [Utilities handleError:error];
         }
         
         compHandler(offer);
     }];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) retrieveWhuntsWithQuery:(PFQuery *)query successHandler:(WhuntsHandler)succHandler failureHandler:(FailureHandler)failHandler
//-----------------------------------------------------------------------------------------------------------------------------
{
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             NSMutableArray *whuntsList = [NSMutableArray array];
             
             for (PFObject *object in objects)
             {
                 WantData *wantData = [[WantData alloc] initWithPFObject:object];
                 [whuntsList addObject:wantData];
             }
             
             succHandler(whuntsList);
         }
         else
         {
             // Log details of the failure
             [Utilities handleError:error];
             
             failHandler(error);
         }
     }];
}


#pragma mark - Query Creation

//-----------------------------------------------------------------------------------------------------------------------------
+ (PFQuery *) createQueryForWhuntsFromDictionary:(NSDictionary *)requirements
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSArray *allKeys = [requirements allKeys];
    PFQuery *query;
    if ([allKeys containsObject:SEARCH_KEYWORD])
    {
        NSString *searchKeyword = [requirements objectForKey:SEARCH_KEYWORD];
        query = [MarketplaceBackend createQueryForWhuntsFromSearchKeyword:searchKeyword];
        [query whereKey:PF_ITEM_IS_DELETED equalTo:STRING_OF_NO];
    }
    else
    {
        query = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
        [query whereKey:PF_ITEM_IS_DELETED equalTo:STRING_OF_NO];
    }
    
    if ([allKeys containsObject:BUYER_LOCATION_FILTER])
    {
        NSString *buyerLocation = [requirements objectForKey:BUYER_LOCATION_FILTER];
        if (![buyerLocation isEqualToString:NSLocalizedString(ITEM_BUYER_LOCATION_DEFAULT, nil)])
            [MarketplaceBackend setBuyerLocationFilter:buyerLocation forQuery:query];
    }
    
    if ([allKeys containsObject:ITEM_CATEGORY_FILTER])
    {
        NSString *category = [requirements objectForKey:ITEM_CATEGORY_FILTER];
        if (![category isEqualToString:NSLocalizedString(ITEM_CATEGORY_ALL, nil)])
            [MarketplaceBackend setItemCategoryFilter:category forQuery:query];
    }
    
    if ([allKeys containsObject:PRODUCT_ORIGIN_FILTER])
    {
        NSString *productOrigin = [requirements objectForKey:PRODUCT_ORIGIN_FILTER];
        if (![productOrigin isEqualToString:NSLocalizedString(ITEM_PRODUCT_ORIGIN_ALL, nil)])
            [MarketplaceBackend setProductOriginFilter:productOrigin forQuery:query];
    }
    
    if ([allKeys containsObject:SORTING_CHOICE])
    {
        NSString *sortingChoice = [requirements objectForKey:SORTING_CHOICE];
        [MarketplaceBackend setSortingConditionForQuery:query withSortingChoice:sortingChoice];
        
        if ([allKeys containsObject:LAST_LOADED_WHUNT])
        {
            WantData *wantData = [requirements objectForKey:LAST_LOADED_WHUNT];
            [MarketplaceBackend setConditionForQuery:query basedOnSortingChoice:sortingChoice andLastWhunt:wantData];
        }
    }
    
    [query setLimit:NUM_OF_WHUNTS_IN_EACH_LOADING_TIME];
    
    return query;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (PFQuery *) createQueryForWhuntsFromSearchKeyword:(NSString *)searchKeyword
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *regex = [SearchEngine createRegexFromSearchKeyword:searchKeyword];
    
    PFQuery *query1 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query1 whereKey:PF_ITEM_NAME matchesRegex:regex];
    
    PFQuery *query2 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query2 whereKey:PF_ITEM_DESC matchesRegex:regex];
    
    PFQuery *query3 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query3 whereKey:PF_ITEM_CATEGORY matchesRegex:regex];
    
    PFQuery *query4 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query4 whereKey:PF_ITEM_ORIGINS matchesRegex:regex];
    
    PFQuery *query5 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query5 whereKey:PF_ITEM_HASHTAG_LIST equalTo:searchKeyword];
    
    PFQuery *query6 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query6 whereKey:PF_ITEM_BUYER_USERNAME matchesRegex:regex];
    
    PFQuery *query7 = [PFQuery queryWithClassName:PF_ONGOING_WANT_DATA_CLASS];
    [query7 whereKey:PF_ITEM_MEETING_PLACE matchesRegex:regex];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2, query3, query4, query5, query6, query7]];
    return query;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) setBuyerLocationFilter:(NSString *)buyerLocation forQuery:(PFQuery *)query
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSRange range = [buyerLocation rangeOfString:COMMA_CHARACTER];
    if (range.location == NSNotFound)
    {
        // search for whunts in a country
        [query whereKey:PF_ITEM_MEETING_PLACE containsString:buyerLocation];
    }
    else
    {
        // search for whunts in a city
        [query whereKey:PF_ITEM_MEETING_PLACE equalTo:buyerLocation];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) setItemCategoryFilter:(NSString *)itemCategory forQuery:(PFQuery *)query
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *synonym = [Utilities getSynonymOfWord:itemCategory];
    NSString *compoundCategory = [NSString stringWithFormat:@"%@|%@", itemCategory, synonym];
    [query whereKey:PF_ITEM_CATEGORY matchesRegex:compoundCategory];
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) setProductOriginFilter:(NSString *)productOrigin forQuery:(PFQuery *)query
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSRange range = [productOrigin rangeOfString:COMMA_CHARACTER];
    if (range.location == NSNotFound)
    {
        // search for whunts in a country
        [query whereKey:PF_ITEM_ORIGINS containsString:productOrigin];
    }
    else
    {
        // search for whunts in a city
        [query whereKey:PF_ITEM_ORIGINS equalTo:productOrigin];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) setSortingConditionForQuery:(PFQuery *)query withSortingChoice:(NSString *)sortingChoice
//-----------------------------------------------------------------------------------------------------------------------------
{
    if ([sortingChoice isEqualToString:NSLocalizedString(SORTING_BY_RECENT, nil)])
    {
        [query orderByDescending:PF_CREATED_AT];
    }
    else if ([sortingChoice isEqualToString:NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil)])
    {
        [query orderByAscending:PF_ITEM_DEMANDED_PRICE];
    }
    else if ([sortingChoice isEqualToString:NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil)])
    {
        [query orderByDescending:PF_ITEM_DEMANDED_PRICE];
    }
    else
    {
        [query orderByDescending:PF_CREATED_AT];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) setConditionForQuery:(PFQuery *)query basedOnSortingChoice:(NSString *)sortingChoice andLastWhunt:(WantData *)wantData
//-----------------------------------------------------------------------------------------------------------------------------
{
    if ([sortingChoice isEqualToString:NSLocalizedString(SORTING_BY_RECENT, nil)])
    {
        [query whereKey:PF_CREATED_AT lessThan:wantData.createdDate];
    }
    else if ([sortingChoice isEqualToString:NSLocalizedString(SORTING_BY_LOWEST_PRICE, nil)])
    {
        [query whereKey:PF_ITEM_DEMANDED_PRICE greaterThanOrEqualTo:[Utilities numberFromFormattedPrice:wantData.demandedPrice]];
    }
    else if ([sortingChoice isEqualToString:NSLocalizedString(SORTING_BY_HIGHEST_PRICE, nil)])
    {
        [query whereKey:PF_ITEM_DEMANDED_PRICE lessThanOrEqualTo:[Utilities numberFromFormattedPrice:wantData.demandedPrice]];
    }
    else
    {
        [query whereKey:PF_CREATED_AT lessThan:wantData.createdDate];
    }
}


@end
