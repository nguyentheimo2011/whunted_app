//
//  ProfileImageCache.h
//  whunted
//
//  Created by thomas nguyen on 17/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileImageCache : NSCache

+ (ProfileImageCache *) sharedCache;

@end
