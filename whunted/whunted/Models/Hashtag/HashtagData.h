//
//  HashtagData.h
//  whunted
//
//  Created by thomas nguyen on 20/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstant.h"

@interface HashtagData : NSObject

@property (nonatomic, strong)   NSString    *hashtagText;
@property (nonatomic)           HashtagType hashtagType;

- (id) initWithText: (NSString *) text andType: (HashtagType) type;

@end
