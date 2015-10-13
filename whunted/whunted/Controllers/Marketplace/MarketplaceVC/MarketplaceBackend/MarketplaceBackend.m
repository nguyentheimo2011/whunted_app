//
//  MarketplaceBackend.m
//  whunted
//
//  Created by thomas nguyen on 13/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceBackend.h"
#import "TransactionData.h"
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

@end
