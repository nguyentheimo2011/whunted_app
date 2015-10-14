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
#import "Utilities.h"

@implementation MarketplaceBackend

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

@end
