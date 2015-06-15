//
//  AppConstant.h
//  whunted
//
//  Created by thomas nguyen on 15/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#ifndef whunted_AppConstant_h
#define whunted_AppConstant_h

//-----------------------------------------------------------------------------------------------------------------------------
#define APP_COLOR               [UIColor colorWithRed:36.0/255 green:59.0/255 blue:100.0/255 alpha:1.0]
#define APP_COLOR_2             [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]
#define APP_COLOR_3             [UIColor colorWithRed:192.0/255 green:192.0/255 blue:192.0/255 alpha:1.0]
#define APP_COLOR_4             [UIColor colorWithRed:215.0/255 green:215.0/255 blue:215.0/255 alpha:1.0]
#define APP_COLOR_5             [UIColor colorWithRed:52.0/255 green:68.0/255 blue:105.0/255 alpha:1.0]
#define APP_COLOR_6             [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define WINSIZE                 [[UIScreen mainScreen] bounds].size

//-----------------------------------------------------------------------------------------------------------------------------
#define ITEM_NAME_KEY           @"itemName"
#define ITEM_DESC_KEY           @"itemDescription"
#define ITEM_HASH_TAG_KEY       @"itemHashTag"
#define ITEM_CATEGORY_KEY       @"itemCategory"
#define ITEM_PRICE_KEY          @"itemPrice"
#define ITEM_LOCATION_KEY       @"location"
#define ITEM_ESCROW_OPTION_KEY  @"escrowOption"

//-----------------------------------------------------------------------------------------------------------------------------
#define ACCEPTABLE_CHARECTERS   @"0123456789."

//-----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    PhotoLibrary,
    Camera,
    ImageURL
} ImageGettingMethod;

#endif
