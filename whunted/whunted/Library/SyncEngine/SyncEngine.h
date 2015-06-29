//
//  SyncEngine.h
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgess;

+ (SyncEngine *) sharedEngine;

- (void) startSync;

@end
