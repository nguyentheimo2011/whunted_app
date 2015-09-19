//
//  SyncEngine.m
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SyncEngine.h"
#import "AppConstant.h"

#import <Parse/Parse.h>

@implementation SyncEngine

@synthesize syncInProgess = _syncInProgess;

//----------------------------------------------------------------------------------------------------------------------------
+ (SyncEngine *) sharedEngine
//----------------------------------------------------------------------------------------------------------------------------

{
    static SyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SyncEngine alloc] init];
    });
    
    return sharedEngine;
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) startSync
//----------------------------------------------------------------------------------------------------------------------------
{
    if (!_syncInProgess) {
        [self willChangeValueForKey:SYNC_IN_PROGRESS];
        _syncInProgess = YES;
        [self didChangeValueForKey:SYNC_IN_PROGRESS];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadData];
        });
    }
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) downloadData
//----------------------------------------------------------------------------------------------------------------------------
{
//    [self downloadMyOffersData];
    [self downloadUserProfilePicture];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) downloadMyOffersData
//----------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [query whereKey:PF_SELLER_ID equalTo:[PFUser currentUser].objectId];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error) {
             for (PFObject *obj in objects) {
                 [obj pinInBackgroundWithName:PF_ONGOING_TRANSACTION_CLASS];
             }
             [self executeSyncCompletionOperations];
         } else {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) downloadUserProfilePicture
//----------------------------------------------------------------------------------------------------------------------------
{
    PFUser *currUser = [PFUser currentUser];
    PFFile *imageFile = currUser[PF_USER_PICTURE];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        [self executeSyncCompletionOperations];
    }];
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) downloadMyAcceptedOffersData
//----------------------------------------------------------------------------------------------------------------------------
{
    
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) downloadMyWantData
//----------------------------------------------------------------------------------------------------------------------------
{
    
}

//----------------------------------------------------------------------------------------------------------------------------
- (void) executeSyncCompletionOperations
//----------------------------------------------------------------------------------------------------------------------------
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self willChangeValueForKey:SYNC_IN_PROGRESS];
        _syncInProgess = NO;
        [self didChangeValueForKey:SYNC_IN_PROGRESS];
    });
}


@end
