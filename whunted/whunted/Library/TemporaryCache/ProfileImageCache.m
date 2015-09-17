//
//  ProfileImageCache.m
//  whunted
//
//  Created by thomas nguyen on 17/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ProfileImageCache.h"

@implementation ProfileImageCache

//----------------------------------------------------------------------------------------------------------------------------
+ (ProfileImageCache *) sharedCache
//----------------------------------------------------------------------------------------------------------------------------
{
    static ProfileImageCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[ProfileImageCache alloc] init];
    });
    
    return sharedCache;
}

@end
