//
//  SystemCache.h
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersistedCache : NSObject

+ (PersistedCache *) sharedCache;

- (void) setImage: (UIImage *) image forKey: (NSString *) key;
- (UIImage *) imageForKey: (NSString *) key;

@end
