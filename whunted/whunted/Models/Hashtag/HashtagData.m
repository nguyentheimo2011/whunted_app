//
//  HashtagData.m
//  whunted
//
//  Created by thomas nguyen on 20/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "HashtagData.h"

@implementation HashtagData

@synthesize hashtagText = _hashtagText;
@synthesize hashtagType = _hashtagType;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithText: (NSString *) text andType: (HashtagType) type
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self) {
        _hashtagText = text;
        _hashtagType = type;
    }
    
    return self;
}

@end
