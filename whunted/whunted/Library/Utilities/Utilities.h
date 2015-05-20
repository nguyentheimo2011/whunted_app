//
//  Utilities.h
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PhotoLibrary,
    Camera,
    ImageURL
} ImageGettingMethod;

#define ITEM_NAME_KEY           @"itemName"
#define ITEM_DESC_KEY           @"itemDescription"
#define ITEM_HASH_TAG_KEY       @"itemHashTag"
#define ITEM_CATEGORY_KEY       @"itemCategory"
#define ITEM_PRICE_KEY          @"itemPrice"
#define ITEM_LOCATION_KEY       @"location"
#define ITEM_ESCROW_OPTION_KEY  @"escrowOption"

@interface Utilities : NSObject

+ (void) addBorderAndShadow: (UIView *) view;
+ (void) setTopRoundedCorner: (UIView *) view;

@end
