//
//  TemporaryCache.h
//  whunted
//
//  Created by thomas nguyen on 1/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemImageCache : NSCache

+ (ItemImageCache *) sharedCache;

@end
