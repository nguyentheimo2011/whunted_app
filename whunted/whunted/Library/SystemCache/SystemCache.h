//
//  SystemCache.h
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemCache : NSCache

+ (SystemCache *) sharedCache;

@end
