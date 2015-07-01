//
//  TemporaryCache.m
//  whunted
//
//  Created by thomas nguyen on 1/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "TemporaryCache.h"

@implementation TemporaryCache

+ (TemporaryCache *) sharedCache
{
    static TemporaryCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[TemporaryCache alloc] init];
    });
    
    return sharedCache;
}

@end
