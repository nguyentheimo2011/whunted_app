//
//  HashtagData.m
//  whunted
//
//  Created by thomas nguyen on 20/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "HashtagData.h"

#define kHashtagText                    @"hashtagText"
#define kHashtagType                    @"hashtagType"

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

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithDict:(NSDictionary *)dict
//-------------------------------------------------------------------------------------------------------------------------------
{
    return [self initWithText:dict[kHashtagText] andType:[self textToHashtagType:dict[kHashtagType]]];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSDictionary *) toDict
//-------------------------------------------------------------------------------------------------------------------------------
{
    return @{kHashtagText:_hashtagText, kHashtagType:[self hashtagTypeToText:_hashtagType]};
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *) hashtagTypeToText:(HashtagType)type
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (type == HashtagTypeBrand)
        return kHashtagTypeBrand;
    else if (type == HashtagTypeModel)
        return kHashtagTypeModel;
    else
        return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (HashtagType) textToHashtagType:(NSString *)text
//-------------------------------------------------------------------------------------------------------------------------------
{
    if ([text isEqualToString:kHashtagTypeBrand])
        return HashtagTypeBrand;
    else if ([text isEqualToString:kHashtagTypeModel])
        return HashtagTypeModel;
    else
        return HashtagTypeNone;
}

@end
