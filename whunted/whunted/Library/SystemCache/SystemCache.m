//
//  SystemCache.m
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SystemCache.h"

@implementation SystemCache

+ (SystemCache *) sharedCache
{
    static SystemCache *sharedCache;    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[SystemCache alloc] init];
    });
    
    return sharedCache;
}

@end
