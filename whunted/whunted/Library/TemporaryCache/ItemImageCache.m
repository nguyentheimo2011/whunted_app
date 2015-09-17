//
//  TemporaryCache.m
//  whunted
//
//  Created by thomas nguyen on 1/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemImageCache.h"

@implementation ItemImageCache

//----------------------------------------------------------------------------------------------------------------------------
+ (ItemImageCache *) sharedCache
//----------------------------------------------------------------------------------------------------------------------------
{
    static ItemImageCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[ItemImageCache alloc] init];
    });
    
    return sharedCache;
}

@end
